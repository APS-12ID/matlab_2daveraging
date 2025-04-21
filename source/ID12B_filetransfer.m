function ID12B_filetransfer(mfilen)
% ID12B_filetransfer(metafilename)
%
sDir = ID12B_headerread(mfilen, 'Original Location of SAXS data');
wDir = ID12B_headerread(mfilen, 'Original Location of WAXS data');

[~, fnn, ~] = fileparts(mfilen);
sfn = sprintf('S%s.tif', fnn(2:end));
wfn = sprintf('W%s.tif', fnn(2:end));
%sfn = ID12B_headerread(mfilen, '2D image name for SAXS');
%wfn = ID12B_headerread(mfilen, '2D image name for SAXS');
dDir = ID12B_headerread(mfilen, 'Data Directory');

Ntrial = 1;
timeout = 20;
while(Ntrial < timeout)
    %sprintf('scp %s%s%s %s%sSAXS', sDir, filesep, sfn, dDir, filesep)
    sT = system(sprintf('scp %s%s%s %s%sSAXS', sDir, filesep, sfn, dDir, filesep));
    %sprintf('scp %s%s%s %s%sWAXS', wDir, filesep, wfn, dDir, filesep)
    wT = system(sprintf('scp %s%s%s %s%sWAXS', wDir, filesep, wfn, dDir, filesep));
    if ((sT == 0) && (wT == 0))
        timeout = 0 ;
        break
    end
    pause(0.5);
    Ntrial = Ntrial + 1;
end

if (timeout == 20)
    if (sT == 1)
        fprintf('SAXS data %s is not transferred', sfn);
    end
    if (wT == 1)
        fprintf('WAXS data %s is not transferred', wfn);
    end    
end