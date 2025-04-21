function [DETs, DETport0, Nworker, beamlineDET] = get_grape_config(varargin)
DETs = {'eiger9m', 'pilatus300k', 'pe', 'pilatus2m', 'mar300'};
DETport0 = [3333, 3343, 3353, 3363, 3373];
Nworker = 2;
beamlineDET = {};
if numel(varargin)==1
    beamline = varargin{1};
    switch beamline
        case '12idb'
            beamlineDET = {'eiger9m', 'pilatus300k'};
        case '12idc'
            beamlineDET = {'pilatus2m'};
    end
end