% insert square or rectengular patches that were extracted
% lexicographically (e.g. using 'extract_patches_lex.m')
% 
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
%
% INPUTS:
% X: patches, m by n where m is the dimension of a patch.
% R: # rows of the input image
% C: # columns of the input image
% ps: patch size e.g. 8 or [4 8].
% step: step size
% OUTPUTS:
% im: the output image
%
% Ashkan
function im=insert_patches_lex(X,R,C,ps,step)
im=zeros(R,C);
counter=zeros(R,C);
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
k=1;
for i=st_row:step1:end_row
    for j=st_col:step2:end_col
        pv=X(:,k);
        k=k+1;
        p=reshape(pv,ps2,ps1)';%lex
        r=i:i+ps1-1;
        c=j:j+ps2-1;
        im(r,c)=im(i:i+ps1-1,j:j+ps2-1)+p;
        counter(r,c)=counter(r,c)+1;
    end
end
im=im./counter;