function APS_UDP_1dAutoUpdateMenu(varargin)
global utimer 
utimer = [];
whichsock = 1;
is2Dupate = 0;

% if no figure for auto1Dupdate, genereate one;
fh = findobj('tag', 'AvgDataPlot');
if isempty(fh)
    fh = figure;
    set(fh, 'tag', 'AvgDataPlot');
end
set(gca, 'tag', 'axDataplot');
% If there are already autoupdate timers, kill them.
delete(timerfind('Tag', 'Auto1DUpdate'));

% generate AutoUpdate menu in the main figure menu;
f = uimenu(fh, 'Label','APS12IDB');
uimenu(f,'Label','Start 1D Update','Callback',@startupdate);
uimenu(f,'Label','Stop 1D Update','Callback',@stopupdate);
uimenu(f,'Label','Update WAXS only','Callback',@WAXSonlyupdate);
uimenu(f,'Label','Start 2D Update','Callback',@start2Dupdate);
uimenu(f,'Label','Set xlim','Callback',@queryxlim);
uimenu(f,'Label','Set ylim','Callback',@querylim);
uimenu(f,'Label','Set log-log','Callback',@setloglog);
uimenu(f,'Label','Set linear-log','Callback',@setlinearlog);
%gca;
set(gca, 'box', 'on')
xlabel(sprintf('q (%c^{-1})', char(197)), 'fontsize', 16);
ylabel(sprintf('I(q)'), 'fontsize', 16)
axes('position', [.3 .1 .6 .8], 'visible', 'off', 'tag', 'axStatusUpdate');   
    
