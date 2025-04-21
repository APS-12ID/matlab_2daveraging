function mcamon_1Dauto_update(figH, DETname, mydirname, myfilename, varargin)
if ~isempty(varargin)
    axh = findobj(figH, 'type', 'axes');
    if numel(axh) < 2
        figure(figH);
        clf;
        subplot(1,2,1);set(gca, 'tag', 'axDataplot')
        subplot(1,2,2);set(gca, 'tag', 'axImgplot')
    end
else
    set(findobj(figH, 'type', 'axes'), 'tag', 'axDataplot');
end
delete(timerfind('Tag', 'Auto1DUpdate'));
if isempty(varargin)
    utimer = createUpdateTimer(DETname, mydirname, myfilename);
else
    utimer = createUpdateTimer(DETname, mydirname, myfilename, varargin{1});
end
start(utimer);

allhandles = findall(figH);
menuhandles = findobj(allhandles,'tag','myMenu');
if isempty(menuhandles)
    f = uimenu(figH, 'Label', 'Scale', 'tag', 'myMenu');
    uimenu(f,'Label','Linear Linear','Callback',@setlinear);
    uimenu(f,'Label','Linear Log','Callback',@setlinearlog);
    uimenu(f,'Label','Log Log','Callback',@setloglog);
    uimenu(f,'Label','Change X Limits','Callback',@queryxlim);
    uimenu(f,'Label','Change Y Limits','Callback',@querylim);
    uimenu(f,'Label','Show cursor','Callback',@showcursor);
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
    
    function setlinear(varargin)
        ax = findobj('tag', 'axDataplot');
        set(ax, 'xscale', 'linear', 'yscale', 'linear')
    end

    function t = createUpdateTimer(varargin)
        t = timer;
        %t.StartFcn = {@UpdateTimerStart, varargin};
        t.TimerFcn = {@runTask, varargin};
        switch lower(varargin{1})
            case 'mar300'
                wtime = 2;
            case 'pilatus2m'
                wtime = 1;
            case 'pe'
                wtime = 1.5;
        end
        t.StartDelay = wtime;
        t.Tag = 'Auto1DUpdate';
        t.BusyMode = 'drop';
        t.TasksToExecute = 2;
        t.ExecutionMode = 'singleShot';
    end 

    function UpdateTimerStart(mTimer, varargin)
        mTimer.userdata = varargin{1};
    end

    function runTask(varargin)
        par = varargin{3};
        if numel(par) == 4
            plotimg(par{4});
        end
        plotdata(par{1}, par{2}, par{3});
        
        drawnow
        refreshdata
        if contains(char(java.net.InetAddress.getLocalHost), '164.54.122')
            fh = findobj('tag', 'AvgDataPlot');
            saveas(fh,'/home/beams/WEB12ID/www/realtime_12idb.png')
        end
    end
end

    function plotimg(varargin)
        imginfo = varargin{1};
        fh = findobj('tag', 'AvgDataPlot');
        if isempty(fh)
            fh = figure;
            set(fh, 'tag', 'AvgDataPlot');
            axes('tag', 'axImgplot');
        end
        %dt = get(fh, 'userdata');
        ax = findobj(fh, 'type', 'axes', 'tag', 'axImgplot');
        if isempty(ax)
            ax = axes(fh);
            set(ax, 'tag', 'axImgplot')
        end
%        axes(ax)
        try
            imagesc(ax, imginfo.image, imginfo.Clim);
            axis image;
            colormap jet
            axis xy
        catch
            figure(fh)
            ax = subplot(1,2,2);
            imagesc(imginfo.image, imginfo.Clim);
            set(ax, 'tag', 'axImgplot');
            colormap jet
            axis image;
            axis xy
        end
        set(ax, 'xlim', imginfo.Xlim);
        set(ax, 'ylim', imginfo.Ylim);
        %axis image;
        %set(ax, 'CLim', imginfo.Clim);
    end

    function plotdata(varargin)
        DET = varargin{1};
        dirname = varargin{2};
        Filename = varargin{3};
        saxsfile = [];
        waxsfile = [];
        pefile = [];
        pe = [];
        sd = [];
        wd = [];

        switch lower(DET)
            case 'pilatus2m'
                mydir = [dirname, filesep, 'SAXS', filesep, 'Averaged'];
                mydirW = strrep(mydir, [filesep, 'SAXS', filesep], [filesep, 'WAXS', filesep]);
                saxsfile = fullfile(mydir, filesep, [Filename, '.dat']);
                waxsfile = fullfile(mydirW, filesep, ['W', Filename(2:end), '.dat']);

            case 'mar300'
                saxsfile = fullfile(dirname, [filesep, 'Averaged'], filesep, [Filename, '.dat']);
            case 'pe'
                saxsfile = fullfile(dirname, [filesep, 'Averaged'], filesep, [Filename, '.dat']);
        end
        
        dtFileName = strrep(Filename, '_', ' '); % Displayname
        
        k = 0;
        while (~exist(saxsfile, 'file'))
            pause(0.25)
            k = k + 1;
            fprintf('Waiting %s, %i.... \n', saxsfile, k)
            if k>10
                break
            end
        end

        
        % check whether a graph is read to go.
        fh = findobj('tag', 'AvgDataPlot');
        if isempty(fh)
            fh = figure;
            set(fh, 'tag', 'AvgDataPlot');
            axes('tag', 'axDataplot');
        end
        dt = get(fh, 'userdata');
        ax = findobj(fh, 'type', 'axes', 'tag', 'axDataplot');
        if isempty(ax)
            ax = axes(fh);
        end
        pe = [];
        % process filenames

        % load files
        if ~isempty(saxsfile)
            try
                sd = load(saxsfile);
            catch
                sd = [];
            end
        end
        if ~isempty(waxsfile)
            try
                wd = load(waxsfile);
            catch
                wd = [];
            end
        end
        if ~isempty(pefile)
            try
                pe = load(pefile);
            catch
                pe = [];
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
            ntitle = [dtFileName, sprintf(' : %s', datetime)];
            title(ax, ntitle);
            xlabel(ax, sprintf('q (%c^{-1})', char(197)), 'fontsize', 12)
            ylabel(ax, 'I(q)', 'fontsize', 12)
            box(ax, 'on')
%            if contains(char(java.net.InetAddress.getLocalHost), '164.54.122')
%                saveas(fh,'/home/beams/WEB12ID/www/realtime_12idb.png')
%            end
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
    