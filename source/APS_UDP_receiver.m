function APS_UDP_receiver(port)
fprintf('Connected to PORT:%i\n', port)
%%% UDP setting
remotesock_list = [9100, 9101, 9102, 9103, 9104];
%DET_list = {'pilatus2m', 'pilatus300k', 'pe', 'mar300', 'mar12bm'};
DET_list = {'eiger9m',  'pilatus300k', 'pe', 'pilatus2m', 'mar12bm'};

if ((port > 3330) && (port < 3340))
    %DET = 'pilatus2m';
    DET = 'eiger9m';
    remotehost = {'purple.xray.aps.anl.gov', 'eggplant.xray.aps.anl.gov'};
    spec_data_file = '/home/beams15/S12IDB/.currentspecdatafile';
end
if ((port > 3340) && (port < 3350))
    DET = 'pilatus300k';
    remotehost = {'purple.xray.aps.anl.gov', 'eggplant.xray.aps.anl.gov'};
    spec_data_file = '/home/beams15/S12IDB/.currentspecdatafile';
end
if ((port > 3350) && (port < 3360))
    DET = 'pe';
    remotehost = {'purple.xray.aps.anl.gov', 'eggplant.xray.aps.anl.gov'};
    spec_data_file = '/home/beams15/S12IDB/.currentspecdatafile';
end
if ((port > 3360) && (port < 3370))
    %DET = 'mar300';
    DET = 'pilatus2m';
    remotehost = {'green.xray.aps.anl.gov'};
    spec_data_file = '/home/beams15/S12IDC/.currentspecdatafile';
end
if ((port > 3370) && (port < 3380))
    DET = 'mar12bm';
    remotehost = {'blue.xray.aps.anl.gov'};
    spec_data_file = '/home/beams15/S12BM/.currentspecdatafile';
end

sockbase_list = 9000 + linspace(1, numel(remotehost), numel(remotehost))*100;
%mysockS = -1*ones(size(remotehost));
dN = findcellstr(DET_list, DET);

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

udp = pnet('udpsocket',APS_12IDB_port);


%%% AVG setting.
avg.folder = '';
avg.olddir = '';
avg.dir = '';
avg.I0ofstandard = 1;
avg.absoluteSF = 1;
avg.photodiode = 1;
avg.I0ofsample = 1;
avg.expt = 0;
isrun = 1;
saxsBC = [0,0];
saxsSDD = 0;
saxsPIXSIZE = 0;
Xeng = 0;
%mysock = connect2plot1d(dN, port);


