function [string_pos, strline] = ffind(filename,string, extractallflag)
% [string_pos] = ffind(filename,string)
% It returns a pointer on the 'string' token in file 'filename'.
% An optional third parameter enables scanning of all 'string' positions.
% The matlab function fseek can then be used.
% input : filename and string to search
% output: found string position(s).
%
% Note: this ffind.m routine is used when the ffind.mex file does not exist 

if (nargin < 3)
  extractall = 0;
  extractallflag = 0;
else
  extractall = 1;
end

% get already opened files
%fids = fopen('all');
string_pos = [];

% open the file
[fid,message] = fopen(filename,'r');
if (fid<0)
   fprintf(1,'ffind: ERROR on %s open: %s\n', filename, message);
   return;
end

filebuffersize = 1024*500;	% 500 ko buffer search
stopflag = 0;

% get the file contents
strline = '';

while (stopflag == 0)

  filepos = ftell(fid);
  [filestr, counts] = fread (fid,filebuffersize);
  if (counts < filebuffersize) 
  	  stopflag = 1;	% reach eof
  end
  filestr=char(filestr');

  string_pos_loc = strfind(filestr, string);
  
  if ~isempty(string_pos_loc)
    if ~extractallflag
      string_pos_loc = string_pos_loc(1);
      stopflag = 1;
    end
    string_pos = [ string_pos (string_pos_loc+filepos+length(string)-1) ];
    positionofCL = find(filestr == char(10));
    str_pos = string_pos_loc+length(string)-1;

    if numel(str_pos) > 1
        for i=1:numel(str_pos)
            pCL1 = min(positionofCL(positionofCL>str_pos(i)));
            pCL0 = max(positionofCL(positionofCL<str_pos(i)));
            strline = [strline, filestr(pCL0+1:pCL1)];
        end
        continue
    end
            
    pCL1 = min(positionofCL(positionofCL>string_pos));
    pCL0 = max(positionofCL(positionofCL<string_pos));
    strline = filestr(pCL0+1:pCL1);
  end
 end


%if (~isempty(fids) & isempty(find(fids == fid)))
%if (~isempty(fids) && isempty(find(fids == fid, 1)))
	fclose(fid);
%else
%	fseek(fid,0,-1);
%end

if isempty(string_pos)
	return;
end