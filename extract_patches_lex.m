% Extract square or rectengular patches from the given image
%
% INPUTS:
% im
% ps: patch size e.g. 8 or [4 8].
% stpsz: step size
% OUTPUTS:
% X: ps1*ps2 by N, N:number of patches
% pos: position of the patches. 2 by N
%--------------------------------------------
% USAGE:
% % % This example shows the following functions are equivalent:
% % % extract_patches_lex <=> Get_patches_2_lex
% % % insert_patches_lex <=> insert_patches_Get_patches_2_lex
% % %
% % im=im2double(imread('cameraman.tif'));
% % [R,C]=size(im);
% % ps=[8 8];
% % step=[1 1];
% % tic
% % %
% % % X=extract_patches_lex(im,ps,step);
% % X=Get_patches_2_lex(im,ps);
% % %
% % % im2=insert_patches_lex(X,R,C,ps,step);
% % im2=insert_patches_Get_patches_2_lex(X,R,C,ps);
% % %
% % time_extraction_insertion=toc
% % figure,imshow(im2)
%--------------------------------------------
% Ashkan
function [X,pos]=extract_patches_lex(im,ps,stpsz)
if numel(ps)>1 
    ps1=ps(1);
    ps2=ps(2);
else
    ps1=ps;
    ps2=ps;
end
if numel(stpsz)>1
    stpsz1=stpsz(1);
    stpsz2=stpsz(2);
else
    stpsz1=stpsz;
    stpsz2=stpsz;
end
%
[R,C]=size(im);
st_row=1;% start row index
end_row=R-ps1+1;
st_col=1;
end_col=C-ps2+1;
%
N=numel(st_row:stpsz1:end_row)*numel(st_col:stpsz2:end_col);
X=zeros(ps1*ps2,N);
pos=zeros(2,N);
%
k=1;
for i=st_row:stpsz1:end_row
    for j=st_col:stpsz2:end_col
        pos(:,k)=[i;j];
        r=i:i+ps1-1;% row indices
        c=j:j+ps2-1;% column indices
        p=im(r,c);
        %
        pv=reshape(p',ps1*ps2,1);
%         pv=p(:);
        %
        X(:,k)=pv;
        k=k+1;
    end
end