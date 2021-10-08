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

% Dec. 2012 changes are made to fit OCT images
% Rahele Kafieh

%Feb. 2013 changes are made use a saved dictionary
%learns dictionary from one image and applies it for denoising of similar
%images
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

% OCT SEAD--------------------------------------------
% image_number =100;
% load('H:\seed segmentation\ziess SEAD\E379_OCT.mat');
% mn1=mn;
% lImage = (mn1(:,:,image_number));
% im = lImage(:,200:800);
%------------------------------------------------------
% % OCT TOPCON--------------------------------------------
%------------------------------------------------------
 %10584,10401, 10162, 10432, 10433, 10386
image_number =50;
% load('P:\my papers\oct denoising\Topcon diabete\10584.mat');
load('E:\DTSET\topcon_oct1000\1p.mat');
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
load('P:\my papers\oct denoising\compressed sensing\my codes\learn dics\ksvd toolbox by rubinstein\1\ksvdbox13\results\ksvddenoiseOCT\topcon diabete\lerned from itself\10162_OCT_50')

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



% denoise!
disp('Performing denoising using learned dictionary...');
[imout] = denoise_with_saved_dic(params,dict);



% show results %

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

% save 10584_OCT_50 dict params imnoise2 imout2