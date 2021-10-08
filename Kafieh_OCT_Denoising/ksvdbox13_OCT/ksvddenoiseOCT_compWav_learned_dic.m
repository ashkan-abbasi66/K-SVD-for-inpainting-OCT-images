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
% tree complex wavelet (2D)
%March 2013 
% This version differs from "ksvddenoiseOCT_compWav" since this version doesn't learn
%the dictionary from the same data. Instead a learned dictionary (saved
%before) is used. The mentioned learned dictionary is obtained using 2D dual
% tree complex wavelet.
% Rahele Kafieh

clc
close all
clear all
disp(' ');
disp('  **********  K-SVD Denoising  **********');
disp(' ');
disp('  The dictionary is trained using patches from the corrupted image. ');
disp('  using K-SVD denoising. The function displays the noisy, and denoised');
disp('  images, and shows the resulting trained dictionary.');
disp(' ');


%% prompt user for image %%

% OCT--------------------------------------------
% image_103number =54;
% load('D:\phd project\diffusion\data\topcon\jalili rotated\320.mat');
% lImage = (mn1(:,:,image_number));
% im = lImage(100:100+512-1,:);
%SEAD----------------------------------------------
%234, 005, 029, 081, 156, 379
% image_number =100;
% load('H:\seed segmentation\ziess SEAD\E379_OCT.mat');
% mn1=mn;
% lImage = (mn1(:,:,image_number));
% im = lImage(:,200:800);
%------------------------------------------------------
% % OCT TOPCON--------------------------------------------
%------------------------------------------------------
 %10584, 10162, 10401,  10432, 10433, 10386
image_number =50;
load('g:\my papers\oct denoising\Topcon diabete\10162.mat');
% save 10162_OCT_100 dict params imnoise2 imout2% 
mn1=d5;

 lImage = (mn1(:,:,image_number));
% imagesc(lImage), colormap gray
im = lImage;
% 
% % im = lImage(:,200:800);
% figure,for image_number=1:128 
%     lImage = (mn1(:,:,image_number));
% imagesc(lImage), colormap gray
% pause()
% end

%load saved dictionary----------------------------------------
load('G:\my papers\oct denoising\results\results\ksvddenoiseOCT_compWav_2d\real\Topcon diabete\learned from itself\10584_OCT_50')

%% generate noisy image ==> In OCT images we don't have a pure signal and the original signal is the noisy one%%
time=cputime;
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
% params.initdict = abs(WavMat2DCpxDual(Faf,af, params.blocksize))';
% params.initdict = imag(WavMat2DCpxDual(Faf,af, params.blocksize))';
params.initdict = real(WavMat2DCpxDual(Faf,af, params.blocksize))';

% DCT = odctndict(params.blocksize,params.dictsize,ndims(params.x));


% denoise!
disp('Performing denoising using learned dictionary...');
[imout] = denoise_with_saved_dic(params,dict);
time_program = cputime-time;


% show results %
% dictimg = showdict(params.initdict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
% figure; imshow(imresize(dictimg,2,'nearest'));
% title('initial dictionary');

dictimg = showdict(dict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imshow(imresize(dictimg,2,'nearest'));
title('Trained dictionary');

% figure; imshow(im/params.maxval);
% title('Original image');

imnoise2 = imrotate(imnoise,90);
figure; imagesc(imnoise/params.maxval); 
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));
colormap gray 

imout2 = imrotate(imout,90);
figure; imagesc(imout/params.maxval);
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));
colormap gray 
%234, 005, 029, 081, 156, 379
 %10584, 10162, 10401,  10432, 10433, 10386
% save 10433_OCT_50 dict params imnoise2 imout2