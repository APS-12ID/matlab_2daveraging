classdef CCD
    properties
        PV_PREFIX = 'S12-PILATUS1:';
        TYPE = 'cam1:';
        FILE_PLUGIN = 'HDF1:';
        %ROI = '';  %%Leave this as empty. This gets defined in the 'roi' function
        INTERFACE = '';
        SOFTWARE = 'AREADET';
        EXPOSURE_CONTROL = 1; %0 defines CCDs like SMD where frame rate is used
        EXPOSURE_PERIOD_CONTROL = 1; %1 defines CCDs like FCCD an acquire period can be defined
        MIN_EXPOSURE_PERIOD=0.1; %minimum acquire period for the camera
        SHUTTER_CONTROL = 0; %1 defines CCD's that allow shutter control
        SAVE_IMG_STATISTICS_FLAG=0;
        IMG_STATISTICS_data=[];
        IMG_STATISTICS_header=[];
        PV_PREFIX_BEAMLINE = '12idb:';
        USE_DELAY_GEN = 0;
        GATE_COUNTER = 0;
        ADUPERPHOT = 1;
        PRV_FileName = '';
        PRV_TimeStamp = 0;
        FILE_PLUGIN_N_FIELDS = 7;
        
% File_Flugin
        FilePath = {'HDF1:FilePath', [], 'string', []};
        FileName = {'HDF1:FileName', [], 'string', []};
        FileTemplate = {'HDF1:FileTemplate', [], 'string', []};
        FileNumber = {'HDF1:FileNumber', [], 'string', []};
        AutoIncrement = {'HDF1:AutoIncrement', [], 'int',[]}
        FullFileName = {'HDF1:FullFileName_RBV', [], 'string',[]}
        SeqNumber = {'HDF1:FileNumber_RBV', [], 'int', []}
%        ROI_Save = {'cam1:Capture', [], 'int', []};

% Image_Flugin
        ArrayNumber = {'HDF1:ArrayCounter_RBV', [], 'int', []}
        TIMESTAMP = {'HDF1:TimeStamp_RBV', [], 'float',[]}
        ImageDims = {'HDF1:Dimensions_RBV', [], 'int', []}
        ImageData = {'image1:ArrayData', [], 'int', []}
        %ImageData = {'Pva1:Image', [], 'int', []}
% DET
        ExposureTime = {'cam1:AcquireTime', [], 'float', []}
        ExposurePeriod = {'cam1:AcquirePeriod', [], 'float', []}
        NumImage = {'cam1:NumImages_RBV', [], 'int', []}
        NumExposures = {'cam1:NumImages', [], 'int', []}
        TriggerMode = {'cam1:TriggerMode', [], 'int', []}
        AcquirePOLL = {'cam1:Acquire', [], 'int', []}
        DetectorState = {'cam1:DetectorState_RBV', [], 'int', []}
        Det_X_size = {'cam1:MaxSizeX_RBV', [], 'int', []};
        Det_Y_size = {'cam1:MaxSizeY_RBV', [], 'int', []};
        
    end
    methods 
        function obj = CCD(varargin)
            CCDPV = varargin{1};
            if numel(varargin) > 1
                obj.FILE_PLUGIN = varargin{2};
            end
            if nargin == 0
                PREFIX = 'S12-PILATUS1:';
            else
                PREFIX = CCDPV;
            end
            
            obj.PV_PREFIX = PREFIX;
            t = fieldnames(obj);
            k = 1;
            for i=1:numel(t)
                val = obj.(t{i});
                if iscell(val) && (numel(val) == 4)
                    if k <= obj.FILE_PLUGIN_N_FIELDS
                        val{1} = strrep(val{1}, 'cam1:', obj.FILE_PLUGIN);
                        k = k + 1;
                    end
                    str = strcat(PREFIX, val{1});
                    val{1} = str;
                    obj.(t{i}) = val;
                end
            end
           
        end
        
        function obj = connect(obj)
            t = fieldnames(obj);
            for i=1:numel(t)
                val = obj.(t{i});
                if iscell(val) && (numel(val) == 4)
                    PV = val{1};
                    handle = mcaopen(PV);
%		    handle = 1;
%                    dt = mcaget(handle);
                    if (handle>0)
                        fprintf('%s : Connected\n', PV);
                    else
                        fprintf('%s : Not Connected\n', PV);
                    end
                    val{2} = handle;
%                    val{4} = dt;
                    obj.(t{i}) = val;
                end
            end
        end
        function obj = disconnect(obj)
            t = fieldnames(obj);
            for i=1:numel(t)
                val = obj.(t{i});
                if iscell(val) && (numel(val) == 4)
                    %PV = val{1};
                    h = mcaisopen(val{1});
                    if h; mcaclose(val{2});end
%                    dt = mcaget(handle);
                    val{2} = [];
                    val{4} = [];
%                    val{4} = dt;
                    obj.(t{i}) = val;
                end
            end
        end
        
        function obj = get(obj, fn)
            if (nargin < 2)
	        t = fieldnames(obj);
                for i=1:numel(t)
                    val = obj.(t{i});
                    if iscell(val) && (numel(val) == 4)
                        obj = readfields(obj, t{i});
                    end
                end
            elseif (nargin == 2)
                obj = readfields(obj, fn);
            end
        end
        
        function img = reshapeimg(obj)
            img = obj.ImageData{4};
            dims = obj.ImageDims{4}(1:2);
            lX = dims(1);
            lY = dims(2);

            img = img(1:lX*lY);
            img = flipud(reshape(img, lX, lY)');
        end
        
        function obj = readfields(obj, fn)
            val = obj.(fn);
            rtn = mcaget(val{2});
%            rtn = [15 31];
            switch val{3}
                case 'string'
                    rtn = char(rtn);
            end
            val{4} = rtn;
            obj.(fn) = val;
            if strcmp(fn, 'ImageData')
                rtn = reshapeimg(obj);
                val{4} = rtn;
                obj.(fn) = val;
            end
        end
        
    end

end
