function ret = epics_put(PVname, val)
if ischar(val)
    cmd = sprintf('caput %s %s', PVname, val);
else
    cmd = sprintf('caput %s %s', PVname, num2str(val));
end
[ret, val] = system(cmd);
