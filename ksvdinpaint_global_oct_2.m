% See ksvdinpaint_global_oct_1.m
% This file just denoises input image before inpainting procesure.
%
%  the denoising greately improves the result of the inpainting algorithm
%  that is described in detail in the file "ksvdinpaint_global_oct_1".
% the differences with "ksvdinpaint_global_oct_1" are as follows:
%   SC_method='omp'; sparsity_level=2;
%   the input is denoised 
%
% Dictionaries were learned from high SNR images in the training set of the
% following paper:
% Fang, Leyuan, et al. "Fast acquisition and reconstruction of optical 
% coherence tomography images via sparse representation." 
% IEEE transactions on medical imaging 32.11 (2013): 2034-2049.
%
% Denoising method called with "denoise_LH_NLM" which is a nonlocal mean
% based denoising method was used by the above paper. 
%
%
% Ashkan
%% Load images and set required paths
addpath(genpath('./Kafieh_OCT_Denoising/'));
%
tic
clear
% Load Images
pth='./';
testfile='test.tif';% test_256
cleanfile='average.tif'; %average_256
%
imn = double(imread(fullfile(pth,testfile)));% LL1_256.tif   test_256
im= double(imread(fullfile(pth,cleanfile)));
[R C] = size(imn);
% Set important parameters
N = R*C; % image size
p = 8; q = 8;
T = p*q; % patch size
DL_method='loadfile';% 'loadfile' / 'ksvddenoise'
SC_method='omp'; % 'momp' 'omp' / 'omp2'
sparsity_level=2;
epsilon=p *22*1.05;%last reported by 22 & 1.15 using omp2
% downsample image
scale_factor = 1; % scale_factor, 1: denoising
mode=1;
[imnd,valid_rows,valid_cols]=...
    my_downsampler(imn,scale_factor,mode);
% **** denoise input fairly ****
disp('Denoising ... ')
imnd(:,valid_cols)=denoise_LH_NLM(imnd(:,valid_cols),[8 8]);
%
%% Dictionary learning method
switch DL_method
    case 'ksvddenoise'
        disp('Dictionary learning ...')
%         [~,D]=ksvddenoise_CWT(imnd(valid_rows,valid_cols),p,5);
        [~,D]=ksvddenoise_CWT(imn,p,5);
    case 'loadfile'
        dict_file = 'dicts_comp_noDC_e9_it40';%'dictionary8x8.mat';%'dicts_comp_noDC_e30_it40';%'dictionary8x8.mat';
        load(dict_file)
        D=D{1};
end
%% SC_method
switch SC_method
    case 'omp'
        param.L=sparsity_level;
        sparse_func=@compute_codes_omp;
    case 'omp2'
        param.eps=epsilon;
        sparse_func=@compute_codes_omp2;
end
%% extract patches from noisy image(imn) - downsampled image
fprintf('Extract patches from imn ....\n');
step=1;
Xn=extract_patches_lex(imnd,[p q],step);
[Xn,dc1]=remove_mean_inpainting(Xn);
%% find patterns of NaN for the structured inpainting
if scale_factor>1
    tmp_pat=isnan(Xn)';
    pat=double(unique(tmp_pat,'rows')');
    pat(pat==1)=nan;
    param.nan_patterns=pat;
end
%% compute sparse codes of corrupted patches
fprintf('Compute sparse codes of corrupted patches ....\n');
codes=sparse_func(Xn,D,param);
Xnhat=D*codes;
%% merge patches
Xnhat_dc=Xnhat+repmat(dc1,size(Xnhat,1),1);
im_out=insert_patches_lex(Xnhat_dc,R,C,[p q],step);
[PSNR,SSIM]=comp_psnr(im,im_out)
time_end=toc;
figure,imshow(im_out,[]),title(sprintf('PSNR=%g',PSNR))
% save('out_ksvd_global_eps22_im3','im_out','time_end');