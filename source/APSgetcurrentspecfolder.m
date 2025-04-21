function [filepath, specfilename] = APSgetcurrentspecfolder(varargin)
if numel(varargin) < 1
    currentspec12ID = '~/.currentspecdatafile';
else
    currentspec12ID = varargin{1};
end
fid = fopen(currentspec12ID);
if fid < 0
    error('~/.currentspecdatafile is not existing')
    specfilename = -1;
    return
end
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break
    else
        specfilename = tline;
    end
end
fclose(fid);
filepath = fileparts(specfilename);