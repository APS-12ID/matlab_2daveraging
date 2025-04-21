function [isgood, str] = evaluate_12IDB_SAXSdata(avg, m)
% evaluate_12IDB_SAXSdata is to evaluate the quality of SAXS data.

    filename = fullfile(avg.dir, avg.filename);
    try
        phd = avg.photodiode;
        ic1 = avg.I0ofsample;
        expt = avg.expt;
    catch
        phd = -1;
        ic1 = -1;
        expt = -1;
    end
    if ischar(phd)
        phd = str2double(phd);
    end
    if ischar(ic1)
        ic1 = str2double(ic1);
    end
    if ischar(expt)
        expt = str2double(expt);
    end
    if expt <= 0
        expt = 1;
    end

    [datadir, fn, ext]=fileparts(filename);
    dfn = fn;
    dirN = 'SAXS';
    if strfind(filename, '/SAXS/')
        dtFileName = fullfile(datadir, dfn);
        datafilename = fullfile(datadir, [dfn, ext]);
    else
        dtFileName = fullfile(datadir, dirN, dfn);
        datafilename = fullfile(datadir, dirN, [dfn, ext]);
    end

%     if strfind(fn, dirN)
%         isgood = -1;
%         str = 'Not SAXS data';
%         return
%     end

% if nargin < 2
%     try
%         m = evalin('base', 'saxs');
%     catch 
%         m = [];
%     end
% end

    try
        sd=flipud(double(imread(datafilename)));
    catch
        sd = [];
        fprintf('File %s is not found\n', datafilename);
    end

    str = '';
    isgood = 0;
    if ~isempty(sd)
        % Read Log file.
%         ndir = strrep(dirn, [filesep, 'SAXS'], [filesep, 'Log']);
%         logfile = fullfile(ndir,...
%             filesep, ['L', dtFileName(2:end), '.meta']);
%         [phd, ic1, ~, expt] = parseMetafile(logfile);

        % Analyzie data
        if ~isempty(m)
            goodind = m.mask == 1 && m.qCMap < 0.1;
            sd = sd(goodind);
        end
        sd = sd(:);
        isgood = 1;
        maxv = max(sd);
        meanv = mean(sd);
        maxrate = max(sd/expt);
        str = {};
        if (ic1/expt) < 100
            str = [str, sprintf('I0 is lower than limit. %0.3f', ic1/expt)];
            str = [str, 'Check if the B station photon shutter open.'];
            isgood = 0;
        else
            if (expt > 0) && (phd/expt) < 100
                str = [str, sprintf('phd value is lower than limit. %0.3f', phd/expt)];
                str = [str, 'Check whether nozzle is in position or sample is too thick.'];
                isgood = 0;
            end
            if (meanv < 10)
                str = [str, 'Very low SAXS signals. Check with the sample or try longer exposure time.'];
                isgood = 0;
            end

            if (expt > 0) && (maxrate > 100000)
                str = [str, 'Too high count rate. Data saturated. Reduce beam flux.'];
                isgood = 0;
            end
            if (maxv > 1000000)
                str = [str, 'Too high count. Data saturated. Reduce exposure time.'];
                isgood = 0;
            end
            if (meanv > 100000)
                str = [str, 'Very high signals. Recommend to reduce exposure time.'];
                isgood = 0;
            end
        end
    end

%     axtext = findobj('tag', 'axStatusUpdate');
%     if ~isempty(axtext)
%         cla(axtext);
%     end
%     if ~isgood
%         text(0.3, 0.6, str, 'color', 'r', 'Parent', axtext)
%     end
    fid = fopen('~/.currentSAXSimageinfo', 'w');

    try
        fprintf(fid, 'Filename: %s\n', datafilename);
        fprintf(fid, '%s\n', [dtFileName, ext]);
        fprintf(fid, '%i\n', isgood);
        fprintf(fid, 'Max Value: %0.6f\n', maxv);
        fprintf(fid, 'Mean Value: %0.6f\n', meanv);
        fprintf(fid, 'Max Count Rate: %0.6f\n', maxrate);
        fprintf(fid, 'IC: %0.1f\n', ic1);
        fprintf(fid, 'BS: %0.1f\n', phd);
        fprintf(fid, 'Expt: %0.3f\n', expt);
        if isgood == 0
            fprintf(fid,'%s\n',str{:});
        end
    catch
    end
    fclose(fid);
