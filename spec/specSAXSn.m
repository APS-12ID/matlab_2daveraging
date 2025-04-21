function [counts, filen, dates]=specSAXSn(specfilename, fileindex, fileext)
%
% function [counts, filen]=specSAXSn(specfilename, fileindex, fileext)
% all three inputs should be typed in...
% This function enables to load SPEC scan data
%
% MZ 8.3.95
% DFM 30.9.95
% EF 4.9.97

%---- Read through data file to find right scan number (uses ffind mex file)


fid=fopen(specfilename, 'rt');

%-----Read data -------------------------------------------
data=[];
r=fgetl(fid);
counts = [];
filen = [];
dates = [];
if (nargin <3)
   fileext = [];
end
if isempty(fileext)
%   nargin = 2;
end

if numel(fileindex) >= 1
    fnn = 1;
    fi = fileindex(fnn);
end

for mm = 1:numel(fileindex)
    fi = fileindex(mm);
    for kk = 1:numel(fileext)
        fe = fileext(kk);
        searchfile(fi, fe);
        filen = [filen;file];
        counts = [counts;count];
        dates = [dates;dat];
    end
end

function searchfile(fi, fe)
    while (1)
	if ((length(r)>2) & (strcmp(r(1:2), '#Z')))
	    if nargin == 1
            strtmp = sprintf('%0.5d', fi);
	    elseif nargin == 2
            if isstr(fe)
                strtmp = sprintf('%0.5d.%s', fi, fe);
            else
                strtmp = sprintf('%0.5d.%0.3d', fi, fe);
            end
        end
        if ((length(r) > length(strtmp)+3) & (findstr(r, strtmp) > 0))
    		[file, num] = sscanf(r, '#Z %s', 1);
    		strtmp = ['#Z ', file];
        	strtmp = [strtmp, ' %f %f %f %f %f %f %f %f %f %f'];
    		[count, Nb, errmsg, nextindex] = sscanf(r, strtmp, 10);
            count = count(:)';
            if ~isempty(errmsg)
                dat = r(nextindex:end);
            end
            break;
	    end
	elseif (length(r) == 1)
	    if (r == -1)
		break;
	    end
	end

	rold = r;
	r = fgetl(fid);
    end
end
fclose(fid);
end