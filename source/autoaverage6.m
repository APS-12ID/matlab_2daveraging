function autoaverage6(datadir, datafilen, savefilen, logfilen)
        %setupfile = fullfile(datadir, 'setup.mat');
        %setupinfo = load(setupfile);
        [phd, ic1, eng]=parseMetafile(logfilen);
        [phd, ic1, eng]
        % phd = 1.0;
        %eng0=eng;
        sImg=imgUpsideDn(double(imread(datafilen)));
        try
        if strcmpi(datadir(end-3:end), 'saxs')
            saxs = evalin('base', 'saxs');
            eng0=saxs.eng;
            data = circavgnew2(sImg, saxs.mask, saxs.qCMap, saxs.qRMap, saxs.qArray, saxs.offset, saxs.limits);
        else
            waxs = evalin('base', 'waxs');
            eng0=waxs.eng;	
            data = circavgnew2(sImg, waxs.mask, waxs.qCMap, waxs.qRMap, waxs.qArray, waxs.offset, waxs.limits);
        end
        %dataNorm=[data(:,1) data(:,2:3)/phd data(:,4:end)];
        if eng>0
            dataNorm=[data(:,1)*eng/eng0  data(:,2:3)/phd data(:,4:end)];
        else
          dataNorm=[data(:,1) data(:,2:3)/phd data(:,4:end)];
        end
        dlmwrite(savefilen,dataNorm,'delimiter','\t','precision','%.6f');
        catch
            
        end
 end