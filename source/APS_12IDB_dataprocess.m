function APS_12IDB_dataprocess(specfile, fileindex)
% Load saxssetup.mat and waxssetup.mat
isstr = 0;
if ~isnumeric(fileindex)
    if ~iscell(fileindex) == 1
        fi_input{1} = fileindex;
    else
        fi_input = fileindex;
    end
    isstr = 1;
else
    fi_input = fileindex;
end
for k = 1:numel(fi_input)
    if isstr
        fi = fi_input{k};
    else
        fi = fi_input(k);
    end
    try
        a = specSAXSn2(specfile, fi);
    catch
        continue
    end
    if isempty(a)
        continue
    end
    for i=1:numel(a.Filename)
        fn = a.Filename{i};
        ret = APS_12IDBfiletransfer(fn, pwd);
        if ~isempty(ret)  
            fprintf('%s is transferred.\n', ret);
        else
            fprintf('The file name is not found.\n');
        end
        avgfile(specfile, fn);
    end
end