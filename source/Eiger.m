classdef Eiger < CCD
    properties
        PREFIX = [];
        SATURATION = 500000; %set to less than the real number 2^20 -1 for pilatus as it underflows rather than overflow
        DPIX = 0.172;
        CCDXSENSE = -1;
        CCDZSENSE = -1;
        CMIN = 0;
        CMAX=1000;
        CMAP='jet';
    end
    methods
        function obj = Eiger(prefix)
            if (nargin > 0)
                PF = prefix;
            else
                PF = '12idbEGR:';
            end
            %check MCS.
            obj = obj@CCD(PF);
            obj.PREFIX = PF;
            foo=mcastate;
            if ~isempty(foo),mcaclose(foo);end;
            clear foo;
        end
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % drawnow;
% areadet_pvs_init;     %%Define FPGA type CCD control related PVs
% control_pvs_init;      %%Define Beamline related PVs
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% updateinfo('PILATUS Selection is Done and is Ready for Use...');