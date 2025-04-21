function SAXSWAXSfiletransfer3

tm.filen = 'metafiles.tmp';
tm.fidPos = -1;
%transfertimer.baseDir = pth;

t=timer('Tag','SAXSWAXSautocopy');
set(t,'StartDelay', 1,...
    'TimerFcn', @SAXSLee_12IDB_data_autotransfer,...
    'StartFcn', @SAXSLee_12IDB_data_autotransfer_start,...
    'ExecutionMode','fixedRate',...
    'BusyMode','drop',...
    'TasksToExecute',inf,...
    'Period',5);
%    'StopFcn',  @SAXSLee_12IDB_data_autotransfer_stop,...
tm.timer = t;
assignin('base', 'transfertimer', tm);

start(t);
%wait(t);

    function SAXSLee_12IDB_data_autotransfer_start(varargin)
    tm = evalin('base', 'transfertimer');
    fid = fopen(tm.filen);
    if fid < 0
        stop(tm.timer)
        return
    end

    if tm.fidPos ~= -1
        fseek(fid, tm.fidPos,'bof');  % move fid to end of the last stored scan
    %    fgetl(fid);      % skip the currentline (head of the last stored scan);
    end

    while feof(fid) == 0
        tempfid = ftell(fid);
        scanline = fgetl(fid);
        %[fl, ~] = sscanf(scanline, 'scp', 1);
        [~,logfn, ~] = fileparts(scanline);
        dtSfile = ['SAXS/S',logfn(2:end), '.tif'];
        dtWfile = ['WAXS/W',logfn(2:end), '.tif'];
        fidSAXS = fopen(dtSfile);
        fidWAXS = fopen(dtWfile);
        if (fidSAXS > 0) && (fidWAXS>0)
            tm.fidPos = tempfid;
            fclose(fidSAXS);
            fclose(fidWAXS);
        else
            if (fidSAXS > 0)
                fclose(fidSAXS);
            end
            if (fidWAXS > 0)
               fclose(fidWAXS);
            end
          
            break
        end
    end
    fclose(fid);
    assignin('base', 'transfertimer', tm);
    end

    function SAXSLee_12IDB_data_autotransfer(varargin)

    tm = evalin('base', 'transfertimer');
    fid = fopen(tm.filen);
    if tm.fidPos ~= -1
        fseek(fid,tm.fidPos,'bof');  % move fid to end of the last stored scan
        fgetl(fid);      % skip the currentline (head of the last stored scan);
    end
    tm.fidPos
    while feof(fid) == 0
        tempfid = ftell(fid);
        scanline = fgetl(fid);
        try
            ID12B_filetransfer(scanline)
        catch
            fprintf('%s, No success\n', scanline)
        end
        tm.fidPos = tempfid;
    end
    fclose(fid);
    assignin('base', 'transfertimer', tm);

    end

end

%function extractfilename(lineread)
