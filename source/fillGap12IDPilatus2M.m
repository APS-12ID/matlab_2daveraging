function fillGap12IDPilatus2M(dir, filename2fillgap)
% fillGap of 12ID Pilatus2M data measured by fillGap2 or fillGap3 spec
% command.
% Byeongdu Lee
[~, ~, ext] = fileparts(filename2fillgap);
posof_ = strfind(filename2fillgap, '_');
if numel(posof_) < 2
    posof_ = length(filename2fillgap);
else
    posof_ = posof_(end)-1;
end
%try
%    msk = imread(fullfile(dir, filesep, 'SAXSmask.bmp'));
%catch
ismaskloaded = false;
    try
        msk = imread(fullfile(dir, filesep, 'SAXS', filesep, 'goodpix_mask.tif'));
        ismaskloaded = true;
    end
    try
        if ~ismaskloaded
            msk = imread(fullfile(dir, filesep, 'SAXS', filesep, 'goodpix_mask.bmp'));
            ismaskloaded = true;
        end
    end
if ~ismaskloaded 
    fprintf("Mask is not loaded for fillgap.\")
    return
end
%end
msk = double(msk);
[X, Y] = meshgrid(1:size(msk,2), 1:size(msk, 1));
mskn = msk;
for i=1:4
    fn = sprintf('%s_%0.5d%s', filename2fillgap(1:posof_(end)), i, ext);
    fullfname = fullfile(dir, filesep, 'SAXS', filesep, fn);
    if exist(fullfname, 'file')
        saxs = SAXSimageviwerLoadimage(fullfname);
        %img = double(imread(fullfname));
        img = saxs.image;
    else
        continue 
    end
    
    switch i
        case 1
            img0 = img;
            continue
        case 2
            if size(img, 1) == 3262 % Eiger detector
                Yhv = Y - 27.5*2;
                Xhv = X - 45;
            else
                Xhv = X - 10*2;
                Yhv = Y + 24;
            end
        case 3
            if size(img, 1) == 3262 % Eiger detector
                Xhv = X - 27.5;
                Yhv = Y - 45;
            else
                Xhv = X - 10;
                Yhv = Y + 24;
            end
        case 4
            if size(img, 1) == 3262 % Eiger detector
                Xhv = X - 27.5;
                Yhv = Y;
            else
                Xhv = X - 10;
                Yhv = Y;
            end
    end

    tmsk = mskn < 1;
    Vq = interp2(Xhv,Yhv,img,X(tmsk),Y(tmsk));
    tq = interp2(Xhv,Yhv,double(msk),X(tmsk),Y(tmsk));
    img0(tmsk) = Vq;
    mskn(tmsk) = tq;
end
fn = sprintf('%s_%0.5d%s', filename2fillgap(1:posof_(end)), 0, ext);
savefilename = fullfile(dir, filesep, 'SAXS', filesep, fn);
if exist(savefilename, 'file')
    delete(savefilename)
end
%try
    switch ext
        case {'.tif', '.tiff'}
            imwritetiff(img0, savefilename, 32)
        case '.h5'
            img0 = flipud(img0)';
            entry = '/entry/data/data';
            h5create(savefilename, entry, size(img0));
            h5write(savefilename, entry, img0);
                %'Datatype','single', 'ChunkSize', [233   222],...
                %'start', 1.0)
    end
    fprintf('Stitched image is saved as %s.\n', fn);
%catch
%end