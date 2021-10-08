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
%------------------------------------------------------
% % OCT SEAD--------------------------------------------
%------------------------------------------------------
 %324, 005, 029, 081, 156, 379
% image_number =100;
% load('G:\my papers\oct denoising\ziess SEAD\E379_OCT.mat');
% mn1=mn;
% lImage = (mn1(:,:,image_number));
% im = lImage(:,200:800);
%------------------------------------------------------
% % OCT cornea--------------------------------------------
%------------------------------------------------------
% image_number =100;
% load('E:\kazemian\diffff\i1.mat');
% im=i1;
% % lImage = (mn1(:,:,image_number));
% % im = lImage(:,200:800);
%------------------------------------------------------
% % OCT Heidelberg ------------------------------------
%------------------------------------------------------
%amiri332, kushki84, mazaheri89, mehravi91, moazemi94, neshat99, raz08,
%shahbazi24
image_number =9;
load('p:\my papers\oct denoising\Heidelberg\mehravi91.mat');
lImage = (mn1(:,:,image_number));
im = log(lImage(:,:));

% evar(im)
%% generate noisy image ==> In OCT images we don't have a pure signal and the original signal is the noisy one%%

% n = randn(size(im)) * sigma;
% imnoise = im + n;
% sigma =  log(15);
sigma =  0.00002;
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
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise(params);



% show results %

dictimg = showdict(dict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imshow(imresize(dictimg,2,'nearest'));
title('Trained dictionary');

% figure; imshow(im/params.maxval);
% title('Original image');

imnoise2 = imrotate(imnoise,90);
figure; imagesc(exp(1).^imnoise2/params.maxval); 
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));
colormap gray

imout2 = imrotate(imout,90);
figure; imagesc(exp(1).^imout2/params.maxval);
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));
colormap gray

% save E234_OCT_100 dict params imnoise2 imout2