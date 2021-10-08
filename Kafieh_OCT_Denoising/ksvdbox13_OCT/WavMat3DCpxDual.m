function W = WavMat3DCpxDual(Faf,af, N, k0, shift)

% rahele kafieh 2012 dec

%make wavelet matrix for 1D dual tree complex filter
% [Faf, Fsf] = FSfarras;
% [af, sf] = dualfilt1;
% load ClxFilts, N=4

realF = Faf{1,1};%first stage- real part
h0f = realF(:,1);
h1f = realF(:,2);

ImagF = Faf{1,2};%first stage- imaginary part
g0f = ImagF(:,1);
g1f = ImagF(:,2);


real1 = af{1,1};%next stage- real part
h0 = real1(:,1);
h1 = real1(:,2);

Imag1 = af{1,2};%next stage- imaginary part
g0 = Imag1(:,1);
g1 = Imag1(:,2);



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

if nargin==4
    shift = 2;
end
J = log2(N);
if nargin==3
    shift = 2;
    k0 = J;
end
if (J ~= floor(J) )
    error('N has to be a power of 2.')
end
Wh = WavMatdiffFirst(h0f',h1f',h0',h1', N, k0, shift);
Wg = WavMatdiffFirst(g0f',g1f',g0',g1', N, k0, shift);


Whhh = kron(kron(Wh, Wh),Wh) ;
Whhg = kron(kron(Wh, Wh),Wg) ;
Whgh = kron(kron(Wh, Wg),Wh) ;
Whgg = kron(kron(Wh, Wg),Wg) ;
Wghh = kron(kron(Wg, Wh),Wh) ;
Wghg = kron(kron(Wg, Wh),Wg) ;
Wggh = kron(kron(Wg, Wg),Wh) ;
Wggg = kron(kron(Wg, Wg),Wg) ;


J=sqrt(-1);

mat=[1, -1, -1, -1    , J, -J, J, J;...
                1, -1, +1, +1    , J, +J, J, -J;...
                1, +1, -1, +1    , -J, +J, J, J;...
                1, +1, +1, -1    , -J, -J, J, -J;...
                1, +1, +1, -1    , +J, +J, -J, J;...
                1, +1, -1, +1    , +J, -J, -J, -J;...
                1, -1, +1, +1    , -J, -J, -J, J;...
                1, -1, -1, -1    , -J, +J, -J, -J];
            

W=zeros(N.^3, N.^3 *8);
% [Whhh; Wggh; Wghg; Whgg;Whgh;Wggg;Wghh;Whhg];

for i=1:8
    W(:, N.^3*(i-1)+1: N.^3*(i-1)+N.^3) =mat(i,1).*Whhh +mat(i,2).* Wggh+ mat(i,3).* Wghg + mat(i,4).*Whgg + mat(i,5).*Whgh +mat(i,6).* Wggg + mat(i,7).* Wghh + mat(i,8).*Whhg;
end

W = 1./8* W';
% 