clc
% close all
clear all
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');

disp(' ');
disp('  **********  K-SVD Denoising  **********');
disp(' ');
disp('  The dictionary is trained using patches from the corrupted image. ');
disp('  using K-SVD denoising. The function displays the noisy, and denoised');
disp('  images, and shows the resulting trained dictionary.');
disp(' ');

addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
addpath('E:\THESIS\Implements\Pedagogical');
%% prompt user for image %%
% there is no clean image for each noisy one.
pth='E:\DTSET\Fang2013\For synthetic experiments\3';
imnoise=[];
imnoise(:,:,1)=double(imread(fullfile(pth,'test.tif')));
imnoise(:,:,2)=double(imread(fullfile(pth,'1.tif')));
imnoise(:,:,3)=double(imread(fullfile(pth,'2.tif')));
imnoise(:,:,4)=double(imread(fullfile(pth,'3.tif')));
imnoise(:,:,5)=double(imread(fullfile(pth,'4.tif')));

sigma = 25;
%% set parameters %%

params.x = imnoise;
params.blocksize = [8 8];%%
params.dictsize = 256;
params.sigma = sigma;
params.maxval = 255;
params.trainnum = 40000;
params.iternum = 20;
params.memusage = 'high';
% the following code produced a dictionary for data of dimension 512=8*64
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
% params.initdict = abs(WavMat3DCpxDual(Faf,af, params.blocksize))';
% params.initdict = imag(WavMat3DCpxDual(Faf,af, params.blocksize))';
params.initdict = real(WavMat3DCpxDual(Faf,af, params.blocksize(1)))';

params.initdict=params.initdict(1:5*64,:);
% DCT = odctndict(params.blocksize,params.dictsize,ndims(params.x));

% denoise!
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise_3(params);



% show results %
% dictimg = showdict(params.initdict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
% figure; imshow(imresize(dictimg,2,'nearest'));
% title('initial dictionary');

number_of_slice_dictionary = 1;
dict_slice = dict((params.blocksize.^2)*(number_of_slice_dictionary-1)+1:(params.blocksize.^2)*(number_of_slice_dictionary),:);
dictimg = showdict(dict_slice,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imagesc(imresize(dictimg,2,'nearest'));colormap gray
title('Trained dictionary');

% figure; imshow(im/params.maxval);
% title('Original image');
%%
im_num = 1;
imnoise2 = imrotate(imnoise(:,:,im_num),0);
figure; imagesc(imnoise2/params.maxval); colormap gray
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));

imout2 = imrotate(imout(:,:,im_num),0);
figure; imagesc(imout2/params.maxval); colormap gray
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));
