% function ksvddenoiseOCT
%KSVDDENOISEDEMO K-SVD denoising demonstration.
%  KSVDDENISEDEMO reads an image, adds random white noise and denoises it
%  using K-SVD denoising. The input and output PSNR are compared, and the
%  trained dictionary is displayed.
%  To run the demo, type KSVDDENISEDEMO from the Matlab prompt.
%  See also KSVDDEMO.
%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs  August 2009

% Dec. 2012 changes are made to fit OCT images==>start dictionary is dual
% tree complex wavelet (3D)
% Rahele Kafieh
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


%% prompt user for image %%

% % OCT--------------------------------------------
% % image_number =54;
% load('D:\phd project\diffusion\data\topcon\jalili rotated\320.mat');
% % lImage = (mn1(:,:,image_number));
% im = mn1(100:100+512-1,:,50:70);
%SEAD----------------------------------------------
% %324, 005, 029, 081, 156, 379
% % image_number =100;
% load('m:\seed segmentation\ziess SEAD\E081_OCT.mat');
% mn1=mn;
% % lImage = (mn1(:,:,image_number));
% im = mn1(:,200:800,91:110);
%------------------------------------------------------
% % OCT TOPCON--------------------------------------------
%------------------------------------------------------
 %10584, 10162, 10401,  10432, 10433, 10386
% image_number =50;
% load('P:\my papers\oct denoising\Topcon diabete\10162.mat');
load('E:\DTSET\topcon_oct1000\1p.mat');
% save 10401_OCT_100 dict params im_num imnoise imout 
mn1=d5;

 lImage = (mn1(:,:,41:60));
% imagesc(lImage), colormap gray
im = lImage(90:350,:,:);
%----------------
%  lImage = (mn1(:,:,41:42));
% im = lImage(90:91,:,:);
%% generate noisy image ==> In OCT images we don't have a pure signal and the original signal is the noisy one%%

% n = randn(size(im)) * sigma;
% imnoise = im + n;
sigma = 15;
imnoise = im;
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
[imout, dict] = ksvddenoise(params);



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
im_num = 20;
imnoise2 = imrotate(imnoise(:,:,im_num),0);
figure; imagesc(imnoise2/params.maxval); colormap gray
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));

imout2 = imrotate(imout(:,:,im_num),0);
figure; imagesc(imout2/params.maxval); colormap gray
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));

%324, 005, 029, 081, 156, 379
% save E081_OCT_100 dict params im_num imnoise imout