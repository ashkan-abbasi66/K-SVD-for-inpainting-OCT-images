%--------------------------------------------
% USAGE:
% % This example shows the following functions are equivalent:
% % extract_patches_lex_col <=> Get_patches_2_lex_col
% % insert_patches_lex_col <=> insert_patches_Get_patches_2_lex_col
% % 
% % im=im2double(imread('cameraman.tif'));
% % [R,C]=size(im);
% % ps=[8 8];
% % step=[1 1];
% % tic
% % %
% % % X=extract_patches_lex_col(im,ps,step);
% % X=Get_patches_2_lex_col(im,ps);
% % %
% % % im2=insert_patches_lex_col(X,R,C,ps,step);
% % im2=insert_patches_Get_patches_2_lex_col(X,R,C,ps);
% % %
% % time_extraction_insertion=toc
% % figure,imshow(im2)
%--------------------------------------------
% Ashkan
function im=insert_patches_lex_col(X,R,C,ps,step)
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
% [R,C]=size(im);
st_row=1;% start row index
end_row=R-ps1+1;
st_col=1;
end_col=C-ps2+1;
%
k=1;
for j=st_col:step2:end_col
    for i=st_row:step1:end_row
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