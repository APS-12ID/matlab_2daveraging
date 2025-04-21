function SAXS_grape_distr(DET)
[DETs, DETport0, Nserver] = get_grape_config;
DETtype = findcellstr(DETs, DET);
DETport = DETport0(DETtype);
%tcpobj = cell(Nserver, 1);
udpobj = cell(Nserver, 1);
for i=1:Nserver
    port = DETport+i;
    try
        %tcpobj{i} = jtcp('request', 'localhost', port, 'timeout', 1000);
        udpobj{i} = port;
    catch
        %tcpobj{i} = [];
        udpobj{i} = [];
    end
end

%t = cellfun(@isempty, tcpobj);
%tcpobj(t) = [];
%Nserver = numel(tcpobj);
t = cellfun(@isempty, udpobj);
udpobj(t) = [];
Nserver = numel(udpobj);
isrun = true;

udp = pnet('udpsocket',DETport);

fprintf('%i worker is available for %s.\n', Nserver, DET)
while isrun
    len = pnet(udp,'readpacket');
    %msg = judp('receive', DETport, 1000, 1000); 
    %data = char(msg');
    %len = length(data);
    if len>0
        data=pnet(udp,'read',1000,'string');
        disp(data)
        sendall = false;
        if contains(data, 'loadmat ')
            sendall = true;
        end
        if contains(data, 'changedir')
            sendall = true;
        end
        cmd2send = data;
        if sendall
            for i=1:Nserver
                %jtcp('write', tcpobj{i}, cmd2send)
                judp('send', udpobj{i}, 'grape.xray.aps.anl.gov', int8(cmd2send))
            end
            i=1;
        else
            %jtcp('write', tcpobj{i}, cmd2send);
            judp('send', udpobj{i}, 'grape.xray.aps.anl.gov', int8(cmd2send))
            i = i + 1;
            if i>Nserver
                i = 1;
            end
        end
    end
end