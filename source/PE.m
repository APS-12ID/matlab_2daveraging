classdef PE < CCD
    properties
        PREFIX = [];
        SATURATION = 65000; %set to less than the real number 2^20 -1 for pilatus as it underflows rather than overflow
        DPIX = 0.1;
        CCDXSENSE = -1;
        CCDZSENSE = -1;
        CMIN = 0;
        CMAX=1000;
        CMAP='jet';
    end
    methods
        function obj = PE(prefix)
            if (nargin > 0)
                PF = prefix;
            else
                PF = '12idbPE:';
            end
            %check MCS.
%            obj = obj@CCD(PF);
            obj = obj@CCD(PF, 'TIFF1:');
            obj.PREFIX = PF;
            foo=mcastate;
            if ~isempty(foo),mcaclose(foo);end
            clear foo;
        end
    end
end