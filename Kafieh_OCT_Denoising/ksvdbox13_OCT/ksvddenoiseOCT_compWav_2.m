% Test algorithm on Fang's image (Bioptigen SDOCT system (Durham,NC,USA))
%   start dictionary is the REAL part of dual tree complex wavelet (2D),
%   Rahele Kafieh
%
clc
% close all
clear all
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
addpath('E:\DTSET\Fang2013\Test');
addpath('E:\THESIS\Implements\Pedagogical');
%% prompt user for image %%
im=double(imread('average.tif'));% clean image
imnoise=double(imread('test.tif'));% noisy image
% sigma =  15; % noise std 
% sigma=sqrt(evar(imnoise));
sigma=30;%23
%% set parameters %%
params.x = imnoise;
params.blocksize = 8;
% params.dictsize = 256;
params.sigma = sigma;%sigma
params.maxval = 255;
params.trainnum = 40000;
params.iternum = 20;
params.memusage = 'high';
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
% params.initdict = abs(WavMat2DCpxDual(Faf,af, params.blocksize))';
% params.initdict = imag(WavMat2DCpxDual(Faf,af, params.blocksize))';
params.initdict = real(WavMat2DCpxDual(Faf,af, params.blocksize))';
params.dictsize = size(params.initdict,2);

% DCT = odctndict(params.blocksize,params.dictsize,ndims(params.x));

% denoise!
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise(params);

dictimg = showdict(dict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imagesc(imresize(dictimg,2,'nearest'));colormap gray
title('Trained dictionary');

figure; imshow(im/params.maxval);
title('Original image');

figure; imagesc(imnoise/params.maxval); 
title(sprintf('Noisy image, PSNR: %.2fdB',comp_psnr(im,imnoise)));
colormap gray 

figure; imagesc(imout/params.maxval);
title(sprintf('Denoised image, PSNR: %.2fdB', comp_psnr(im,imout)));
colormap gray 