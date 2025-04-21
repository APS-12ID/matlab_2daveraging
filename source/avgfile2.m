function [rtn, dataNorm] = avgfile2(specfile, fileindex, detector, SF, mu)
% function avgfile(specfile, fileindex[, detector])
% Azimuthal average. This function uses Lee's SAXSLee code.
%
% Average SAXS and WAXS data with the fileindex.
% To use this function, load saxssetup.mat or/and waxssetup.mat.
% 
% [rtn, dataNorm] = avgfile(specfile, fileindex)
%   then .BS will be the default detector for choice.
% [rtn, dataNorm] = avgfile(specfile, fileindex, detector)
%   detector : BS, COUNT3, or IC
%
% SF : scale factor
% mu : linear abosrption coefficient in cm^-1 unit.
%
% Byeongdu Lee
% 2014/07/16

%Note: To prevent stopping due to error message when manually denerating
%qmap, and not averaging WAXS, several changes were made: Line 74 changed
%to line 73, 92-96 captioned out.

try
    si = APS_getinfofromfileindex(specfile, fileindex);
catch
    rtn = -1;
    return 
end

Scalefactor = 1;
d = 1; % sample thickness, 1cm.
if nargin < 3
    DET = 'BS';
else
    switch detector
        case 'T'
            DET = 'T';
        otherwise
            DET = detector;
    end
    if nargin > 3
        Scalefactor = SF;
    end
end

[datadir, ~] = fileparts(specfile);
if isempty(datadir)
    datadir = pwd;
end

for k = 1:numel(si)
    switch DET
        case 'T'
            T = si{k}.Count3/si{k}.Exposuretime/(si{k}.Fullbeam/0.2); % transmittance
            if T> 5
                T = T*0.0172; %attenuation factor
                 %fprintf('Transmittance is larger than 1 and data will be then negative.\n')
                 %fprintf('Count3 is %0.3f and Full beam is %0.3f\n', si{k}.Count3/si{k}.Exposuretime, si{k}.Fullbeam/0.2)
            end
            if nargin==5
                d = -log(T)/mu;
            end
            phd = T*si{k}.Exposuretime; % exposure time normalized.
        otherwise
            phd = si{k}.(DET);
    end
    
    [~,fn,ext]=fileparts(si{k}.Filename);
    qmap = evalin('base', 'qmap');
    if isempty(qmap)
        error('qmap is not ready. Use "saxsaverage"')
    end
    
    for t = 1
        %t = 1:2 %ajs edit, see note above
        %eng0=eng;
        try
            switch t
                case 1
                m = evalin('base', 'saxs');
                dfn = fn;
                dirN = 'SAXS';
                case 2
                m = evalin('base', 'waxs');
                dfn = ['W', fn(2:end)];
                dirN = 'WAXS';
            end
        catch
            m = [];
        end
        %dataNorm=[data(:,1) data(:,2:3)/phd data(:,4:end)]; %ajs edit
%         if isempty(m)
%             fprintf('No success in averaging.\n');
%             fprintf('Load either saxssetup.mat or waxssetup.mat\n');
%             return
%         end
        datafilename = fullfile(datadir, dirN, [dfn, ext]);
        savefilename = fullfile(datadir, dirN, 'Averaged', [dfn, '.dat']);
        %sImg=imgUpsideDn(double(imread(datafilename)));
        %[~, sImg] = openccdfile(datafilename, m); %% need iminfo.....
        sImg=flipud(double(imread(datafilename)));
        eng0=m.xeng;
	eng = si{k}.Energy;
        data = doaverage2(sImg, qmap, m, []);
        if eng>0
            dataNorm=[data(:,1)*eng/eng0  data(:,2:end)/phd*Scalefactor/d];
        else
            dataNorm=[data(:,1) data(:,2:end)/phd*Scalefactor/d];
        end
        try
            dlmwrite(savefilename,dataNorm,'delimiter','\t','precision','%.8f');
            rtn = 1;
        catch
            rtn = 0;
            fprintf('Cannot write file on the disk.\n')
        end
    end
end

function varargout = doaverage2(varargin)

img = varargin{1};
avg = varargin{2};
saxs = varargin{3};
mu = varargin{4};

if isfield(saxs, 'mask')
    mk = saxs.mask;
else
    mk = [];
end

N_thrange = numel(mu)/2;
if N_thrange == 0
    N_thrange = 1;
    thrange = [];
else
    thrange = mu(1, 1:2);
end

if N_thrange > 1
    data = cell(size(N_thrange));
else
    data = [];
end

for i=1:N_thrange
    if N_thrange>1
        thrange = mu(i, 1:2);
    end
    [q, Iq] = azimavg(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
    if N_thrange>1
        data{i} = [q(:), Iq(:)];
    else
        data = [q(:), Iq(:)];
    end
end
varargout{1} = data;
