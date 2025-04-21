function sinfo = APS_getinfofromfileindex(specfilen, fileindex, extensionnumber)
% [count, BS, energy, datafilename] = PLS_parsefile(specLogfilename,
% fileindex_or_datafilename];

% extract file format
[~, FF] = ffind(specfilen, 'FilenameFormat');
[~, FF] = strtok(FF);FF = strtrim(FF);
[~, FF, fextn] = fileparts(FF);
if nargin < 3
    extensionnumber = '';
end
%sinfo = cell(numel(fileindex), 1);
k = 0;
for i=1:numel(fileindex)
    findex = fileindex(i);
    datafilename = sprintf(FF, findex, extensionnumber);
    if isnumeric(extensionnumber)
        tmp = specSAXSn2(specfilen, datafilename);
        Ndata = 1;
    else
        tmp = specSAXSn2(specfilen, datafilename, 0);
        b = struct2table(tmp);
        b = table2cell(b);
        fn = fieldnames(tmp);
        t = cell2struct(b', fn);
        Ndata = numel(t);
        t2  = num2cell(t);
    end
    %b = struct2cell(tmp);b = b';
    sinfo(k+1:k+Ndata) = t2;
    k = k + Ndata;
end