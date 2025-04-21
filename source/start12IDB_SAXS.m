% Move to user's directory
if isunix
    currentspec12ID = '~/.currentspecdatafile';
    fid = fopen(currentspec12ID);
    if fid < 0
        error('~/.currentspecdatafile is not existing')
        return
    end
    while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            break
        else
            specfilename = tline;
        end
    end
    fclose(fid);

    [filepath,name,ext] = fileparts(specfilename);
    cd(filepath)
else
    
end

% start programs
SAXSimageviewer
gisaxsleenew
SAXSLee
specr