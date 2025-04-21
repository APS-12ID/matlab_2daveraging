function [rtn, dataNorm, savefilename] = avgfile0(avg)
% function avgfile0(avg)
% Azimuthal average. This function uses Zuo's code.
%
% Average SAXS and WAXS data with the fileindex.
% To use this function, load saxssetup.mat or/and waxssetup.mat.
% fullfile(avg.dir, avg.filename), avg.photodiode, avg.absoluteSF
%
% Byeongdu Lee
% 2014/07/16
filename = fullfile(avg.dir, avg.filename);
BS = avg.photodiode;
if ischar(BS)
    BS = str2double(BS);
end
if ischar(avg.absoluteSF)
    avg.absoluteSF = str2double(avg.absoluteSF);
end
if ischar(avg.I0ofstandard)
    avg.I0ofstandard = str2double(avg.I0ofstandard);
end
if ischar(avg.I0ofsample)
    avg.I0ofsample = str2double(avg.I0ofsample);
end
Scalefactor = avg.absoluteSF;%*avg.I0ofstandard/avg.I0ofsample;

AVGfolder = [];

d = 1; % sample thickness, 1cm.
%offset = 0;    
[datadir, fn, ext]=fileparts(filename);
switch fn(1)
    case 'S'
        try
            m = evalin('base', 'saxs');
        catch 
            m = [];
            fprintf('saxssetup.mat is not loaded.\n');
        end
        dfn = fn;
        dirN = 'SAXS';
        if isfield(saxs, 'absIntCoeff')
            Scalefactor = saxs.absIntCoeff;
        end
        
    case 'W'
        try
            m = evalin('base', 'waxs');
        catch
            m = [];
            fprintf('waxssetup.mat is not loaded.\n');
        end
        dfn = ['W', fn(2:end)];
        dirN = 'WAXS';
         if isfield(waxs, 'absIntCoeff')
            Scalefactor = waxs.absIntCoeff;
        end       
    case 'P'
        try
            m = evalin('base', 'laxs');
        catch
            m = [];
            fprintf('PEsetup.mat is not loaded.\n');
        end
        dfn = ['P', fn(2:end)];
        dirN = 'PE';
         if isfield(laxs, 'absIntCoeff')
            Scalefactor = laxs.absIntCoeff;
        end       
        
        %offset = 100;
    otherwise
end

if isempty(m)
    rtn = -1;
    return
end
  
if isempty(dfn)
    rtn = 0;
    return
end

datafilename = fullfile(datadir, dirN, [dfn, ext]);
if isempty(AVGfolder)
    AVGfolder = 'Averaged';
end

savefilename = fullfile(avg.dir, dirN, AVGfolder, [dfn, '.dat']);
%sImg=imgUpsideDn(double(imread(datafilename)));
try
    sImg=flipud(double(imread(datafilename)));
catch
    sImg = [];
    fprintf('File %s is not found\n', datafilename);
end
%sImg = sImg - offset;
if isempty(sImg)
    rtn = -2;
    return
end
data = circavgnew2(sImg, m.mask, m.qCMap, m.qRMap, m.qArray, m.offset, m.limits);
dataNorm=[data(:,1) data(:,2:3)/BS*Scalefactor/d];
try
    fid = fopen(savefilename, 'w');
    fprintf(fid, '%% Filename : %s\n', avg.filename);
    fprintf(fid, '%% Date & Time : %s\n', datestr(now));
    fprintf(fid, '%% X-ray Energy (keV) : %0.3f\n', avg.energy);
    fprintf(fid, '%% Exposure Time (s) : %0.3f\n', avg.expt);
    switch dirN
        case 'SAXS'
            if isfield(avg, 'saxsBC')
                fprintf(fid, '%% Beam Center : %0.5f, %0.5f\n', avg.saxsBC(1), avg.saxsBC(2));
                fprintf(fid, '%% Sample to Detector Distance (SDD) (mm) : %0.3f\n', avg.saxsSDD);
                fprintf(fid, '%% Detector Pixel Size (mm) : %0.3f\n', avg.saxsPIXSIZE);
            end
    end
    fprintf(fid, '%% Photodiode Value : %0.3f\n', BS);
    fprintf(fid, '%% I0 of Sample : %i\n', avg.I0ofsample);
    fprintf(fid, '%% I0 of Standard : %i\n', avg.I0ofstandard);
%    fprintf(fid, '%% Multiply I(q) with the sample thickness (cm) to convert it into absolute units.\n');
    fprintf(fid, '%% \n');
    fprintf(fid, '%% q(A^-1)   I(q)    sqrt(I(q))\n');
    fclose(fid);
    dlmwrite(savefilename,dataNorm,'delimiter','\t','precision','%.8e', '-append');
    fprintf('%s is processed\n', savefilename);
    rtn = 1;
catch
    rtn = 0;
    fprintf('Cannot write file on the disk.\n')
end