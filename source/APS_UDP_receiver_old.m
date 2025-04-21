function APS_UDP_receiver(port)

%%% UDP setting
SAXS1dplotPORT = 9100;
WAXS1dplotPORT = 9101;
WAXSPE1dplotPORT = 9102;
SAXSMAR1dplotPORT = 9103;
if ((port > 3330) && (port < 3340))
    DET = 'Pilatus2M';
end
if ((port > 3340) && (port < 3350))
    DET = 'Pilatus300k';
end
if ((port > 3350) && (port < 3360))
    DET = 'PE';
end
if ((port > 3360) && (port < 3370))
    DET = 'MAR300';
end

saxs = [];
waxs = [];
laxs = [];
if exist('udp')
    try
        pnet(udp,'close');
    end
end
if exist('sock1D')
    try
        pnet(sock1D,'close');
    end
end
is1Dsockon = 0;

if nargin < 1
    APS_12IDB_port = 3333;
else
    APS_12IDB_port = port;
end

udp=pnet('udpsocket',APS_12IDB_port);


%%% AVG setting.
avg.olddir = '';
avg.dir = '';
avg.I0ofstandard = 1;
avg.absoluteSF = 1;
avg.photodiode = 1;
avg.I0ofsample = 1;
avg.expt = 0;
isrun = 1;
is1DSAXSsockOn = 0;
is1DWAXSsockOn = 0;
is1DPEsockOn = 0;
sock1DSAXS = -1;
sock1DWAXS = -1;
sockPEWAXS = -1;
sockMARSAXS = -1;
saxsBC = [0,0];
saxsSDD = 0;
saxsPIXSIZE = 0;
Xeng = 0;
connect2plot1d
mysock = -1;


%%% Run Loop
while isrun
    len=pnet(udp,'readpacket');
    if len>0
        % if packet larger then 1 byte then read maximum of 1000 doubles in network byte order
        data=pnet(udp,'read',1000,'string');
        
        pSpace = strfind(data, ' ');
        if numel(pSpace) < 1
            switch data
                case '-1'
                    isrun = 0;
                otherwise
                    disp('If you want to stop, send -1.');
            end
            continue
        end
        if numel(pSpace) == 1 % if syntax is 'cmd parameterss'
            cmd = data(1:pSpace(1)-1);
            par = data(pSpace(1)+1:end);
            switch cmd
                case 'loadmat'
                    APS_ch2currentfolder;
                    try
                        eval(sprintf('load %s', par));
                    catch
                        disp('saxssetup.mat or waxssetup.mat is not available.')
                    end
                    
                    if exist('saxs', 'var')
                        disp('exported')
                        assignin('base', 'saxs', saxs)
                        if isfield(saxs, 'BeamXY')
                            saxsBC = saxs.BeamXY;
                            saxsSDD = saxs.SDD;
                            saxsPIXSIZE = saxs.pSize;
                            Xeng = saxs.eng;
                        end
                    end
                    if exist('waxs', 'var')
                        assignin('base', 'waxs', waxs)
                        if isfield(waxs, 'eng')
                            Xeng = waxs.eng;
                        end
                    end
                    if exist('laxs', 'var')
                        assignin('base', 'laxs', laxs)
                        if isfield(laxs, 'eng')
                            Xeng = laxs.eng;
                        end
                    end
                    fprintf('%s is loaded.\n', par);
                    try
                        epics_put_SAXSinfo
                    catch
                        disp('Uploading setup parameters to Epics failed')
                    end
                case 'avgfile'
                    %[specfilename, crtDir] = APS_ch2currentfolder;
                    %cd(crtDir);
                    try
                        specfilename = APS_ch2currentfolder;
                        avgfile(specfilename, eval(par));
                    catch
                        disp('Averaging is not done successfully.');
                    end
%                     pnet(sock1D, 'write', 'open1Ddata');pnet(sock1D, 'writepacket');
                case 'changedir'
                    eval('base', sprintf('cd %s', par));
                    %cd(par)
                    fprintf('changed to %s\n', pwd);
                case 'copyfile'
                    ret = APS_12IDBfiletransfer(par, pwd);
                    if ~isempty(ret)  
                        fprintf('%s is transferred.\n', ret);
                    else
                        fprintf('The file name is not found.\n');
                    end
                case 'fillGap'
                    filename2fillgap = par;
                    disp(pwd)
                    disp(filename2fillgap)
                    fillGap12IDPilatus2M(pwd, filename2fillgap);
                    
                otherwise
                    fprintf('Cannot understand the command, %s.\n', cmd);
            end
            continue
        end
        
