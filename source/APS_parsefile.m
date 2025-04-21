function [count, BS, energy, filename] = APS_parsefile(specfilen, datafilenameorindexnumber, extensionnumber)
% [count, BS, energy, datafilename] = PLS_parsefile(specLogfilename,
% fileindex_or_datafilename];
logsetting.BS.colN = 5;
logsetting.energy.colN = 3;

% extract file format
[~, FF] = ffind(specfilen, 'FilenameFormat');
[~, FF] = strtok(FF);FF = strtrim(FF);

if nargin < 3
    extensionnumber = 1;
end

fid = fopen(specfilen);
if isnumeric(datafilenameorindexnumber)
    findex = datafilenameorindexnumber;
    datafilename = sprintf(FF, findex, extensionnumber);
else
    datafilename = datafilenameorindexnumber;
end


while feof(fid) == 0
    scanline = fgetl(fid);
    if ~isempty(scanline)
        if ~isempty(strfind(scanline, '#Z')) 
            if ~isempty(strfind(scanline, datafilename))
                [count, BS, energy, filename] = PLS_parseline(scanline, logsetting);
            end
        end
    end
end
fclose(fid);
end