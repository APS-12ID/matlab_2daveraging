function SAXS_grape_server_12idb_closeall(varargin)
close('all')
beamlineDET = {'eiger9m', 'pilatus300k'};
[DETs, DETport0, Nserver] = get_grape_config;
for k=1:numel(beamlineDET)
    DET = beamlineDET{k};
    for j=1:Nserver
        port = get_port(DETs, DETport0, DET)+j;
        [a, b] = system(sprintf('lsof -i:%i', port));
        if a==0
            fprintf('Port %i is in use.\n', port)
            % kill
            lf = strfind(b, newline);
            for m=1:numel(lf)-1
                l = b((lf(m)+1):(lf(m+1)-1));
                [key, val] = strtok(l, ' ');
                if contains(key, 'MATLAB')
                    pid = strtok(val, ' ');
                    cmd = sprintf('kill %s', pid);
                    system(cmd);
                end
            end
        end
    end
end

function DETport = get_port(DETs, DETport0, DET)
    DETtype = findcellstr(DETs, DET);
    DETport = DETport0(DETtype);