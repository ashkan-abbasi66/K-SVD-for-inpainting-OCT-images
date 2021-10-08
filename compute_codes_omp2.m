% set param.eps
function codes=compute_codes_omp2(data,D,param)
% addpath('E:\THESIS\Implements\SPAMS\spams-matlab\build');
codes=zeros(size(D,2),size(data,2));
dim=size(data,1);
% ++++++++++++++ for denoising ++++++++++++++++++++++++
if sum(isnan(data(:,1)))==0
    param.numThreads=-1;
    codes=omp2(D,double(data),[],param.eps);
    return
end
% ++++++++++++++ for inpainting +++++++++++++++++++++++
p=param.nan_patterns;
Np=size(p,2);
for ii=1:Np
    loc=single(sum(isnan(data)==repmat(isnan(p(:,ii)),1,size(data,2))));
    ind=loc~=0;% logical indices of the 'data' with pattern p(:,ii)
    clear loc;
    %---- preparing data for inpainting ----
    d=data(:,ind);% a portion of 'data'
    d=remove_nans(d);
    %---------------------------------------
    % Make new dictionary
    DD=D;
    DD(isnan(p(:,ii)),:)=[];
    DDnorms=sqrt(sum(DD.^2, 1));
    DD = DD./repmat(DDnorms,size(DD,1), 1);% DD=normc(DD);% new dictionary
    Gamma=omp2(DD,double(d),[],param.eps);
    %*******************************************
    codes(:,ind)=Gamma;
end