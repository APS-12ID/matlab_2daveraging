function imagesum(filename)
% sum selected 2D images and save as a tiff
% imagesum('*testdata_001_*.tif')
% the filename for the saved file will be the common part of the input
% filenames.
% Byeongdu Lee
% 3/1/2013

fn = dir(filename);
i=1;
while strncmp(fn(1).name, fn(2).name, i);
    i = i+1;
end
if i>0
    filncm = i-1;
end

for i=1:numel(fn);
    a = double(imread(fn(i).name));
    if i>1
        b = b + a;
    else
        b = a;
    end
end
filename = [fn(1).name(1:filncm), '.tif'];
imwritetiff(b, filename, 32)
    