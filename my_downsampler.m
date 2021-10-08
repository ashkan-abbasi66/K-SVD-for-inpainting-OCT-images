% Downsample an image and use NaN as indicator of missing data
%
% USAGE
%     pth='E:\DTSET\Fang2013\For synthetic experiments\3';
%     testfile='test.tif';% test_256
%     Test = double(imread(fullfile(pth,testfile)));
%     [Test,vr,vc]=my_downsampler(Test,2,1);
%     Test=Test(vr,vc);
%
% INPUT
% scale_factor
% mode: 
%     1:downsample columns
%     2:downsample rows
%     3:downsample rows and columns
% 
% Ashkan
function [imd,valid_rows,valid_cols]=...
    my_downsampler(im,scale_factor,mode)
[R,C]=size(im); % dimension of the image
if mode==1
    valid_cols=uint16(1:scale_factor:C);
    valid_rows=uint16(1:R);
elseif mode==2
    valid_cols=uint16(1:C);
    valid_rows=uint16(1:scale_factor:R);
else
    valid_cols=uint16(1:scale_factor:C);
    valid_rows=uint16(1:scale_factor:R);
end
nan_cols=uint16(1:C);
nan_rows=uint16(1:R);
nan_cols(valid_cols)=[];
nan_rows(valid_rows)=[];
imd=im;
if ~isempty(nan_cols)
    imd(:,nan_cols)=nan;
end
if ~isempty(nan_rows)
    imd(nan_rows,:)=nan;
end