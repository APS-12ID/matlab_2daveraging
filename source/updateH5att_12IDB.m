function updateH5att_12IDB(filen,values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nParam = 8; % number of fields to update
if numel(values)<nParam
    for kk=1: (nParam-(numel(values)))
        values=[values 0];
    end
end
try
    h5write(filen, '/entry/sample/temperature',    double(values(1)));
catch
    warning('temperature value was not updated.'); 
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/ExposureTime', single(values(2)));
catch
    warning('ExposureTime value was not updated.'); 
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/It_phd',       int32(values(3)));
catch
    warning('It_phd value was not updated.');    
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/IC1_phd',      int32(values(4)));
catch
    warning('IC1_phd value was not updated.');
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/SAXS_phd',     int32(values(5)));
catch
    warning('SAXS_phd value was not updated.');
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/CenterBS_phd', int32(values(6)));
catch
    warning('CenterBS_phd value was not updated.');
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/GISAXS_phd',   int32(values(7)));
catch
    warning('GISAXS_phd value was not updated.');
end
pause(0.01);

try
    h5write(filen, '/entry/Metadata/GIWAXS_phd',   int32(values(8)));
catch
    warning('GIWAXS_phd value was not updated.');
end
pause(0.01);
%h5write(filen, '/entry/Metadata/Sample_DataName', filen);
end

