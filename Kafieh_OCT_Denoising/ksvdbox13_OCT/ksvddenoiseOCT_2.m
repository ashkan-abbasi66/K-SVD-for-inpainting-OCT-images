% Test algorithm on Fang's image (Bioptigen SDOCT system (Durham,NC,USA))
%   The dictionary is trained using patches from the corrupted image
%  	using K-SVD denoising. The function displays the noisy, and denoised
%   images, and shows the resulting trained dictionary.
clc
clear all
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
addpath('E:\DTSET\Fang2013\Test');
addpath('E:\THESIS\Implements\Pedagogical');
%% prompt user for image %%
im=double(imread('average.tif'));% clean image
imnoise=double(imread('test.tif'));% noisy image
% sigma =  15; % noise std 
% sigma=sqrt(evar(imnoise));
sigma=23;%23
%
% imnoise=log(double(imread('test.tif')));% noisy image
% sigma=0.00002;
%% set parameters %%
time=cputime;
params.x = imnoise;
params.blocksize = 8;
params.dictsize = 256;
params.sigma = sigma;
params.maxval = 255;
params.trainnum = 40000;
params.iternum = 20;
params.memusage = 'high';
% denoise!
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise(params);
time_program = cputime-time;
% show results %
dictimg = showdict(dict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imagesc(imresize(dictimg,2,'nearest'));
title('Trained dictionary');colormap gray

figure; imagesc(im/params.maxval);
title('Original image');colormap gray

figure; imagesc(imnoise/params.maxval); 
title(sprintf('Noisy image, PSNR: %.2fdB',comp_psnr(im,imnoise)));
colormap gray

figure; imagesc(imout/params.maxval);
title(sprintf('Denoised image, PSNR: %.2fdB', comp_psnr(im,imout)));
colormap gray