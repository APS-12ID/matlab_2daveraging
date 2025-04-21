
% mcamon_callback function for SAXSimageviewer2.m
% startmonitor in the m file calls this function.
    a = evalin('base', 's12DET');
    try
        b = evalin('base', 'MCA_crt_file');
    catch
        b = [];
    end
    if isfield(b, 'oldFN')
        oldFN = b.oldFN;
    else
        oldFN = 0;
    end
    if isfield(b, 'oldFilename')
        oldFilename = b.oldFilename;
    else
        oldFilename = '';
    end

    %a = get(a, 'SeqNumber');
    [val, NI] = mcacache(a.SeqNumber{2}, a.ArrayNumber{2});
    a = get(a, 'FullFileName');

    isshow = 0;

    if (NI >= 1)
        isshow = 1;
    else
        if (oldFN ~= val)
            isshow = 1;
        end
    end
    FileName = a.FullFileName{4};
    [~, FileName] = fileparts(FileName);
    if isshow
        if (~strcmp(FileName, oldFilename))
            dtstr = datestr(now);
            fprintf('The image of fileindex %d, %s, is just taken at %s\n', val, FileName, dtstr);
        else
            return
        end
        
        %% DATA averaging or other jobs to do.
        epics_put_SAXSinfo
%        a = get(a, 'ImageData');
%        img = a.ImageData{4};

        
%         if strcmp(get(han.ToggleLogLin, 'state'), 'on')
%             img = log10(abs(double(img)+eps));
%         end
%         han2 = guidata(t);
%         set(han2.iH, 'Cdata', img);
%         guidata(SAXSimageviewerhandle, han2);

%% Update data information.
        b.oldFN = val;
        b.oldFilename = FileName;
        b.Date = dtstr;
        assignin('base', 'MCA_crt_file', b);
    end