%%% Run Loop
while isrun
    len = pnet(udp,'readpacket');
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
                    [~, cpath] = APS_ch2currentfolder(spec_data_file);
                    eval('base', sprintf('cd %s', cpath));
                    try
                        eval(sprintf('load %s', par));
                    catch
                        disp('saxssetup.mat or waxssetup.mat is not available.')
                    end
                    
                    if exist('saxs', 'var')
                        disp('exported')
                        assignin('base', 'saxs', saxs)
                        % epics_put 12IDB PV variables, 2/3/2022
                        epics_put_SWAXSinfo;
                        
                        if isfield(saxs, 'BeamXY')
                            saxsBC = saxs.BeamXY;
                            saxsSDD = saxs.SDD;
                            saxsPIXSIZE = saxs.pSize;
                            Xeng = saxs.eng;
                        end
                    end
                    if exist('waxs', 'var')
                        assignin('base', 'waxs', waxs)
                        % epics_put 12IDB PV variables, 2/3/2022
                        epics_put_SWAXSinfo;
                        
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
                        %epics_put_SAXSinfo
                        save12IDsetup(fileparts(spec_data_file))
                    catch
                        disp('Uploading setup parameters to Epics failed')
                    end
                case 'avgfile'
                    %[specfilename, crtDir] = APS_ch2currentfolder;
                    %cd(crtDir);
                    try
                        specfilename = APS_ch2currentfolder(spec_data_file);
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
                    if dN < 3
                        ret = APS_12IDBfiletransfer(par, pwd);
                        if ~isempty(ret)  
                            fprintf('%s is transferred.\n', ret);
                        else
                            fprintf('The file name is not found.\n');
                        end
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
        
        %check if the file needs to be transferred from detector server. %
        %copied from APS_UPD_receiver_judp.m
        switch lower(DET)
            case {'pilatus2m', 'pilatus300k'}
            %case {'eiger9m', 'pilatus300k'}
                imgname =  filen;
                try
                    fullfilen = fullfile(workingDir, filesep, filen);
                    if ~exist(fullfilen, 'file')
                        imgname = APS_12IDBfiletransfer(filen, workingDir);
                    end
                catch
                    fprintf('Error in APS_UDP_receiver_judp.m. A tif file is not transferred yet.\n')
                end
                if ~exist(fullfilen, 'file')
                    fprintf('%s does not exist.\n', fullfilen)
                else
                    fprintf('%s is ready.\n', fullfilen)
                end
                if isempty(imgname)
                    continue;
                end
                if strcmp(imgname, '')
                    fprintf('File Transfer Failed\n');
                    continue;
                end
            case 'eiger9m'
                [~, bd, ext] = fileparts(filen);
                imgname = [bd, ext];

            otherwise
                [~, bd, ext] = fileparts(filen);
                imgname = [bd, ext];
        end
        
        %%% Azimuthal average
        for ns = 1:numel(pSpace)
            i_ns = pSpace(ns)+1;
            if numel(pSpace)>=(ns+1)
                e_ns = pSpace(ns+1)-1;
            else
                e_ns = length(data);
            end
            val = str2double(data(i_ns:e_ns));
            %fprintf('ns=%d data=%s', ns,data(i_ns:e_ns));
            
            switch ns
                case 1
                    avg.folder = data(i_ns:e_ns);
                case 2
                    avg.photodiode = val;                    
                case 3
                    avg.I0ofsample = val;
                case 4
                    avg.expt = val;
                case 5
                    avg.energynew = val;
                case 6
                    avg.temperature = val;
                case 7
                    avg.SAXSBS = val;  % SAXSBS for 12-ID-B; IC2 for 12-ID-C 
                case 8
                    avg.centerBS = val;
                case 9
                    avg.GISAXSBS = val;
                case 10
                    avg.GIWAXSBS = val;
            end
        end
        %[avg.temperature, avg.expt, avg.photodiode,avg.I0ofsample, avg.SAXSBS, avg.centerBS, avg.GISAXSBS,avg.GIWAXSBS]
        %fprintf('ns= %i\n',ns);
        
        % update Hdf5 parameters
        datafullname = fullfile(workingDir, filesep, filen);
        if ~exist(datafullname, 'file')
            continue;
        end
        tic;
        switch numel(pSpace)
            case 10 % 12-ID-B
                
                updateH5att_12IDB(datafullname, [avg.temperature, avg.expt, avg.photodiode, avg.I0ofsample, avg.SAXSBS, avg.centerBS, avg.GISAXSBS,avg.GIWAXSBS]);                        
            case 7
                updateH5att_12IDC(datafullname, [avg.temperature, avg.expt, avg.photodiode, avg.I0ofsample, avg.SAXSBS]);                       
            otherwise
                disp('Wrong Passed UDP Parameter Number!')
        end
        t2=toc;
        fprintf('It takes %.5f sec to update h5 parameters.\n', t2);   
        

% % old APS_UDP_receiver.m  % zuo 5/17/2022        
% %         switch lower(DET)
% %             %case {'pilatus2m', 'pilatus300k'}
% %             case {'eiger9m', 'pilatus300k'}
% %         %%% file transfer
% %         
% %                 %imgname = APS_12IDBfiletransfer(filen, workingDir);
% %                 imgname =  filen;
% %                 
% %                 if isempty(imgname)
% %                     continue;
% %                 end
% %                 if strcmp(imgname, '')
% %                     fprintf('File Transfer Failed\n');
% %                     continue;
% %                 end
% %             otherwise
% %                 [~, bd, ext] = fileparts(filen);
% %                 imgname = [bd, ext];
% %         end
        
        
        %%% Azimuthal average
        
