%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 

file1 = 'img1.tif';
file2 = 'img2.tif';

img1 = imread(file1);
img2 = imread(file2);

% Method 1 - Iterate over all overlaps
diffs = zeros(300);
for row = 50:350

    for col = 50:350
        % Get overlapping pixels
        pix1 = img1((end-row):end,(end-col):end);
        pix2 = img2(1:(1+row), 1:(1+col));
        
        % Store relative difference
        diffs(row - 49, col - 49) = sum(sum(abs(pix1 - pix2)))/(row*col);
    end
    
end

% Align images
[row_over, col_over] = find(diffs == min(diffs(:)));
row_over = row_over + 49;
col_over = col_over + 49;
img2_align = [zeros(size(img2,1), size(img2,2) - col_over), img2];
img2_align = [zeros(size(img1,1) - row_over, size(img2_align,2)); img2_align];
imshowpair(img1, img2_align)

% Method 2 - Fourier transform
img1ft = fft2(img1);
img2ft = fft2(img2);
[nrow, ncol] = size(img2ft);
comconj = ifft2(img1ft.*conj(img2ft));
CCabs = abs(comconj);

% Adjust image
[row_shift, col_shift] = find(CCabs == max(max(CCabs)));
Nrow = ifftshift(-fix(nrow/2):ceil(nrow/2)-1);
Ncol = ifftshift(-fix(ncol/2):ceil(ncol/2)-1);
row_shift = Nrow(row_shift);
col_shift = Ncol(col_shift);

imshift = [zeros(size(img2,1), size(img2,2) - col_shift), img2];
imshift = [zeros(size(img1,1) - row_shift, size(imshift,2)); imshift];
figure
imshowpair(img1, imshift)
