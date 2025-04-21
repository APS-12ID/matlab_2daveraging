function ret = epics_get(PVname)
[ret, val] = system(sprintf('caget %s', PVname));
[tok, val] = strtok(val);
if strcmp(tok, PVname)
    ret = val;
else
    ret = [];
end
