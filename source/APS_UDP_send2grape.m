function APS_UDP_send2grape(cmd, port)
host = 'grape.xray.aps.anl.gov';
if nargin < 2
    port = 3333;
end
udp=pnet('udpsocket',port);
APS_12IDB_port = port;
%host = 'localhost';

pnet(udp,'write',cmd);              % Write to write buffer
pnet(udp,'writepacket',host,APS_12IDB_port);   % Send buffer as UDP packet
fprintf(sprintf('%s is sent.\n', cmd))
pnet(udp,'close');
