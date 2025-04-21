function epics_put_SWAXSinfo
% function epics_put_SAXSinfo
% put SAXSinfo on to 12ID epics variables...

try
    saxs = evalin('base', 'saxs');
catch
    saxs=[];
    %saxs = getgihandle;
end

if ~isempty(saxs)
    saxs
    try
    epics_put('12idb:saxs:beamX', saxs.center(1));
    epics_put('12idb:saxs:beamY', saxs.center(2));
    catch
    epics_put('12idb:saxs:beamX', saxs.BeamXY(1));
    epics_put('12idb:saxs:beamY', saxs.BeamXY(2));
    
    epics_put('12idbEGR:cam1:BeamX', saxs.BeamXY(1));
    epics_put('12idbEGR:cam1:BeamY', saxs.BeamXY(2));
    epics_put('12idbEGR:cam1:DetDist', saxs.SDD);

    end
    
    epics_put('12idb:saxs:det:pixelSize', saxs.pSize);
    epics_put('12idb:saxs:det:SDD', saxs.SDD);
    epics_put('12idb:saxs:det:name', saxs.detector);
    
    epics_put('12idb:saxs:yaw', saxs.yaw);    
    epics_put('12idb:saxs:qStandard', saxs.qStandard);
    epics_put('12idb:saxs:offset', saxs.offset);
    
    epics_put('12idb:data:absIntScaleFactor', saxs.absIntCoeff);
    epics_put('12idb:data:absIntStandard', saxs.absIntStandard);
    
end

try
    waxs = evalin('base', 'waxs');
catch
    waxs = [];
end
if ~isempty(waxs)
    waxs
    try
    epics_put('12idb:waxs:beamX', waxs.center(1));
    epics_put('12idb:waxs:beamY', waxs.center(2));
    catch
    epics_put('12idb:waxs:beamX', waxs.BeamXY(1));
    epics_put('12idb:waxs:beamY', waxs.BeamXY(2));

    end

    
    epics_put('12idb:waxs:det:pixelSize', waxs.pSize);
    epics_put('12idb:waxs:det:SDD', waxs.SDD);
    epics_put('12idb:waxs:det:name', waxs.detector);
    
    epics_put('12idb:waxs:yaw', waxs.yaw);    
    epics_put('12idb:waxs:qStandard', waxs.qStandard);
    epics_put('12idb:waxs:offset', waxs.offset);
    
    epics_put('12idb:data:absIntScaleFactor', waxs.absIntCoeff);
    epics_put('12idb:data:absIntStandard', waxs.absIntStandard);
    
    
end


end

