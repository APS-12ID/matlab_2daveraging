function SAXS_grape_server_test(DET, serverN)

[DETs, DETport0, Nserver] = get_grape_config;

%Nserver = 1;


if nargin == 1
    %serverN = 1;
    port = get_port(DETs, DETport0, DET);
    j = 1;
    while 1
    %for k=1:numel(DETs)
    %    for j=1:5
        %DET = DETs{k};
        serverN = j;
        port = get_port(DETs, DETport0, DET);
        [a, b] = system(sprintf('lsof -i:%i', port));
        if a==0
            fprintf('Port %i is in use.\n', port)
            j = j+1;
            if j>Nserver
                error('No more worker')
            end
            continue
        end
        fprintf('%s / Port %i is not in use and will be connected.\n', DET, port)
        break
    %    end
    end
end

if nargin == 0
    k = 1;
    j = 1;
    while 1
    %for k=1:numel(DETs)
    %    for j=1:5
        DET = DETs{k};
        serverN = j;
        port = get_port(DETs, DETport0, DET);
        [a, b] = system(sprintf('lsof -i:%i', port));
        if a==0
            fprintf('Port %i is in use.\n', port)
            j = j+1;
            if j>Nserver
                j=1;
                k=k+1;
                if k>numel(DETs)
                    error('No connection is left to be made.')
                end
            end
            continue
        end
        fprintf('%s / Port %i is not in use and will be connected.\n', DET, port)
        break
    %    end
    end
end

if nargin==2
    port = get_port(DETs, DETport0, DET);
end

APS_UDP_receiver_jtcp(port)

function DETport = get_port(DETs, DETport0, DET)
    DETtype = findcellstr(DETs, DET);
    DETport = DETport0(DETtype);