function [fileindex, extnum] = APS_getfileindex(filename)
[~, name, ~] = fileparts(filename);

if length(name) > 4
    p_ = strfind(name, '_');
    fileindex = str2double(name(p_(end-1)+1:p_(end)-1));
    extnum = str2double(name(p_(end)+1:length(name)));
else
    error('there is no fileindex in the filename')
end