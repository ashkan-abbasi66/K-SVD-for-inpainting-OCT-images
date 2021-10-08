% Usage:
%     addpath('E:\THESIS\Implements\Pedagogical')
%     im=im2double(imread('cameraman.tif'));
%     [R,C]=size(im);
%     ps=[50 50];
%     step=[10 10];
%     [X,pos]=extract_patches_lex_col(im,ps,step);
%     im2=insert_patches_lex_col(X,R,C,ps,step);
%     figure,imshow(im2)
%
% Ashkan
function [X,pos]=extract_patches_lex_col(im,ps,step)
if numel(ps)>1 
    ps1=ps(1);
    ps2=ps(2);
else
    ps1=ps;
    ps2=ps;
end
if numel(step)>1
    step1=step(1);
    step2=step(2);
else
    step1=step;
    step2=step;
end
%
[R,C]=size(im);
st_row=1;% start row index
end_row=R-ps1+1;
st_col=1;
end_col=C-ps2+1;
%
N=numel(st_row:step1:end_row)*numel(st_col:step2:end_col);
X=zeros(ps1*ps2,N);
pos=zeros(2,N);
%
k=1;
for j=st_col:step2:end_col
    for i=st_row:step1:end_row
        pos(:,k)=[i;j];
        r=i:i+ps1-1;% row indices
        c=j:j+ps2-1;% column indices
        p=im(r,c);
        %
        pv=reshape(p',ps1*ps2,1);
        %
        X(:,k)=pv;
        k=k+1;
    end
end