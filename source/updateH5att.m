function updateH5att(filen,values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if numel(values)<8
    for kk=1:8-(numel(values))
        values=[values 0];
    end
end

h5write(filen, '/entry/sample/temperature',    double(values(1)));
h5write(filen, '/entry/Metadata/It_phd',       int32(values(2)));
h5write(filen, '/entry/Metadata/IC1_phd',      int32(values(3)));
h5write(filen, '/entry/Metadata/SAXS_phd',     int32(values(4)));
h5write(filen, '/entry/Metadata/CenterBS_phd', int32(values(5)));
h5write(filen, '/entry/Metadata/GISAXS_phd',   int32(values(6)));
h5write(filen, '/entry/Metadata/GIWAXS_phd',   int32(values(7)));
h5write(filen, '/entry/Metadata/ExposureTime', single(values(8)));
%h5write(filen, '/entry/Metadata/Sample_DataName', filen);
end

