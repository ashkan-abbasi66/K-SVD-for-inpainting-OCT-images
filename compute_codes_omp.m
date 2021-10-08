% set:
%     param.L & param.nan_patterns
function codes=compute_codes_omp(data,D,param)
codes=zeros(size(D,2),size(data,2));
% ++++++++++++++ for denoising ++++++++++++++++++++++++
if sum(isnan(data(:,1)))==0
    param.numThreads=-1;
%     codes=mexOMP(double(data),D,param);
    codes=omp(D,double(data),[],param.L);
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
    Gamma=omp(DD,double(d),[],param.L);
    %*******************************************
    codes(:,ind)=Gamma;
end