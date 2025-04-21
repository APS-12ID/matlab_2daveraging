function SAXS_grape_server_12idc
[DETs, DETport0, Nserver, beamlineDET] = get_grape_config('12idc');

k = 1;
j = 1;
while 1
    DET = beamlineDET{k};
    port = get_port(DETs, DETport0, DET)+j;
    [a, b] = system(sprintf('lsof -i:%i', port));
    if a==0
        fprintf('Port %i is in use.\n', port)
        j = j+1;
        if j>Nserver
            j=1;
            k=k+1;
            if k>numel(beamlineDET)
                error('No connection is left to be made.')
            end
        end
        continue
    end
    fprintf('%s / Port %i is not in use and will be connected.\n', DET, port)
    break
%    end
end

%APS_UDP_receiver_jtcp(port)
%APS_UDP_receiver_judp(port)
APS_UDP_receiver_pnetudp(port)

function DETport = get_port(DETs, DETport0, DET)
    DETtype = findcellstr(DETs, DET);
    DETport = DETport0(DETtype);