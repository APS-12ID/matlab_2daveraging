function [rtn, dataNorm, savefilename] = avgfile(specfile, fileindex, AVGfolder, detector, SF, mu)
% function avgfile(specfile, fileindex or filename, avgFolder, [, detector])
% Azimuthal average. This function uses Zuo's code.
%
% Average SAXS and WAXS data with the fileindex.
% To use this function, load saxssetup.mat or/and waxssetup.mat.
% 
% [rtn, dataNorm] = avgfile(specfile, fileindex)
%   then .BS will be the default detector for choice.
% [rtn, dataNorm] = avgfile(specfile, fileindex, detector)
%   detector : BS, COUNT3, or IC
%
% SF : scale factor
% mu : linear abosrption coefficient in cm^-1 unit.
%
% Byeongdu Lee
% 2014/07/16
if ischar(fileindex)
    fn = fileindex;
    fileindex = APS_getfileindex(fn);
else
    fn = [];
end
try
    si = APS_getinfofromfileindex(specfile, fileindex);
catch
    rtn = -1;
    return 
end
if (numel(si)>1) && (~isempty(fn))
    tindex = zeros(size(si));
    for i=1:numel(si)
        tindex(i) = ~strcmp(si{i}.Filename, fn);
    end
    si(logical(tindex)) = [];
end

if nargin < 3
    AVGfolder = [];
end

Scalefactor = 1;


d = 1; % sample thickness, 1cm.
if nargin < 4
    DET = 'BS';
else
    switch detector
        case 'T'
            DET = 'T';
        otherwise
            DET = detector;
    end
    if nargin > 4
        Scalefactor = SF;
    end
end


[datadir, ~] = fileparts(specfile);
if isempty(datadir)
    datadir = pwd;
end

for k = 1:numel(si)
    switch DET
        case 'T'
            if iscell(si)
                Cnt3 = si{k}.Count3;
                Expt = si{k}.Exposuretime;
                FB = si{k}.Fullbeam;
                FN = si{k}.Filename;
                eng = si{k}.Energy;
            else
                Cnt3 = si(k).Count3;
                Expt = si(k).Exposuretime;
                FB = si(k).Fullbeam;
                FN = si(k).Filename;
                eng = si(k).Energy;
            end
            T = Cnt3/Expt/(FB/0.2); % transmittance
            if nargin==5
                d = -log(T)/mu;
            end
            phd = T/Expt; % exposure time normalized.
        otherwise
            if iscell(si)
                phd = si{k}.(DET);
                Expt = si{k}.Exposuretime;
                FB = si{k}.Fullbeam;
                FN = si{k}.Filename;
                eng = si{k}.Energy;
            else
                phd = si(k).(DET);
                Expt = si(k).Exposuretime;
                FN = si(k).Filename;
                eng = si(k).Energy;
            end
    end
%    expt = si{k}.Exposuretime;
    expt = Expt;
    dfn = [];
    
    [~,fn,ext]=fileparts(FN);
    for t = 1:2
        %eng0=eng;
        try
            switch t
                case 1
                    m = evalin('base', 'saxs');
                    dfn = fn;
                    dirN = 'SAXS';
                case 2
                    m = evalin('base', 'waxs');
                    dfn = ['W', fn(2:end)];
                    dirN = 'WAXS';
            end
        catch
            m = [];
        end
        
        if isfield(m, 'absIntCoeff')  
            Scalefactor = m.absIntCoeff;  % define scalefactor from setup files
            disp('read Scale factor from setup file\n')
        end
        
        %dataNorm=[data(:,1) data(:,2:3)/phd data(:,4:end)];
        if isempty(m)
            switch t
                case 1
                    fprintf('SAXS is not averaged because saxssetup.mat is not loaded.\n');
                case 2
                    fprintf('WAXS is not averaged because waxssetup.mat is not loaded.\n');
            end
            continue
        end
        if isempty(dfn)
            continue;
        end
        datafilename = fullfile(datadir, dirN, [dfn, ext]);
        if isempty(AVGfolder)
            AVGfolder = 'Averaged';
        end
        savefilename = fullfile(datadir, dirN, AVGfolder, [dfn, '.dat']);
        %sImg=imgUpsideDn(double(imread(datafilename)));
        try
            %sImg=flipud(double(imread(datafilename)));
            sImg = SAXSimageviwerLoadimage(datafilename);
            sImg = sImg.image;
        catch
            sImg = [];
        end
        if isempty(sImg)
            continue;
        end
        eng0 = m.eng;
        %eng = si{k}.Energy;
        data = circavgnew2(sImg, m.mask, m.qCMap, m.qRMap, m.qArray, m.offset, m.limits);
        
        if eng>0
            dataNorm=[data(:,1)*eng/eng0  data(:,2:3)/phd*Scalefactor/d];
        else
            dataNorm=[data(:,1) data(:,2:3)/phd*Scalefactor/d];
        end
        
        
        try
            fid = fopen(savefilename, 'w');
            fprintf(fid, '%% Filename : %s\n', [fn, ext]);
            fprintf(fid, '%% Date & Time : %s\n', datestr(now));
            fprintf(fid, '%% X-ray Energy (keV) : %0.3f\n', eng);
            fprintf(fid, '%% Exposure Time (s) : %0.3f\n', expt);
            
%             switch dirN
%                 case 'SAXS'
%                     if isfield(avg, 'saxsBC')
%                         fprintf(fid, '%% Beam Center : %0.5f, %0.5f\n', m.BeamXY(1), m.BeamXY(2));
%                         fprintf(fid, '%% Sample to Detector Distance (SDD) (mm) : %0.3f\n', m.SDD);
%                         fprintf(fid, '%% Detector Pixel Size (mm) : %0.3f\n', m.pSize);
%                     end
%             end
            fprintf(fid, '%% Photodiode Value : %i\n', phd);
            fprintf(fid, '%% Scalefactor for absolute intensity calibration : %i\n', Scalefactor);
%            fprintf(fid, '%% Multiply I(q) with the sample thickness (cm) to convert it into absolute units.\n');
            fprintf(fid, '%% \n');
            fprintf(fid, '%% q(A^-1)   I(q)    sqrt(I(q))\n');
            fclose(fid);
            dlmwrite(savefilename,dataNorm, 'delimiter','\t','precision','%.8e', '-append');
            fprintf('%s is processed\n', savefilename);
            rtn = 1;
        catch
            rtn = 0;
            fprintf('Cannot write file on the disk.\n')
        end        
    end
end
