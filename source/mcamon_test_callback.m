function mcamon_test_callback(varargin)

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
        if isfield(b, 'oldEN')
            oldEN = b.oldEN;
        else
            oldEN = 0;
        end

        %a = get(a, 'SeqNumber');
        [val, NI] = mcacache(a.SeqNumber{2}, a.ArrayNumber{2});

        %try
        %    t = evalin('base', 'SAXSimageviewerhandle');
        isshow = 0;

        if (oldEN > 1)
    %        if (oldFN ~= val)
                isshow = 1;
    %        end
        else
            if (oldFN ~= val)
                isshow = 1;
            end
        end

        if isshow
            if (NI >= 1)
                dtstr = datestr(now);
                fprintf('The image of fileindex %d and extension %d is taken at %s\n', val, NI, dtstr);
            %    assignin('base', 's12DET', a);
            else
                fprintf('Taking new image...\n')
                return
            end
            a = get(a, 'ImageData');
            SAXSimageviewer2(a.ImageData{4});
            b.oldFN = val;
            b.oldEN = NI;
            b.Date = dtstr;
            assignin('base', 'MCA_crt_file', b);
        end
end
%     
%     a = evalin('base', 's12DET');
%     %a = get(a, 'SeqNumber');
%     [val, NI] = mcacache(a.SeqNumber{2}, a.ArrayNumber{2});
% %    a = a.get('AcquirePOLL');
% if (NI >= 1)
%     fprintf('The number %d and %d is taken at %s\n', val, NI, datestr(now));
% %    assignin('base', 's12DET', a);
% else
%     fprintf('Taking new image...\n')
% end
%     %try
%     %    t = evalin('base', 'SAXSimageviewerhandle');
%     a = get(a, 'ImageData');
% %    SAXSimageviewer(flipud(a.ImageData{4}'));
%     SAXSimageviewer(a.ImageData{4});
% end
        
        