% Test algorithm on Fang's image (Bioptigen SDOCT system (Durham,NC,USA))
%   start dictionary is the REAL part of dual tree complex wavelet (3D),
%   Rahele Kafieh
%
clc
% close all
clear all
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
addpath('E:\DTSET\Fang2013\Test');
addpath('E:\THESIS\Implements\Pedagogical');
%% prompt user for image %%
% there is no clean image for each noisy one.
imnoise=[];
for i=1:4
    imnoise(:,:,i)=double(imread([num2str(i) '.tif']));% noisy image
end
sigma =  15; % noise std 
%% set parameters %%
params.x = imnoise;
params.blocksize = 8;
params.dictsize = 256;
params.sigma = sigma;
params.maxval = 255;
params.trainnum = 40000;
params.iternum = 20;
params.memusage = 'high';
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
% params.initdict = abs(WavMat3DCpxDual(Faf,af, params.blocksize))';
% params.initdict = imag(WavMat3DCpxDual(Faf,af, params.blocksize))';
params.initdict = real(WavMat3DCpxDual(Faf,af, params.blocksize))';

% DCT = odctndict(params.blocksize,params.dictsize,ndims(params.x));

% denoise!
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise_2(params);

number_of_slice_dictionary = 1;
dict_slice = dict((params.blocksize.^2)*(number_of_slice_dictionary-1)+1:(params.blocksize.^2)*(number_of_slice_dictionary),:);
dictimg = showdict(dict_slice,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imagesc(imresize(dictimg,2,'nearest'));colormap gray
title('Trained dictionary');

% figure; imshow(im/params.maxval);
% title('Original image');

im_num = 1;
imnoise2 = imrotate(imnoise(:,:,im_num),0);
figure; imagesc(imnoise2/params.maxval); colormap gray
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));

imout2 = imrotate(imout(:,:,im_num),0);
figure; imagesc(imout2/params.maxval); colormap gray
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));
