function varargout = APS_ch2currentfolder(varargin)
% [specfilename, filepath] = APS_ch2currentfolder(specfilename_in_fullpath)
% When no output is assigned, it moves to the current directory.
% Also, when both outputs are assigned, it moves to the current directory.
% When only specfilename is requested, it does not change the directory.
if numel(varargin) >0
    [filepath, specfilename] = APSgetcurrentspecfolder(varargin{1});
else
    [filepath, specfilename] = APSgetcurrentspecfolder;
end
%filename = [filen,filee];
crdir = pwd;
if nargout>0
    varargout{1} = specfilename;
    varargout{2} = filepath;
end
if ((nargout==0) || (nargout==2))
    if ~strcmp(crdir, filepath)
        eval('base', sprintf('cd %s', filepath));
        disp(sprintf('User Directory is changed to: %s', filepath))
    end
end

