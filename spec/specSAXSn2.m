function [count, filen]=specSAXSn2(specfilename, fileindex_str, flag)
% [count, filen]=specSAXSn2(specfilename, fileindex_str, flag)
% flag = 1; if the first string found, return;
% any other flag; find all possible strings..
%
% Usage : 
% When CCD filename format ex : rw061006a.00120.001
%
% specSAXSn2('specdata', 'rw061006a') : 
% specSAXSn2('specdata', 'rw061006a', 1) 
% specSAXSn2('specdata', 'rw061006a*00001*', 0) : find all strings that including
% 'rw061006a'
%
% When datafile contains LogItems and LogItemsFormat, which are
% automatically included at 12IDB, the output count will be a structure
% containing all those LogItems as fieldnames. This works only with a
% system offers grep command 1/8/2014
% 
% Look for specSAXSn2_old.m for the previous version.
%
% Byeongdu Lee 
% Jan 26, 2014
% Feb 25, 2009
% BESSRC/APS

%-----Read data -------------------------------------------
count = [];
filen = [];
if nargin < 3
    flag = 1;
end



%#B 12IDB
%#FilenameFormat _%3.3d_%3.3d.tif
%#LogItems  Set_exposuretime Exposuretime Energy IC BS Count3 th sth Temperature Date Time
%#LogItemsFormat  %0.4f %0.4f %0.4f %f %f %f %0.3f %0.3f %0.3f %s %s
%str = sprintf('grep #LogItems %s', specfilename);
lpos_FNF = ffind(specfilename, 'FilenameFormat');
lpos_Items = ffind(specfilename, '#LogItems ');
lpos_ItemsFM = ffind(specfilename, '#LogItemsFormat ');
if ~isempty(lpos_Items)
    fid = fopen(specfilename);
    fseek(fid, lpos_FNF,'bof');
    FNF = fgetl(fid);
    FNF = FNF(1:8);
    fseek(fid, lpos_Items,'bof');
    Items = fgetl(fid);
    fseek(fid, lpos_ItemsFM,'bof');
    ItemsFM = fgetl(fid);
    m = isstrprop(ItemsFM, 'digit');
    ItemsFM(m) = [];
    ItemsFM(find(ItemsFM=='.')) = [];
    fclose(fid);
    k = textscan(Items, '%s');Items = k{1};
    pos_Date = findcellstr(Items, 'Date');
    k = find(ItemsFM == '%');
    %ItemsFM = [ItemsFM(1:k(pos_Date)+2), '%s %s %s %s ', ItemsFM(k(pos_Date+1):end)];
    ItemsFM = [ItemsFM(1:k(pos_Date)), '24c ', ItemsFM(k(pos_Date+1):end)];
    pos_Time = findcellstr(Items, 'Time');
    k = find(ItemsFM == '%');
    ItemsFM(k(pos_Time)+1) = 'f';
else
    Items = [];
    ItemsFM = [];
end
if nargin < 2
    count = Items;
    return
end


%fid = fopen(specfilename, 'r');
% when fileindex_str contains * (wild cards)
% 
if ~isnumeric(fileindex_str)
    wcard = strfind(fileindex_str, '*');
else
    wcard = 0;
end

if ~isempty(wcard)
    if wcard(1) == 1
        fileindex_str(1) = [];
        wcard = strfind(fileindex_str, '*');
    end
end

specfilenameBlanktreated = pathwithspace(specfilename);

if ispc
    cmd0 = 'findstr Z.*%s';
else
    cmd0 = 'grep Z.*%s';
end

if isnumeric(fileindex_str);
    if (numel(fileindex_str)==1)
        fileindex_str = sprintf(FNF, fileindex_str);
    else
        filen = {};
        count = {};
        for i=1:numel(fileindex_str)
            fi = fileindex_str(i);
            [ct, fn]=specSAXSn2(specfilename, fi, 1);
            count{i} = ct;
            filen{i} = fn;
        end
        return
    end
end
fileindex_str = strtrim(fileindex_str);

if isempty(wcard)
    cmd = sprintf(cmd0, fileindex_str);
    str = sprintf('%s %s', cmd, specfilenameBlanktreated);
