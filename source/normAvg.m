function normAvg(cdir, fileName, serial, totImg)
%
%autoaverage6(datadir, datafilen, savefilen, logfilen)
k =1;
%saxs = evalin('base', 'saxs');
while k <= totImg
    if k<10
        datafilen = [cdir, '\SAXS\Averaged\','S',fileName, '_', serial, '_00',num2str(k), '.dat'];
        savefilen = [cdir, '\SAXS\Averaged2\','S',fileName, '_', serial, '_00',num2str(k), '.dat']
        logfilen  = [cdir, '\Log\','L',fileName, '_', serial, '_00',num2str(k), '.meta'];
    elseif k<100
        datafilen = [cdir, '\SAXS\Averaged\','S',fileName, '_', serial, '_0',num2str(k), '.dat'];
        savefilen = [cdir, '\SAXS\Averaged2\','S',fileName, '_', serial, '_0',num2str(k), '.dat']
        logfilen  = [cdir, '\Log\','L',fileName, '_', serial, '_0',num2str(k), '.meta'];
    elseif k<1000
        datafilen = [cdir, '\SAXS\Averaged\','S',fileName, '_', serial, '_',num2str(k), '.dat'];
        savefilen = [cdir, '\SAXS\Averaged2\','S',fileName, '_', serial, '_',num2str(k), '.dat']
        logfilen  = [cdir, '\Log\','L',fileName, '_', serial, '_',num2str(k), '.meta'];
    else
        print 'exceed the maximium number!'
    end
    
    %fullDatafilen = [cdir, '\', datafilen];
    %fullLogfilen  = [cdir]
    
    [phd, ic1, eng]=parseMetafile(logfilen);
    
    %eng0 = saxs.eng;
eng0 = 14;
    data=dlmread(datafilen);
    
    if eng>0
        dataNorm=[data(:,1)*eng/eng0 data(:,2:3)/phd data(:,4:end)];
    else
      dataNorm=[data(:,1) data(:,2:3)/phd data(:,4:end)];
    end
    %savefilen=datafilen;
    dlmwrite(savefilen,dataNorm,'delimiter','\t','precision','%.6f');
    k=k+1;
end    
