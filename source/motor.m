classdef motor
    properties
        RBV = {'RBV', [], 'float', []}
        VAL = {'VAL', [], 'float', []}
        DMOV = {'DMOV', [], 'int', []}
    end
        
    methods 
        
        function obj = motor(beamline, motorname)
            if nargin == 0;
                PREFIX = '12idb:';
            else
                PREFIX = beamline;
            end
            PREFIX = [PREFIX, motorname, '.'];
            t = fieldnames(obj);
            for i=1:numel(t)
                val = obj.(t{i});
                if iscell(val) && (numel(val) == 4)
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
           
        function obj = move(obj, val)
            % change motor position.
            mcaput(obj.VAL{2}, val);
        end   
        
        function obj = wait(obj)
            % change motor position.
            while(1)
                obj = get(obj);
                if obj.DMOV{4}
                    break
                end
            end
        end 
        
        function obj = readfields(obj, fn)
            val = obj.(fn);
            rtn = mcaget(val{2});
%            rtn = [15 31];
            switch val{3}
                case 'string';
                    rtn = char(rtn);
            end
            val{4} = rtn;
            obj.(fn) = val;
        end
        
    end

end