function im_out=denoise_LH_NLM(imn,ps)
step=1;
Testp{1}=extract_patches_lex_col(imn,ps,step);
[R,C]=size(imn);
wei_arr=ones(1,size(Testp{1},2));
Xf2= patchfiltering (Testp,wei_arr,ps(1), ps(2),...
    prod(ps),imn);
im_out=insert_patches_lex_col(Xf2,R,C,ps,step);