% %         if numel(pSpace) == 2
% %             avg.photodiode = str2double(data(pSpace(2)+1:length(data)));
% %         elseif numel(pSpace) == 3
% %             avg.photodiode = str2double(data(pSpace(2)+1:pSpace(3)-1));
% %             avg.I0ofsample = str2double(data(pSpace(3)+1:length(data)));
% %         elseif numel(pSpace) == 4
% %             avg.photodiode = str2double(data(pSpace(2)+1:pSpace(3)-1));
% %             avg.I0ofsample = str2double(data(pSpace(3)+1:pSpace(4)-1));
% %             avg.expt = str2double(data(pSpace(4)+1:length(data)));
% %         end
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
        switch lower(DET)
            %case 'pilatus2m'
            case 'eiger9m'    
                dirN = 'SAXS';
                m = saxs;
            case 'pilatus300k'
                dirN = 'WAXS';
                m = waxs;
            case 'pe'
                dirN = 'PE';
                m = laxs;
            %case 'mar300'
            case 'pilatus2m'    
                dirN = 'SAXS';
                m = saxs;
                %pause(2)
            case 'mar12bm'
                dirN = 'SAXS';
                m = saxs;
        end
                
        try
%            [~, ~, savefilename] = avgfile0(avg);
            tic;
            [~, ~, savefilename] = avgfile0_new(avg, m, dirN);
            t2=toc;
            fprintf('It takes %.5f sec to average.\n\n', t2);
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
% %         if ~isempty(savefilename)
% % %            connect2plot1d(DET)
% %             cmd = sprintf('open1Ddata %s', savefilename);
% %             if ~strcmpi(DET, 'pilatus300k')
% %                 %mysock = broadcast(mysock, cmd, dN, port);
% %                 broadcast(cmd, dN, port);
% %             end
% %         end
    end
    drawnow('update')
end
pnet('closeall')

% %     function mysock = broadcast(mysock, cmd, dN, input_port)
% % %        nRH = numel(remotehost);
% %         remotesock_port = remotesock_list(dN);
% %         myport = sockbase_list + input_port - fix(input_port/100)*100;
% % %        myport = linspace(portbaseS, portS+nRH-1, nRH);
% %         if numel(mysock) ~= numel(myport)
% %             mysock = -1*ones(size(myport));
% %         end
% %         
% %         for i=1:numel(myport)            
% %             newconnection = 0;
% % %            fprintf('%i is %s\n', mysock(i), remotehost{i})
% %             try
% %                 pnet(mysock(i), 'status');
% %             catch
% %                 mysock(i) = -1;
% %             end
% % %            fprintf('%i is %s\n', mysock(i), remotehost{i})
% %             if mysock(i) < 0
% %                 mysock(i)=pnet('udpsocket', myport(i));
% %                 if mysock(i) < 0
% %                     fprintf('Not successful UDP connection from port %i to %s:%i.\n', myport(i), remotehost{i}, remotesock_port)
% %                     continue;
% %                 end
% %                 newconnection = 1;
% %             end
% %             if newconnection > 0
% %                 pnet(mysock(i),'udpconnect',remotehost{i},remotesock_port);
% %                 fprintf('%s:%i is connected to Port %i.\n', remotehost{i}, remotesock_port, myport(i));
% %             end
% %         end
% %         for i=1:numel(myport)
% %             try
% %                 pnet(mysock(i), 'write', cmd);
% %                 n = pnet(mysock(i), 'writepacket');
% %             catch
% %                 n = -1;
% %             end
% %             if n~=0
% %                 pnet(mysock(i), 'close')
% %                 mysock(i) = -1;
% %             end
% %         end
% % 
% %     end


    function broadcast(cmd, dN, input_port)
%        nRH = numel(remotehost);
        remotesock_port = remotesock_list(dN);
        myport = sockbase_list + input_port - fix(input_port/100)*100;
        
        for i=1:numel(myport)
            myhost = remotehost{i};
            connect2plot1d(remotesock_port, myport(i), myhost, cmd)
        end

    end

    function mysock = connect2plot1d(dN, port)
        
        remotesock_port = remotesock_list(dN);
        myport = sockbase_list + port - fix(port/100)*100;
        mysock = -1*ones(size(remotehost));
        for i=1:numel(myport)            
            mysock(i)=pnet('udpsocket', myport(i));
            pnet(mysock(i),'udpconnect',remotehost{i},remotesock_port);
        end

    end

end
