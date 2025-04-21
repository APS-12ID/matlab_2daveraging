function data = ID12B_headerread(filename, headername)
% 'ID12B_headerread' is to read dnd 1D data files.
% data = ID12B_headerread(filename, keyword)
%
data = 'error';
fdd = fopen(filename, 'r');
if fdd < 0
    [pth, fn, ext] = fileparts(filename);
    %nfn = [pth, filesep, 'L', fn(2:end), ext];
    nfn = [pth, filesep, 'L', fn(2:end), '.meta'];
    fdd = fopen(nfn, 'r');
end

line = fgetl(fdd);

while line~=-1
    [head, R] = strtok(line, ':');
    t = strfind(head, headername);
    if ~isempty(t)
        data = R(2:end);
        break
    end
    line=fgetl(fdd);
end
fclose(fdd);