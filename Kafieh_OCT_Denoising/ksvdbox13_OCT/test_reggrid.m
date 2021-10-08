
function blocks=test_reggrid()
% Sample a set of blocks uniformly from a 2D image.
% n = 512; blocknum = 20000; blocksize = [8 8];
% im = rand(n,n);
% [i1,i2] = reggrid(size(im)-blocksize+1, blocknum);
% blocks = sampgrid(im, blocksize, i1, i2);


% n = 512; blocknum = 20000; blocksize = [8 8];
% im = rand(n,n,3);
% [i1,i2] = reggrid(size(im)-blocksize+1, blocknum);
% blocks2 = sampgrid(im, blocksize, i1, i2);
% disp(size(blocks2))

n = 512; blocknum = 20000; blocksize = [8 8];
im = rand(n,n,4);
imt=im(:,:,1);
[idx{1},idx{2}] = reggrid(size(imt)-blocksize+1, blocknum);
d1=size(idx{1},2);
d2=size(idx{2},2);
idx{3}=1;
blocks = sampgrid(im, [8 8 4], idx{:});
