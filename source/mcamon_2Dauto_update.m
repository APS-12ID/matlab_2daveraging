function mcamon_2Dauto_update(varargin)
% mcamon_callback function for SAXSimageviewer2.m
% startmonitor in the m file calls this function.
    a = evalin('base', 's12DET');
    [a, updated] = check_status(a);
    if updated == 1
        assigin('base', 's12DET', a);
    end
    a = get(a);
    val = max(a.ImageData{4}, [], 'all');
    if val < 1 % if data is not read from PV..
        ff = strsplit(a.FilePath{4}, '/');
        [~, filebodyname, ext] = fileparts(a.FullFileName{4});
        if numel(ff) > 3 % data is stored on s12data
            exist(a.FullFileName{4}, 'file')
            [~, img] = openccdfile(a.FullFileName{4}, [], deblank(ext(2:end)));
            %a.ImageData{4} = img;
        else
            switch lower(a.PV_PREFIX)
                case 's12-pilatus:'
                    dirname = 'SAXS/';
                case 'pilatus300k:'
                    dirname = 'WAXS/';
            end
            fid=fopen('fgetl.m');
            tline = fgetl(fid);
            fclose(fid);
            x = strfind(tline, '/');
            filename = [tline(1:x(end)), dirname, filebodyname, ext];
            [~, img] = openccdfile(filename, [], ext(2:end));
            %a.ImageData{4} = img;
        end
        img = flipud(img);
    else
        img = a.ImageData{4};
    end
    
%    a.FullFileName{4}
%    disp('1')
%     switch a.ArrayNumber{4}
%         case 0
%             
%         case 1
%             %if a.AcquirePOLL{4} ~= 0
%                 a.PRV_FileName = deblank(a.FullFileName{4});
%                 assignin('base', 's12DET', a);
%                 return
%             %end
%         otherwise
%     end
%    disp('2')
    if ~isprop(a, 'PRV_FileName')
        a.PRV_FileName = '';
    end