% if a syntax is 'file dir somthingelse'..
                
        filen = data(1:pSpace(1)-1);
        workingDir = data(pSpace(1)+1:pSpace(2)-1);
        
        switch lower(DET)
            case {'pilatus2m', 'pilatus300k'}
        %%% file transfer
        
                imgname = APS_12IDBfiletransfer(filen, workingDir);
                if isempty(imgname)
                    continue;
                end
                if strcmp(imgname, '')
                    fprintf('File Transfer Failed\n');
                    continue;
                end
            otherwise
                [~, bd, ext] = fileparts(filen);
                imgname = [bd, ext];
        end
        
        
        %%% Azimuthal average
        
        if numel(pSpace) == 2
            avg.photodiode = str2double(data(pSpace(2)+1:length(data)));
        elseif numel(pSpace) == 3
            avg.photodiode = str2double(data(pSpace(2)+1:pSpace(3)-1));
            avg.I0ofsample = str2double(data(pSpace(3)+1:length(data)));
        elseif numel(pSpace) == 4
            avg.photodiode = str2double(data(pSpace(2)+1:pSpace(3)-1));
            avg.I0ofsample = str2double(data(pSpace(3)+1:pSpace(4)-1));
            avg.expt = str2double(data(pSpace(4)+1:length(data)));
        end
        if numel(avg.I0ofsample) > 1
            avg.I0ofsample = str2double(char(avg.I0ofsample));
        end

        avg.filename = imgname;
        avg.dir = workingDir;
        avg.energy = Xeng;
        avg.saxsBC = saxsBC;
        avg.saxsSDD = saxsSDD;
        avg.saxsPIXSIZE = saxsPIXSIZE;
        
        %%% Data Averaging
        try
            [~, ~, savefilename] = avgfile0(avg);
        catch
            savefilename = [];
            disp('Averaging is NOT done');
        end
        
        %%% Data Evaluation.
%         if imgname(1) == 'S'
%             try
%                 isgood = evaluate_12IDB_SAXSdata(avg, saxs);
%                 pnet(sock1DSAXS, 'write', sprintf('evaluated %i', isgood));
%                 pnet(sock1DSAXS, 'writepacket');
%             catch
%                 disp('Evaluation is not done.');
%             end
%         end
        
        %%% Auto 1D data plotting.
        if ~isempty(savefilename)
%            connect2plot1d
            cmd = sprintf('open1Ddata %s', savefilename);
            if ~strcmpi(DET, 'pilatus300k')
                mysockS = broadcast(DET, mysockS, cmd);
            end
        end
    end
    drawnow('update')
end
pnet('closeall')

    function mysock = broadcast(DET, mysock, cmd)
        remotehost = {'purple.xray.aps.anl.gov', ...
                    'eggplant.xray.aps.anl.gov', ...
                    'plum.xray.aps.anl.gov', ...
                    'green.xray.aps.anl.gov'};
        nRH = numel(remotehost);
        switch lower(DET)
            case 'pilatus2m'
%                myport = [9100, 9101];
                portS = 9100;
%                mysock = sockSAXS;
                remotesock = 9100;
            case 'pilatus300k'
%                myport = [9102, 9103];
                portS = 9110;
%                mysock = sockWAXS;
                remotesock = 9101;
            case 'pe'
%                myport = [9104, 9105];
                 portS = 9120;
%                mysock = sockPE;
                remotesock = 9102;
            case 'mar300'
%                myport = [9104, 9105];
                 portS = 9130;
%                mysock = sockPE;
                remotesock = 9103;
        end
        myport = linspace(portS, portS+nRH-1, nRH);

        for i=1:numel(myport)            
            newconnection = 0;
%            fprintf('%i is %s\n', mysock(i), remotehost{i})
            try
                pnet(mysock(i), 'status');
            catch
                mysock(i) = -1;
            end
%            fprintf('%i is %s\n', mysock(i), remotehost{i})
            if mysock(i) < 0
                mysock(i)=pnet('udpsocket',myport(i));
                if mysock(i) < 0
                    fprintf('Not successful UDP connection to %s.\n', remotehost{i})
                    continue;
                end
                newconnection = 1;
            end
            if newconnection > 0
                pnet(mysock(i),'udpconnect',remotehost{i},remotesock);
                fprintf('%s:%i is connected to Port %i.\n', remotehost{i}, remotesock, myport(i));
            end
        end
        for i=1:numel(myport)
            try
                pnet(mysock(i), 'write', cmd);
                n = pnet(mysock(i), 'writepacket');
            catch
                n = -1;
            end
            if n~=0
                pnet(mysock(i), 'close')
                mysock(i) = -1;
            end
        end

    end

    function connect2plot1d(varargin)
        if sock1DSAXS < 0
            sock1DSAXS=pnet('udpsocket',SAXS1dplotPORT);
            pnet(sock1DSAXS,'udpconnect','purple.xray.aps.anl.gov',SAXS1dplotPORT);
        end
        if sock1DWAXS < 0
            sock1DWAXS=pnet('udpsocket',WAXS1dplotPORT);
            pnet(sock1DWAXS,'udpconnect','purple.xray.aps.anl.gov',WAXS1dplotPORT);
        end
        if sockPEWAXS < 0
            sockPEWAXS=pnet('udpsocket',WAXSPE1dplotPORT);
            pnet(sockPEWAXS,'udpconnect','purple.xray.aps.anl.gov',WAXSPE1dplotPORT);
        end
        if sockMARSAXS < 0
            sockMARSAXS=pnet('udpsocket',SAXSMAR1dplotPORT);
            pnet(sockMARSAXS,'udpconnect','purple.xray.aps.anl.gov',SAXSMAR1dplotPORT);
        end
    end
    function disconnect2plot1d(varargin)
        if sock1DSAXS > -1
            pnet(sock1DSAXS, 'close');
        end
        if sock1DWAXS > -1
            pnet(sock1DWAXS, 'close');
        end
        if sockPEWAXS > -1
            pnet(sockPEWAXS, 'close');
        end
        if sockMARSAXS > -1
            pnet(sockMARSAXS, 'close');
        end
    end
end
