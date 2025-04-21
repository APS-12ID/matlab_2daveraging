function newpath = pathwithspace(path)
blankp = strfind(path, ' ');
escapechar = '\';
if ~isempty(blankp)
    blankp = [1, blankp];
    newpath = '';
    for i=1:numel(blankp)
        temp = path(blankp(i):blankp(i)-1);
        newpath = [newpath, escapechar, temp];
    end
    newpath = [newpath, escapechar, path(blankp(end):end)];
else
    newpath = path;
end