% nested functions
    function startupdate(varargin)
        delete(timerfind('Tag', 'Auto1DUpdate'));
        utimer = createUpdateTimer;
        start(utimer);
    end
    
    function stopupdate(varargin)
        if ~isempty(utimer)
            stop(utimer);
        end
    end
    
    function WAXSonlyupdate(varargin)
        if get(gcbo, 'checked')
            whichsock = 2;
        else
            whichsock = 1;
        end
    end
    
    function start2Dupdate(varargin)
        if get(gcbo, 'checked')
            is2Dupate = 1;
            add2Dimages
        else
            is2Dupate = 0;
        end
    end

    function add2Dimages(varargin)
        fs = findobj('tag', 'Auto2DSAXS');
        if isempty(fs)
            fs = figure;
            axis image;
            set(fs, 'tag', 'Auto2DSAXS');
        end
        add_imagemenu(fs)
        fw = findobj('tag', 'Auto2DWAXS');
        if isempty(fw)
            fw = figure;
            axis image;
            set(fw, 'tag', 'Auto2DWAXS');
        end
        add_imagemenu(fw);
        fw = findobj('tag', 'Auto2DPE');
        if isempty(fw)
            fw = figure;
            axis image;
            set(fw, 'tag', 'Auto2DPE');
        end
        
        add_imagemenu(fw);
    end


    function queryxlim(varargin)
        prompt = {'Enter x min:','Enter x max:'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {'0.001','0.25'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        ax = findobj('tag', 'axDataplot');
        set(ax, 'xlim', [str2double(answer{1}), str2double(answer{2})]);
    end
    
    function querylim(varargin)
        prompt = {'Enter y min:','Enter y max:'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {'1E-5','10'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        ax = findobj('tag', 'axDataplot');
        set(ax, 'ylim', [str2double(answer{1}), str2double(answer{2})]);
    end
    
    function setloglog(varargin)
        ax = findobj('tag', 'axDataplot');
        set(ax, 'xscale', 'log', 'yscale', 'log')
    end
    
    function setlinearlog(varargin)
        ax = findobj('tag', 'axDataplot');
        set(ax, 'xscale', 'linear', 'yscale', 'log')
    end

    function t = createUpdateTimer()
        timegap = 0.1;

        t = timer;
        t.StartFcn = @UpdateTimerStart;
        t.TimerFcn = @runTask;
        t.StopFcn = @UpdateTimerStop;
        t.Period = timegap;
        t.Tag = 'Auto1DUpdate';
        t.BusyMode = 'drop';
        t.TasksToExecute = inf;
        t.ExecutionMode = 'fixedrate';
    end 

    function UpdateTimerStart(mTimer, ~)
        SAXS1dplotPORT = 9100;
        WAXS1dplotPORT = 9101;
        readtimeout = 0.1;
        udp1dSAXS=pnet('udpsocket',SAXS1dplotPORT);
        udp1dWAXS=pnet('udpsocket',WAXS1dplotPORT);
        pnet(udp1dSAXS,'setreadtimeout',readtimeout)
        pnet(udp1dWAXS,'setreadtimeout',readtimeout)
        mTimer.userdata = {udp1dSAXS, udp1dWAXS};
        disp('Update Started.');
    end

    function runTask(mTimer, ~)
        sock = mTimer.userdata;
        readsock = sock{whichsock};
        APS_UDP_1dAutoUpdate(readsock, is2Dupate)
    end

    function UpdateTimerStop(mTimer, ~)
        sock = mTimer.userdata;
        pnet(sock{1},'close');
        pnet(sock{2},'close');
        mTimer.userdata = [];
        disp('Update Stopped.');
    end

end

function APS_UDP_1dAutoUpdate(varargin)
    udp1dSAXS = varargin{1};
    isupdate2D = varargin{2};
    
    len=pnet(udp1dSAXS,'readpacket');
    if len>0
        % if packet larger then 1 byte then read maximum of 1000 doubles in network byte order
        data=pnet(udp1dSAXS,'read',1000,'string');
        pSpace = strfind(data, ' ');
        if numel(pSpace) < 1
            fprintf('Wrong command is passed: %s\n', data)
            return
        end
        if numel(pSpace) == 1
            cmd = data(1:pSpace(1)-1);
            par = data(pSpace(1)+1:end);
%            disp([cmd, ' ', par]);
%            try
            switch cmd
                case 'open1Ddata'
%                    fprintf('%s\n', par)
                    plotdata(par)
                case 'evaluated'
%                    fprintf('%s\n', par)
                    checkinDataQuality(par)
                case 'open2Ddata'
                    if isupdate2D
                        plot2Ddata(par)
                    end
                otherwise
                    disp('Cannot understand the command.');
            end
%            catch
%                disp('Something wrong! so skipped for the last data.') 
%            end
        end
    end
    drawnow('update')
    
    function checkinDataQuality(varargin)
        isgood = varargin{1};
        isgood = str2double(isgood);
        axtext = findobj('tag', 'axStatusUpdate');
        if ~isempty(axtext)
            cla(axtext);
        end
        
        if isgood == 0
            str = {};
            fid = fopen('~/.currentSAXSimageinfo', 'r');
            try
                Filename = fgetl(fid);
                dtFileName = fgetl(fid);
                t = fgetl(fid);
%                 maxvstr = fgetl(fid)
%                 meanvstr = fgetl(fid)
%                 maxratestr = fgetl(fid)
%                 ic1str = fgetl(fid)
%                 phdstr = fgetl(fid)
%                 exptstr = fgetl(fid)
                i = 1;
                while ~feof(fid)
                    str{i} = fgetl(fid);
                    i = i + 1;
                end
            catch
            end
            fclose(fid);
            if ~isgood && ~isempty(axtext)
                text(0.1, 0.6, str, 'color', 'r', 'Parent', axtext)
            end
            
        end
    end

    function plotdata(varargin)
        Filename = varargin{1};

        % check whether a graph is read to go.
        fh = findobj('tag', 'AvgDataPlot');
        if isempty(fh)
            fh = figure;
            set(fh, 'tag', 'AvgDataPlot');
            axes('tag', 'axDataplot');
        end
        dt = get(fh, 'userdata');
        ax = findobj(fh, 'type', 'axes', 'tag', 'axDataplot');
        pe = [];
        % process filenames
        [dirn,dtFileName, ext] = fileparts(Filename);
        switch dtFileName(1)
            case 'S' %SAXS and WAXS
                saxsfile = Filename;
                ndir = strrep(dirn, [filesep, 'SAXS'], [filesep, 'WAXS']);
                waxsfile = fullfile(ndir,...
                    filesep, ['W', dtFileName(2:end), ext]);
                dtFileName = strrep(dtFileName, '_', ' '); % Displayname
                pefile = [];
            case 'P' % PE detector
                saxsfile = [];
                waxsfile = [];
                pefile = Filename;
%                dspFileName = strrep(dtFileName, '_', ' ');
        end

        % load files
        if ~isempty(saxsfile)
            try
                sd = load(saxsfile);
            catch
                sd = [0.1, 0];
            end
        end
        if ~isempty(waxsfile)
            try
                wd = load(waxsfile);
            catch
                wd = [0.1, 0];
            end
        end
        if ~isempty(pefile)
            try
                pe = load(pefile);
            catch
                pe = [0.1, 0];
            end
        end
        % SAXS data plot.
        if ~isfield(dt, 'shandle')
            dt.shandle = [];
        end
        if ~isfield(dt, 'whandle')
            dt.whandle = [];
        end
        if ~isfield(dt, 'pehandle')
            dt.pehandle = [];
        end
        if ~isfield(dt, 'Ndata2plot')
            dt.Ndata2plot = 5;
        end
%         col = [1, 0, 0; 0.8, 0, 0.2; 0.6, 0, 0.4; 0.4, 0, 0.6; 0.2, 0, 0.8];
        
        % SAXS data plot
        if ~isempty(sd)
            dt.shandle = plot1DdataonAxes(dt.shandle, dt.Ndata2plot, ax, sd, dtFileName, 'SAXS');
        end

        % WAXS data plot.

        if ~isempty(wd)
            dt.whandle = plot1DdataonAxes(dt.whandle, dt.Ndata2plot, ax, wd, dtFileName, 'WAXS');
        end
        if ~isempty(pe)
            dt.pehandle = plot1DdataonAxes(dt.pehandle, dt.Ndata2plot, ax, pe, dtFileName, 'PE');
        end        
        set(fh, 'userdata', dt);
        try
            title(ax, dtFileName);
        catch
            disp('No title')
        end
    %    set(ax, 'xscale', 'log', 'yscale', 'log')
    end

    function han = plot1DdataonAxes(han, Nlines, ax, data, dtFileName, lTag)
        
        col = [1, 0, 0; 0.8, 0, 0.2; 0.6, 0, 0.4; 0.4, 0, 0.6; 0.2, 0, 0.8];

        for i=numel(han):-1:1
            if i<Nlines
                try
                    xd = get(han(i), 'xdata');
                    yd = get(han(i), 'ydata');
                    updtFileName = get(han(i), 'Displayname');
                    if i==numel(han)
                        han(i+1) = line(ax, 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    else
                        set(han(i+1), 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    end
                    set(han(i+1), 'Displayname', updtFileName, 'Tag', lTag);
                catch
                    disp('Error in 1D plots in APS_UDP_1dAutoUpdateMenu.m')
                end
            end
        end
        if numel(han) > 0
            try
                set(han(1), 'xdata', data(:,1), 'ydata', data(:,2), 'linewidth', 2, 'color', col(1, :));
                set(han(1), 'Displayname', dtFileName, 'Tag', lTag);
            catch
                han(1) = line(ax, 'xdata', data(:,1), 'ydata', data(:,2), 'linewidth', 2, 'color', col(1, :));
                set(han(1), 'Displayname', dtFileName, 'Tag', lTag);
            end
        else
            han(1) = line(ax, 'xdata', data(:,1), 'ydata', data(:,2), 'linewidth', 2, 'color', col(1, :));
            set(han(1), 'Displayname', dtFileName, 'Tag', lTag);
        end        
    end

    function plot2Ddata(varargin)
        Filename = varargin{1};

        % check whether a graph is read to go.
        fs = findobj('tag', 'Auto2DSAXS');
        fw = findobj('tag', 'Auto2DWAXS');
        fpe = findobj('tag', 'Auto2DPE');
        if ~isempty(fs)
            axs = findobj(fs, 'type', 'axes');
        else
            axs = [];
        end
        if ~isempty(fw)
            axw = findobj(fw, 'type', 'axes');
        else
            axw = [];
        end
        if ~isempty(fpe)
            axpe = findobj(fpe, 'type', 'axes');
        else
            axpe = [];
        end

        % process filenames
        [dirn,dtFileName, ext] = fileparts(Filename);
        switch dtFileName(1)
            case 'S' %SAXS and WAXS
                saxsfile = Filename;
                ndir = strrep(dirn, [filesep, 'SAXS'], [filesep, 'WAXS']);
                waxsfile = fullfile(ndir,...
                    filesep, ['W', dtFileName(2:end), ext]);
                dspFileName = strrep(dtFileName, '_', ' '); % Displayname
                pefile = [];
            case 'P' % PE detector
                saxsfile = [];
                waxsfile = [];
                pefile = Filename;
                dspFileName = strrep(dtFileName, '_', ' ');
        end
        sd = [];
        wd = [];
        pe = [];

        % load files
        if ~isempty(saxsfile)
            try
                sd = imread(saxsfile);
            catch
                sd = [];
            end
        end
        if ~isempty(waxsfile)
            try
                wd = imread(waxsfile);
            catch
                wd = [];
            end
        end
        if ~isempty(pefile)
            try
                pe = imread(pefile);
            catch
                pe = [];
            end
        end

        % SAXS data plot.
        try
            %SAXS plot
            if ~isempty(sd) && ~isempty(axs)
                plot2DimageonAxes(sd, axs)
                title(axs, ['SAXS: ', dspFileName]);
            end
            %WAXS plot
            if ~isempty(wd) && ~isempty(axw)
                plot2DimageonAxes(wd, axw)
                title(axw, ['WAXS: ', dspFileName]);
            end
            if ~isempty(pe) && ~isempty(axpe)
                plot2DimageonAxes(pe, axpe)
                title(axpe, ['PE: ', dspFileName]);
            end
        catch
            fprintf('Image update of %s failed.\n', dtFileName)
        end
        
        % SAXS data quality analysis
        % evaluateSAXSdata(sd, dirn, dtFileName);
    end
    
    function plot2DimageonAxes(img, ax)
        ud = get(ax, 'userdata');
        islog = 0;
        if isfield(ud, 'scale')
            if strcmp(ud.scale, 'log')
                islog = 1;
            end
        end
        if isempty(findobj(ax, 'type', 'image'))
            imagesc(img, 'parent', ax);axis(ax, 'image');
        end
        if islog   
            set(findobj(ax, 'type', 'image'), 'CData', log10(abs(double(img))+eps))
            ud.image = img;
            set(ax, 'userdata', ud);
        else
            set(findobj(ax, 'type', 'image'), 'CData', img)
        end
    end
    
    function evaluateSAXSdata(sd, dirn, dtFileName)
        if ~isempty(sd)
            % Read Log file.
            ndir = strrep(dirn, [filesep, 'SAXS'], [filesep, 'Log']);
            logfile = fullfile(ndir,...
                filesep, ['L', dtFileName(2:end), '.meta']);
            [phd, ic1, ~, expt] = parseMetafile(logfile);
            
            % Analyzie data
            sd = sd(:);
            maxv = max(sd);
            meanv = mean(sd);
            maxrate = max(sd/expt);
            isgood = 1;
            str = {};
            if (ic1/expt) < 100
                str = [str, sprintf('I0 is lower than limit. %0.3f', ic1/expt)];
                str = [str, 'Check the B station photon shutter open.'];
                isgood = 0;
            else
                if (phd/expt) < 100
                    str = [str, sprintf('phd value is lower than limit. %0.3f', phd/expt)];
                    str = [str, 'Check whether nozzle is in position or sample is too thick.'];
                    isgood = 0;
                end
                
                if (meanv < 0.5)
                    str = [str, 'Very low SAXS signals. Check with the sample or try longer exposure time.'];
                    isgood = 0;
                end

                if (maxrate > 5000000)
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
        
        axtext = findobj('tag', 'axStatusUpdate');
        if ~isempty(axtext)
            cla(axtext);
        end
        if ~isgood
            text(0.3, 0.6, str, 'color', 'r', 'Parent', axtext)
        end
        fid = fopen('~/.currentSAXSimageinfo', 'w');
        try
            fprintf(fid, 'Filename: %s\n', saxsfile);
            fprintf(fid, '%s\n', dtFileName);
            fprintf(fid, '%i\n', isgood);
            fprintf(fid, 'Max Value: %0.6f\n', maxv);
            fprintf(fid, 'Mean Value: %0.6f\n', meanv);
            fprintf(fid, 'Max Count Rate: %0.6f\n', maxrate);
            fprintf(fid, 'IC: %0.1f\n', ic1);
            fprintf(fid, 'BS: %0.1f\n', phd);
            fprintf(fid, 'Expt: %0.3f\n', expt);
        catch
        end
        fclose(fid);
    end
end