function APS_UDP_sender(filename, counter, host, port)
if nargin < 1
    dirname = 'c:\test';
    filename = 'test2.dat';
    filename = sprintf('%s\\%s %i', dirname, filename);
end
if nargin < 2
    counter = 1111;
end
cmdstring = sprintf('%s %i', filename, counter);
%APS_UDP_sender

udp=pnet('udpsocket',3333);

if nargin < 3
    host = 'localhost';
end
if nargin < 4
    APS_12IDB_port = 3333;
else
    APS_12IDB_port = port;
end
%host = 'localhost';

if udp~=-1,
    try % Failsafe
        pnet(udp,'write',cmdstring);              % Write to write buffer
        pnet(udp,'writepacket',host,APS_12IDB_port);   % Send buffer as UDP packet
        disp(sprintf('%s is sent', cmdstring))
    end
    pnet(udp,'close');
end
