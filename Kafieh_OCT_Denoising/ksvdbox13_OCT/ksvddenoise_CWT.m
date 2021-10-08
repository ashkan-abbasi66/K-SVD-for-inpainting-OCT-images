% use ksvd-denoising of Kafieh et al.
%
% Requirements:
% addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
% addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ksvdbox13_OCT');
% addpath('E:\mfiles_acode_thesis\SBSDI_2013_Fang_2');% function_stdEst
%
% Ashkan
function [imout,dict]=ksvddenoise_CWT(imnoise,blocksize,msgdelta,dict0)
if ~exist('blocksize')||isempty(blocksize)
    blocksize=8;
end
if nargin<3
    msgdelta=5;
end

params.x = imnoise;
params.blocksize = blocksize;
% params.gain=1;% default value 1.15
params.sigma = 30;%function_stdEst(imnoise);%30;%31;%30;%sqrt(evar(imnoise));%sigma
params.maxval = 255;
params.trainnum = prod(size(imnoise)-blocksize);%40000
params.iternum = 20;
params.memusage = 'high';
% params.lambda=0;
%------------------------------------------------
if ~exist('dict0','var')|| isempty(dict0)
    
    [Faf, Fsf] = FSfarras;
    [af, sf] = dualfilt1;
    % params.initdict = abs(WavMat2DCpxDual(Faf,af, params.blocksize))';
    % params.initdict = imag(WavMat2DCpxDual(Faf,af, params.blocksize))';
    params.initdict = real(WavMat2DCpxDual(Faf,af, params.blocksize))';
    params.dictsize = size(params.initdict,2);
else
    params.initdict=dict0;
    params.dictsize = size(params.initdict,2);
end
%------------------------------------------------
% denoise!
disp('Performing K-SVD denoising...');
[imout, dict] = ksvddenoise(params,msgdelta);