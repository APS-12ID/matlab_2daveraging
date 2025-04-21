function epics_put_SAXSinfo
% function epics_put_SAXSinfo
% put SAXSinfo on to 12ID epics variables...

try
    saxs = evalin('base', 'saxs');
catch
    saxs = getgihandle;
end

if ~isempty(saxs)
    try
    epics_put('12idb:saxs:beamX', saxs.center(1));
    epics_put('12idb:saxs:beamY', saxs.center(2));
    catch
    epics_put('12idb:saxs:beamX', saxs.BeamXY(1));
    epics_put('12idb:saxs:beamY', saxs.BeamXY(2));

    end
    epics_put('12idb:saxs:det:pixelSize', saxs.pSize);
    epics_put('12idb:saxs:det:SDD', saxs.SDD);
    epics_put('12idb:saxs:yaw', saxs.yaw);
end

try
    waxs = evalin('base', 'waxs');
catch
    waxs = [];
end
if ~isempty(waxs)
    try
    epics_put('12idb:saxs:beamX', waxs.center(1));
    epics_put('12idb:saxs:beamY', waxs.center(2));
    catch
    epics_put('12idb:saxs:beamX', waxs.BeamXY(1));
    epics_put('12idb:saxs:beamY', waxs.BeamXY(2));

    end

    epics_put('12idb:saxs:det:pixelSize', waxs.pSize);
    epics_put('12idb:saxs:det:SDD', waxs.SDD);
    epics_put('12idb:saxs:yaw', waxs.yaw);
end


end

