% Sparse inverse problem estimation may be unstable if some columns in UD 
% are too similar (coherency is high; mu is high)
% Regular operators U such as subsampling on a uniform grid and
% convolution, usually lead to a coherent UD, which makes accurate 
% inverse problem estimation difficult.
% ref:
% Sapiro-PLE-Piecewise Linear Estimators-From Gaussian Mixture Models to Structured Sparsity
%
% ashkan
%%
addpath(genpath('./Kafieh_OCT_Denoising/'));

%
pth='./';
testfile='test.tif';% test_256
%
imn = double(imread(fullfile(pth,testfile)));
[R C] = size(imn);
N = R*C; % image size
p = 8; q = 8;
T = p*q; % patch size
% downsample image
scale_factor = 2; % scale_factor, 1: denoising
mode=1;
[imnd,valid_cols,valid_rows]=...
    my_downsampler(imn,scale_factor,mode);
disp(sprintf('scale factor=%d, mode=%d',scale_factor,mode))
% load D
dict_file = 'dicts_comp_noDC_e9_it40';%'dictionary8x8.mat';%'dicts_comp_noDC_e30_it40';%'dictionary8x8.mat';
load(dict_file)
%% extract patches from noisy image(imn) - downsampled image
step=1;
Xn=extract_patches_lex(imnd,[p q],step);
%% find patterns of NaN for the structured inpainting
nan_patterns=[];
if scale_factor>1
    tmp_pat=isnan(Xn)';
    pat=double(unique(tmp_pat,'rows')');
    pat(pat==1)=nan;
    nan_patterns=pat;
end
%%
DD=D{1};
if ~isempty(nan_patterns)
    for i=1:size(nan_patterns,2)
        A=DD(~isnan(nan_patterns(:,i)),:);
        A = A./repmat(sqrt(sum(A.^2, 1)),size(A,1), 1);
        C=((A'*A)/diag(diag(A'*A)))-eye(size((A'*A)));
        mu(i)=max(C(:));
    end
else
    A=DD;
    C=((A'*A)/diag(diag(A'*A)))-eye(size((A'*A)));
    mu=max(C(:));
end
mu