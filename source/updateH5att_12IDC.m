function updateH5att_12IDC(filen,values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nParam = 5; % number of fields to update
if numel(values)<nParam
    for kk=1: (nParam-(numel(values)))
        values=[values 0];
    end
end
try
h5write(filen, '/entry/sample/temperature',    double(values(1)));
h5write(filen, '/entry/Metadata/ExposureTime', single(values(2)));
h5write(filen, '/entry/Metadata/It_phd',       int32(values(3)));
h5write(filen, '/entry/Metadata/IC_phd',      int32(values(4)));
h5write(filen, '/entry/Metadata/IC2_phd',     int32(values(5)));
catch
    warning('some parameter was not updated.');
end
%h5write(filen, '/entry/Metadata/Sample_DataName', filen);
end

