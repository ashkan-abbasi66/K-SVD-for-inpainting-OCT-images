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
% March 2013 
% This version differs from "ksvddenoiseOCT_compWav" since this version doesn't learn
%the dictionary from the same data. Instead a learned dictionary (saved
%before) is used. The mentioned learned dictionary is obtained using 3D dual
% tree complex wavelet.
% Rahele Kafieh


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
%324, 005, 029, 081, 156, 379
% image_number =100;
load('G:\my papers\oct denoising\ziess SEAD\E081_OCT.mat');
mn1=mn;
% lImage = (mn1(:,:,image_number));
 im = mn1(:,200:800,91:110);

%load saved dictionary----------------------------------------
load('G:\my papers\oct denoising\results\results\ksvddenoiseOCT_compWav_3d\imag\SEAD\SEAD dic learned from itself\E005_OCT_100')


%% generate noisy image ==> In OCT images we don't have a pure signal and the original signal is the noisy one%%

% n = randn(size(im)) * sigma;
% imnoise = im + n;
sigma = 15;
imnoise = im;
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
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
% params.initdict = abs(WavMat3DCpxDual(Faf,af, params.blocksize))';
params.initdict = imag(WavMat3DCpxDual(Faf,af, params.blocksize))';
% params.initdict = real(WavMat3DCpxDual(Faf,af, params.blocksize))';

% DCT = odctndict(params.blocksize,params.dictsize,ndims(params.x));

% denoise!
disp('Performing denoising using learned dictionary...');
[imout] = denoise_with_saved_dic(params,dict);
time_program = cputime-time;


% show results %
% dictimg = showdict(params.initdict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
% figure; imshow(imresize(dictimg,2,'nearest'));
% title('initial dictionary');

number_of_slice_dictionary = 3;
dict_slice = dict((params.blocksize.^2)*(number_of_slice_dictionary-1)+1:(params.blocksize.^2)*(number_of_slice_dictionary),:);
dictimg = showdict(dict_slice,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
figure; imshow(imresize(dictimg,2,'nearest'));
title('Trained dictionary');

% figure; imshow(im/params.maxval);
% title('Original image');
im_num = 10;
imnoise2 = imrotate(imnoise(:,:,im_num),90);
figure; imagesc(imnoise2/params.maxval); colormap gray
title('Noisy image');%, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));

imout2 = imrotate(imout(:,:,im_num),90);
figure; imagesc(imout2/params.maxval); colormap gray
title('Denoised image');%, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));

%324, 005, 029, 081, 156, 379
% save E081_OCT_100 dict params im_num imnoise imout