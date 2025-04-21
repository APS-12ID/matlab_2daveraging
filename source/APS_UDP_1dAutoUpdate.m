function APS_UDP_1dAutoUpdate
% UDP setting
SAXS1dplotPORT = 9100;
WAXS1dplotPORT = 9101;
if exist('udp1dSAXS')
    try
        pnet(udp1dSAXS,'close');
    end
end
if exist('udp1dWAXS')
    try
        pnet(udp1dWAXS,'close');
    end
end

is1Dsockon = 0;

udp1dSAXS=pnet('udpsocket',SAXS1dplotPORT);
udp1dWAXS=pnet('udpsocket',WAXS1dplotPORT);
isrun = 1;

% Loop
while isrun
    len=pnet(udp1dSAXS,'readpacket');
    if len>0,
        % if packet larger then 1 byte then read maximum of 1000 doubles in network byte order
        data=pnet(udp1dSAXS,'read',1000,'string');
        pSpace = strfind(data, ' ');
        if numel(pSpace) < 1;
            switch data
                case '-1'
                    isrun = 0;
                otherwise
                    disp('If you want to stop, send -1.');
            end
            continue
        end
        if numel(pSpace) == 1
            cmd = data(1:pSpace(1)-1);
            par = data(pSpace(1)+1:end);
            disp(cmd)
            switch cmd
                case 'open1Ddata'
                    fprintf('%s\n', par)
                    plotdata(par)
                otherwise
                    disp('Cannot understand the command.');
            end
            continue
        end
    end
    drawnow('update')
end

function plotdata(varargin)
    Filename = varargin{1};
    
    % check whether a graph is read to go.
    fh = findobj('tag', 'AvgDataPlot');
    if isempty(fh)
        fh = figure;
        set(fh, 'tag', 'AvgDataPlot');
    end
    try
        dt = evalin('base', 'MCA_data');
    catch
        dt = [];
    end
    ax = findobj(fh, 'type', 'axes');
    
    % process filenames
    [dirn,dtFileName, ext] = fileparts(Filename);
%         saxsfile = fullfile(dirn, filesep, 'SAXS', filesep, 'Averaged',...
%             filesep, [FileName, '.dat']);
    saxsfile = Filename;
%         waxsfile = fullfile(dirn, filesep, 'WAXS', filesep, 'Averaged',...
%             filesep, ['W', FileName(2:end), '.dat']);
    ndir = strrep(dirn, [filesep, 'SAXS'], [filesep, 'WAXS']);
    waxsfile = fullfile(ndir,...
        filesep, ['W', dtFileName(2:end), ext]);
    
    % load files
    try
        sd = load(saxsfile);
    catch
        sd = [];
    end
    try
        wd = load(waxsfile);
    catch
        wd = [];
    end
    
    % SAXS data plot.
    if ~isfield(dt, 'shandle')
        dt.shandle = [];
    end
    if ~isfield(dt, 'whandle')
        dt.whandle = [];
    end
    if ~isfield(dt, 'Ndata2plot')
        dt.Ndata2plot = 5;
    end
    col = [1, 0, 0; 0.8, 0, 0.2; 0.6, 0, 0.4; 0.4, 0, 0.6; 0.2, 0, 0.8];
    if ~isempty(sd)
        for i=numel(dt.shandle):-1:1
            if i<dt.Ndata2plot
                try
                    xd = get(dt.shandle(i), 'xdata');
                    yd = get(dt.shandle(i), 'ydata');
                    if i==numel(dt.shandle)
                        dt.shandle(i+1) = line(ax, 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    else
                        set(dt.shandle(i+1), 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    end
                end
            end
        end
        if numel(dt.shandle) > 0
            try
                set(dt.shandle(1), 'xdata', sd(:,1), 'ydata', sd(:,2), 'linewidth', 2, 'color', col(1, :));
            catch
                dt.shandle(1) = line(ax, 'xdata', sd(:,1), 'ydata', sd(:,2), 'linewidth', 2, 'color', col(1, :));
            end
        else
            dt.shandle(1) = line(ax, 'xdata', sd(:,1), 'ydata', sd(:,2), 'linewidth', 2, 'color', col(1, :));
        end
    end
    
    % WAXS data plot.

    if ~isempty(wd)
        for i=numel(dt.whandle):-1:1
            if i<dt.Ndata2plot
                try
                    xd = get(dt.whandle(i), 'xdata');
                    yd = get(dt.whandle(i), 'ydata');
                    if i==numel(dt.whandle)
                        dt.whandle(i+1) = line(ax, 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    else
                        set(dt.whandle(i+1), 'xdata', xd, 'ydata', yd, 'color', col(i+1, :));
                    end
                end
            end
        end
        if numel(dt.whandle) > 0
            try
                set(dt.whandle(1), 'xdata', wd(:,1), 'ydata', wd(:,2), 'linewidth', 2, 'color', col(1, :));
            catch
                dt.whandle(1) = line(ax, 'xdata', wd(:,1), 'ydata', wd(:,2), 'linewidth', 2, 'color', col(1, :));
            end
        else
            dt.whandle(1) = line(ax, 'xdata', wd(:,1), 'ydata', wd(:,2), 'linewidth', 2, 'color', col(1, :));
        end
    end
    assignin('base', 'MCA_data', dt);
    dtFileName = strrep(dtFileName, '_', ' ');
    try
    	title(ax, dtFileName);
    catch
        disp('No title')
    end
    set(ax, 'xscale', 'log', 'yscale', 'log')
    set(ax, 'box', 'on')
    xlabel(sprintf('q (%c^{-1})', char(197)), 'fontsize', 16);
    ylabel(sprintf('I(q)'), 'fontsize', 16)
end

end
