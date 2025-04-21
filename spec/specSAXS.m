function data = specSAXS(specfilename, datafilename)
%
%function [data, datastr, com, head]=specdata(file, scan)
%
% This function enables to load SPEC scan data
%
% MZ 8.3.95
% DFM 30.9.95
% EF 4.9.97

%---- Read through data file to find right scan number (uses ffind mex file)




fpos=ffind(specfilename,['#Z ' datafilename]);
if fpos<0
   errordlg(['Scan ' datafilename ' not found'],'Spec data load error:')
   return
end

fid=fopen(specfilename);
fseek(fid,fpos,'bof');
com=fgets(fid);                   % This line contains the scan command issued
fclose(fid);

%t='zz';
%while strcmp(t,['#Z']) == 0
%   r=fgetl(fid);
%   if (length(r) > 1) t=r(1:2); end
%end
%head=[' ' r(4:max(size(r))) ' '];
head = com;
K=findstr(head,' ');
%datastr=[];
data = [];
tt = 1;
for i=1:length(K)-1
   %datastr=strvcat(datastr, fliplr(deblank(fliplr(deblank(head(1,K(i)+1:K(i+1)-1))))));
   a = fliplr(deblank(fliplr(deblank(head(1,K(i)+1:K(i+1)-1)))));
   if ~isempty(a)
    %datastr{i}=fliplr(deblank(fliplr(deblank(head(1,K(i)+1:K(i+1)-1)))));
    data(tt) = str2double(a); 
    tt = tt+1;
   end
end