else

    %str = sprintf('grep Z.*%s %s', fileindex_str(1:(wcard(1)-1)), specfilenameBlanktreated);
    cmd = sprintf(cmd0, fileindex_str(1:(wcard(1)-1)));
    str = sprintf('%s %s', cmd, specfilenameBlanktreated);
    if wcard(end) ~= length(fileindex_str)
        wcard(end+1) = length(fileindex_str) + 1;
    end
    for i=2:1:numel(wcard)
        %str = sprintf('%s | grep Z.*%s', str, fileindex_str((wcard(i-1)+1):(wcard(i)-1)));
        cmd = sprintf(cmd0, fileindex_str((wcard(i-1)+1):(wcard(i)-1)));
        str = sprintf('%s | %s', str, cmd);
    end
end

method = 1;
[s, w] = system(str);
if s==1
    method = 2;
        if flag == 1
            flag = 0;
        else
            flag = 1;
        end
        strtofind = '';
        if isempty(wcard)
            strtofind = fileindex_str;
        else
            if numel(wcard) == 1
                fileindex_str(wcard) = [];
                strtofind = fileindex_str;
            end
        end
        
        if ~isempty(strtofind)
            lpos = ffind(specfilename, fileindex_str, flag)-length(fileindex_str);
        else
            wcard = [0,wcard];
            aa = {};
            for i=1:numel(wcard)-1
                strtofind = fileindex_str(wcard(i)+1:wcard(i+1)-1);
                aa{i} = ffind(specfilename, strtofind, flag)-length(strtofind);
            end
            n = numel(aa);
            while (n>1)
                for i=1:n
                    aa{i} = intersect(aa{i}, aa{i+1});
                end
                n = n-1;
            end
            lpos = aa{1};
        end
        fid = fopen(specfilename);
%        w = '';
        w = [];
        for i=1:numel(lpos)
            off = 0;
            while (1) 
                fseek(fid, lpos(i)-off,'bof');
                wtemp = fgets(fid);
                if strcmp(wtemp(1), '#')
                    break
                end
                off = off + 1;
            end
            %w{i} = fgetl(fid);
            %w = [w, fgets(fid)];
            w = [w, wtemp];
%            w{i} = sprintf('%s%s\n', w, fgetl(fid));
        end
        fclose(fid);    
else
    % When there is an error message string from Cygwin in the variable w
    pos_cygwinErr = strfind(w, '#Z');
    if pos_cygwinErr > 1
        w(1:pos_cygwinErr-1) = [];
    end
end

if isempty(ItemsFM)
    ItemsFM = '%f %f %f %f %f %f %f %f %f';
end
switch method
    case 1
        % new method: 1/8/2014
        t = textscan(w, ['#Z %s ', ItemsFM]);
        %filen = t{1};
        
        % old method
        %t = find(w == char(10));
        %for i=1:numel(t);
        %    if i==1
        %        idx = 1:t(i);
        %    else
        %        idx = (t(i-1)+1):t(i);
        %    end
        %    L = w(idx);
        %    if L <0;
        %        break;
        %    else
        %        seen = 1;
        %        if ~isempty(seen)
        %            [file, num] = sscanf(L, '#Z %s', 1);
        %            if ~isempty(file)
        %                strtmp = ['#Z ', file];
        %                strtmp = [strtmp, ' %f %f %f %f %f %f %f %f %f %f'];
        %                [c] = sscanf(L, strtmp, 20)';
        %                count = [count;c];
        %                filen{i} = file;
        %                if flag == 1
        %                    break;
        %                end
        %            end
        %        end
        %    end
        %end
    case 2
        %t = textscan(w, ['%s ', ItemsFM]);
        t = textscan(w, ['#Z %s ', ItemsFM]);
%        for i=1:numel(lpos)
%            [fn,numstr] = strtok(w{i}, ' ');
%            filen = [filen;fn];
%            num = sscanf(numstr, '%f')';
%            count = [count;num];
%        end
end
if ~isempty(Items)
    Items = {'Filename', Items{:}};
    count = cell2struct(t, Items, 2);
else
    count = t;
end
    
end

%fclose(fid);