%    evalin('base', '
    if ~isprop(a, 'PRV_TimeStamp')
        a.PRV_TimeStamp = 0;
    end
    
%     fprintf('prv: %f, new: %f\n', a.PRV_TimeStamp, a.TIMESTAMP{4});
%     if strcmp(deblank(a.PRV_FileName), deblank(a.FullFileName{4}))
%         if ~contains_replace(a.FullFileName{4}, 'alignment')
%             return
%         end
%     end
    
%    if a.AcquirePOLL{4} ~= 0
%        FileName = a.PRV_FileName;
%    else
        FileName = a.FullFileName{4};
%    end
%    disp('aaaa')
    a.PRV_FileName = FileName;
    a.PRV_TimeStamp = a.TIMESTAMP{4};
    assignin('base', 's12DET', a);
    isshow = 1;

    imgVh = evalin('base', 'SAXSimageviewerhandle');
    imgGUI = guidata(imgVh);
   % g = guidata(t);
    ToggleLogLin = imgGUI.ToggleLogLin;
    ImageAxes = imgGUI.ImageAxes;
    FileListBox = imgGUI.FileListBox;
    udf = getappdata(imgVh, 'tmpdata');
    ud = get(imgVh, 'userdata');
    oldFilename = ud.imgname;
    [~, FileName, ext] = fileparts(FileName);
    if isshow 
        % Is new image?
        if isempty(oldFilename)
            oldFilename = 'junk';
        end
        if (~strcmp(FileName, oldFilename))
            dtstr = datestr(now);
            fprintf('%s was taken at %s.\n', FileName, dtstr);
        else
            if a.TriggerMode < 5  % if not alignment mode
                return
            end
        end
        % if so, read the image
%        a = get(a, 'ImageData');
%        isemptyimg = 0;
        
        dims = a.ImageDims{4}(1:2);
%        img = img(dims(1)+1:end, 1:dims(2));
%        img = reshape(img, dims);
%        assignin('base', 's12DET', a)
        if isempty(img)
            disp('Image is empty')
%            isemptyimg = 1;
        end
%         %% Analyze the image
%         % How many pixel is saturated?
%         t = double(img)/a.ExposureTime{4} > a.SATURATION;
%         fprintf('Number of saturated pixel(s) are %d.\n', numel(t));
        % Display the image
        
        try
            %g.ImX = img;
%            if strcmp(get(g.ToggleLogLin, 'state'), 'on')
            if strcmp(get(ToggleLogLin, 'state'), 'on')
                img = log10(abs(double(img)+eps));
            end
%            iH = findobj(g.ImageAxes, 'tag', 'SAXSimageviewerImage');
            iH = findobj(ImageAxes, 'tag', 'SAXSimageviewerImage');
            iH.CData = img;
            ud.image = img;
            ud.imgname = FileName;
        catch
            disp('There is an error in showing image. Stop autoupdating and restart SAXSimageviewer.');
        end
        
%        set(get(g.ImageAxes, 'title'), ...
        set(get(ImageAxes, 'title'), ...
            'string'      , sprintf('%s', FileName), ...
            'interpreter' , 'none');        
        
        drawnow
%         setappdata(t, 'tmpdata', udf);
%         set(t, 'userdata', ud);

        if contains_replace(a.FullFileName{4}, 'alignment')
            return
        end

                % 1D Averaged Update
        f = findobj('tag', 'AvgDataPlot');
        if ~isempty(f)
            switch a.PV_PREFIX
                case 'S12-PILATUS1:'
                    DET = 'pilatus2m';
                    
                case '12idbEGR:'
                    DET = 'eiger9m';
%                     mydir = [udf.lastDir, filesep, 'Averaged'];
%                     mydirW = strrep(mydir, [filesep, 'SAXS', filesep], [filesep, 'WAXS', filesep]);
%                     fname{1} = fullfile(mydir, filesep, FileName, '.dat');
%                     fname{2} = fullfile(mydirW, filesep, FileName(2:end), '.dat');
                case 's12_mar300:'
%                     fname{1} = fullfile(udf.lastDir, [filesep, 'Averaged'], filesep, FileName, '.dat');
                    DET = 'mar300';
                case '12idbPE:'
%                     fname{1} = fullfile(udf.lastDir, [filesep, 'Averaged'], filesep, FileName, '.dat');
                    DET = 'PE';
            end
        end
        imginfo.image = img;
        imginfo.Xlim = ImageAxes.XLim;
        imginfo.Ylim = ImageAxes.YLim;
        imginfo.Clim = ImageAxes.CLim;
        [filepath, specfilename] = APSgetcurrentspecfolder;
        mcamon_1Dauto_update(f, DET, filepath, FileName, imginfo);
        % Update SAXSimageviwer
        if ~strcmp(udf.filesort, 'date')
            return
        end
        filefilterstr = udf.filefilter;
%        isupdate = 1;
        if ~isempty(filefilterstr)
            if ~contains_replace(filefilterstr, '*')
%                isupdate = 0;
                return
            end
        end
        
        % update.   
%        if strcmp(dirn, g.lastDir)
        if ~isempty(strfind(udf.lastDir, [filesep, 'SAXS'])) 
            FN = [FileName, ext];
%            crtstr = g.FileListBox.String;
            crtstr = FileListBox.String;
            crtstr = [FN; crtstr];
%            g.FileListBox.String = crtstr;
%            g.FileListBox.Value = 1;
            FileListBox.String = crtstr;
            FileListBox.Value = 1;
        end
        drawnow
        
    end

end

function [det, updated] = check_status(det)
    updated = 0;
    fn = fieldnames(det);
    for i=1:numel(fn)
        if iscell(det.(fn{i}))
            if numel(det.(fn{i})) == 4
                if isempty(det.(fn{i}){2})
                    det = connect(det);
                    updated = 1;
                end
                break
            end
        end
    end
end