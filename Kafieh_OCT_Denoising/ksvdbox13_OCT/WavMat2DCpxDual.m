function W = WavMat2DCpxDual(Faf,af, N, k0, shift)

% Rahele kafieh 2012 dec
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

Whh = kron(Wh, Wh);
Wgg = kron(Wg, Wg);
Wgh = kron(Wg, Wh);
Whg = kron(Wh, Wg);
% 
% matt = [eye(N), -eye(N), zeros(N), zeros(N);...
%                 eye(N), eye(N), zeros(N), zeros(N);...
%                 zeros(N), zeros(N), eye(N), eye(N);...
%                 zeros(N), zeros(N), eye(N), -eye(N)];
J=sqrt(-1);

mat = [1, -1, J, J;...
       1, 1, J, -J;...
       1,1, -J, J;...
       1,-1,-J,-J];
W=zeros(N.^2, N.^2 *4);


for i=1:4
    W(:, N.^2*(i-1)+1: N.^2*(i-1)+N.^2) = mat(i,1).*Whh +mat(i,2).* Wgg + mat(i,3).* Wgh+mat(i,4).*Whg;
end

W = 1./4* W';
% 