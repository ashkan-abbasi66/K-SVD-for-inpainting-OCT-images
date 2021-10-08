% INPUTS:
% im: orginal image
% imf: reconstructed image
% imn: noisy image (OPTIONAL)
%
% Usage:
%   addpath('E:\THESIS\Implements\Pedagogical');
%   PSNR=comp_psnr(im,imf)
%   [PSNR,SSIM]=comp_psnr(im,imf)
%   [PSNR,SSIM,ISNR]=comp_psnr(im,imf,imn)
%
% Ashkan
function [PSNR,SSIM,ISNR]=comp_psnr(im,imf,imn)
MSE=mean(mean((im(:)-imf(:)).^2));
if max(im(:))<2
    MaxI=1;
else
    MaxI=255;
end
PSNR=10*log10((MaxI^2)/MSE);
%
if nargout>1
    if MaxI == 1
        SSIM=ssim_index(im*255,imf*255); % or "ssim(imf,im)"
    else
        SSIM=ssim_index(im,imf); % or "ssim(imf,im)"
    end
end
if nargout>2 && (exist('imn','var') || ~ieempty(imn))
    ISNR=10*log10((mean(mean((im(:)-imn(:)).^2))/MSE));
end