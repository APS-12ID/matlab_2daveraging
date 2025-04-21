function save12IDsetup(path)

try
    saxs = evalin('base', 'saxs');

    sdd = saxs.SDD;

    if isfield(saxs, 'pSize')
        pSize = saxs.pSize;
    elseif isfield(saxs, 'psize')
        pSize = saxs.psize;
    end
    if isfield(saxs, 'BeamXY')
        bxy = saxs.BeamXY;
    elseif isfield(saxs, 'center')
        bxy = saxs.center;
    end
    if isfield(saxs, 'yaw')
        yaw = saxs.yaw;
    else
        yaw = 0;
    end
    fid = fopen(sprintf('%s/.currentSAXSsetup', path), 'w');
    fprintf(fid, '# beamX beamY PixelSize SDD Yaw\n');
    fprintf(fid, '%0.4f %0.4f %0.3f %0.3f %0.5f\n', bxy(1), bxy(2), pSize, sdd, yaw);
    fclose(fid);
catch
    saxs = [];
end

try
    waxs = evalin('base', 'waxs');
    sdd = waxs.SDD;
    
    if isfield(waxs, 'pSize')
        pSize = waxs.pSize;
    elseif isfield(waxs, 'psize')
        pSize = waxs.psize;
    end
    if isfield(waxs, 'BeamXY')
        bxy = waxs.BeamXY;
    elseif isfield(waxs, 'center')
        bxy = waxs.center;
    end
    if isfield(waxs, 'yaw')
        yaw = waxs.yaw;
    else
        yaw = 0;
    end
    fid = fopen(sprintf('%s/.currentWAXSsetup', path), 'w');
    fprintf(fid, '# beamX beamY PixelSize SDD Yaw\n');
    fprintf(fid, '%0.4f %0.4f %0.3f %0.3f %0.5f\n', bxy(1), bxy(2), pSize, sdd, yaw);
    fclose(fid);
catch
    waxs = [];
end


