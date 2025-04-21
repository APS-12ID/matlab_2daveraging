function [phd, ic1, eng, expt]=parseAvgfile(fileName)
%
fid=fopen(fileName);

if(fid ~= -1)
    try
        while feof(fid)==0
            line=fgetl(fid);
            [token, remain] = strtok(line, ':');
            token(token == '%') = '';
            token = strtrim(token);
            remain = str2double(remain(2:end));
            if isempty(token)
                break
            end
            switch lower(token)
                case {'ic', 'i0 of sample'}
                    ic1 = remain;
                case {'phd', 'photodiode value'}
                    phd = remain;
                case {'energy', 'x-ray energy (kev)'}
                    eng = remain;
                case {'exposuretime', 'exposure time (s)'}
                    expt = remain;
            end
        end 

    catch
        phd = 1;
        ic1 = 1;
        eng = 14;
        expt = 1;
    end	

    fclose(fid);

else
    phd = 1.;
    ic1 = 1.;
    eng = -1.;
    expt = 1;
end  
