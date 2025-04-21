function SAXS_grape_server(DET, serverN)

if nargin < 1
    %DET = 'pilatus2m';
    DET = 'eiger9m';
    serverN = 1;
end
if nargin < 2
    serverN = 1;
end

switch lower(DET)
    %case 'pilatus2m'
    case 'eiger9m'    
        port = 3332 + serverN;
    case 'pilatus300k'
        port = 3342 + serverN;
    case 'pe'
        port = 3352 + serverN;
%    case 'mar300'
%        port = 3362 + serverN;
    case 'pilatus2m'
        port = 3362 + serverN;
    case 'mar12bm'
        port = 3372 + serverN;

    otherwise
        disp('DET should be pilatus2m, pilatus300k, pe, or mar300')
end

APS_UDP_receiver(port)
%APS_UDP_receiver_judp(port)
