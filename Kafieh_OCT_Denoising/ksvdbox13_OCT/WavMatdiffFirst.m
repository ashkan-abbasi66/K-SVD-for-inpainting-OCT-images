function W = WavMatdiffFirst(h0f,h1f,h0,h1, N, k0, shift)
% RAhele kafieh 2012 dec

% This program works in cases withh a different filter for first stage
% h0f = h0f';
% h1f = h1f';
% h0 = h0';
% h1 = h1';
% WavMat -- Transformation Matrix of FWT_PO
%  Usage
%    W = WavMat(h, N, k0, shift)
%  Inputs
%    h      low-pass filter corresponding to orthogonal WT
%    N      size of matrix/length of data. Should be power of 2.
%      
%    k0     depth of transformation. Ranges from 1 to J=log2(N).
%           Default is J. 
%    shift  the matrix is not unique an any integer shift gives
%           a valid transformation. Default is 2.
%  Outputs
%    W      N x N transformation matrix 

if nargin==3
    shift = 2;
end
J = log2(N);
if nargin==2
    shift = 2;
    k0 = J;
end

if (J ~= floor(J) )
    error('N has to be a power of 2.')
end
h0=[h0,zeros(1,N)]; %extend filter H0 by 0's to sample by modulus
h1=[h1,zeros(1,N)]; %extend filter h1 by 0's to sample by modulus
h0f=[h0f,zeros(1,N)]; %extend filter h1 by 0's to sample by modulus
h1f=[h1f,zeros(1,N)]; %extend filter h1 by 0's to sample by modulus

oldmat = eye(2^(J-k0)); 
for k= k0:-1:1
    clear h1mat; clear h0mat;
         ubJk = 2^(J-k); ubJk1 = 2^(J-k+1);
         if k==1% to change filters in first stage
             h0 = h0f;
             h1 = h1f;
         end
   for  jj= 1:ubJk
       for ii=1:ubJk1
           modulus = mod(N+ii-2*jj+shift,ubJk1);
           modulus = modulus + (modulus == 0)*ubJk1;
           h0mat(ii,jj) = h0(modulus);
           h1mat(ii,jj) = h1(modulus);
%            ii,jj,ubJk
       end
   end
  W = [oldmat * h0mat'; h1mat' ];
   oldmat = W;
end
%
% 
% Copyright (c) 2004. Brani Vidakovic
%        
%  
% ver 1.0 Built 8/24/04; ver 1.2 Built 12/1/2004
% This is Copyrighted Material
% Comments? e-mail brani@isye.gatech.edu
%   