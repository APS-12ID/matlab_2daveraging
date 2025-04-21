function varargout = APS_12IDBfiletransfer(imgname, targetDir)
% imgname = APS12IDBfiletransfer(filen, targetDir)
% example: 
%   APS12IDBfiletransfer('/disk2/Sjunk_00001_00001.tif', '/home/12id-b/')
%   APS12IDBfiletransfer('Sjunk_00001_00001.tif', '/home/12id-b/')
% This works on linux system only.
if strfind(imgname, '/')
    filen = imgname;
    [~, bf, et] = fileparts(filen);
    imgname = [bf, et];
else
    filen = [];
end
switch imgname(1)
    case 'S'
        det = 'det@pilatus2m';
%        detType = 'SAXS';
    case 'W'
        det = 'det@pilatus300';
%        detType = 'WAXS';
    otherwise
        kcount = 1;
        while (isempty(dir(fullfile(targetDir, filesep, imgname))))
            pause(0.25)
            kcount = kcount+1;
            if kcount > 5
                break
            end
        end
        varargout{1} = imgname;
        return
end
if isempty(filen)
    filen = ['/disk2/', imgname];
end

fullfilename = fullfile(targetDir, filesep, imgname);
%fullfilename = fullfile(targetDir, filesep, detType, imgname);
val = exist(fullfilename, 'file');
if val~=2
    copycmdStr = sprintf('scp %s:%s %s', det, filen, targetDir);
    %copycmdStr = sprintf('scp %s:%s %s/%s', det, filen, targetDir, detType);
    ret = 1;
    trial = 0;
    while ret == 1
        [ret, ~] = unix(copycmdStr);
        val = exist(fullfilename, 'file');
        if val
            break
        end
        pause(0.2)
        trial = trial + 1;
        if trial > 20
            ret = -1;
        end
    end
end
if val == 2
    fprintf('%s is transferred.\n', filen);
end
if nargout == 1
    if val == 2
        varargout{1} = imgname;
    else
        varargout{1} = '';
    end
end    
    
