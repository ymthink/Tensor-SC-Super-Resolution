function [hSeis] = ScSR362(seismic_l_o, up_scale, Dh, Dl, lambda, overlap)
%6������������ָ�

%% hyperparameters settings
addpath(genpath('lib'));
[parDL] = ParSet(Dh,overlap,lambda);

%% normalize the dictionary
Dl = normalized(Dl,2);

% patch_size = size(Dh, 3);%�����ͼ����С
nrow = size(seismic_l_o, 1)* up_scale;
ncol = size(seismic_l_o, 2)* up_scale;
nFrames = size(seismic_l_o, 3);

%% generate low resolution counter parts
seismic_l = zeros(nrow, ncol, nFrames);
for k = 1 : nFrames
    im = seismic_l_o(:,:,k);
    lIm = imresize(im,  [nrow ncol], 'bicubic'); %�Ŵ�up_scale��
    seismic_l(:,:,k) = lIm;
end
seismic_l(1:up_scale:nrow,1:up_scale:ncol,:) = seismic_l_o;

% extract low-resolution image features
lImfea = extr_lIm_fea(seismic_l);%����һ�׵������������׵�����4������

%% sparse recovery for low-resolution patch
% patch indexes for sparse recovery (avoid boundary)
gridx = 3: nrow-2;
gridy = 3: ncol-2;
gridz = 3: nFrames-2;
% gridx = 1: nrow;
% gridy = 1: ncol;
% gridz = 1: nFrames;
% gridz = 50: 50+patch_size-1;

% features blocks extraction
LP1=[];
for ii = 1:size(lImfea,4)   
    lImG = V2Block3D( lImfea(gridx,gridy,gridz,ii), parDL);      
    LP1= cat(1, LP1, lImG);
end
clear lImG;
LP1 = normalized(LP1,2);

w1  = TenTSTA(LP1,parDL,Dl); 

%% generate the high resolution patch and scale the contrast
HP1 = tensor_prod(Dh,[],w1,[]);  
% blocks extraction
sz_X = size( seismic_l(gridx,gridy,gridz));
[X] = V2Block3D( seismic_l(gridx,gridy,gridz), parDL); 
[mMeanP1,mNormP1] = MeanNormExtract(X);

HP1 = lin_scale_P(HP1, mNormP1, mMeanP1); %ȥ��һ����
%% aggragation
hSeis = zeros(size(seismic_l));%���洦���ĸ߷ֱ�������
hSeis(gridx,gridy,gridz) = Block2V3D(HP1,parDL,sz_X);
idx = (hSeis == 0);
hSeis(idx) = seismic_l(idx);
%%
function [parDL] = ParSet(Dh,overlap,lambda)
% parameters setting for tensor dictioanry learning
parDL.r   =size(Dh, 2);;
parDL.eta     = 1.01 ; % control the increasing speed of Lipschitz constant 
parDL.maxiterB  = 50;
parDL.beta = lambda;
parDL.patsize = size(Dh, 3);%�����ͼ����С
parDL.Pstep = parDL.patsize-overlap;
end

end
% LP = [];
% mNormP = [];
% mMeanP = [];
% 
% for ii = 1:length(gridz),
%     for jj = 1:length(gridy),
%         for kk = 1:length(gridx),
% 
%             zz = gridz(ii);
%             yy = gridy(jj);
%             xx = gridx(kk);
%         
%             mPatch1 = video_l(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1); %ȡ����ǰҪ����Ŀ�
%            
%             mMean = mean(mPatch1(:)); %����ֵ
%             mPatch = mPatch1(:)-ones(patch_size*patch_size*patch_size,1)*mMean;
%             mNorm = sqrt(sum(mPatch.^2)); %ƽ�����ٿ�����2������
% 
%             mNormpatch = mNorm * ones(patch_size*patch_size,1,patch_size);
%             mMeanpatch = mMean * ones(patch_size*patch_size,1,patch_size);
% 
%             
%             lImG1 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,1);
%             lImG2 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,2);
%             lImG3 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,3);
%             lImG4 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,4);
%             lImG5 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,5);
%             lImG6 = lImfea(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1,6);
%             lImG1 = reshape(lImG1,size(lImG1, 1)*size(lImG1, 2),1,size(lImG1, 3));
%             lImG2 = reshape(lImG2,size(lImG2, 1)*size(lImG2, 2),1,size(lImG2, 3));
%             lImG3 = reshape(lImG3,size(lImG3, 1)*size(lImG3, 2),1,size(lImG3, 3));
%             lImG4 = reshape(lImG4,size(lImG4, 1)*size(lImG4, 2),1,size(lImG4, 3));
%             lImG5 = reshape(lImG5,size(lImG1, 1)*size(lImG1, 2),1,size(lImG1, 3)); 
%             lImG6 = reshape(lImG6,size(lImG1, 1)*size(lImG1, 2),1,size(lImG1, 3));  
%             Lpatch = [lImG1; lImG2; lImG3; lImG4; lImG5; lImG6];
%             Lpatch = normalizedLpatch(Lpatch,2);
%             
%             LP= cat(2, LP, Lpatch);
% 
%             mNormP = cat(2, mNormP, mNormpatch);
%             mMeanP = cat(2, mMeanP, mMeanpatch);
%             
%         end
%     end
% end

% w  = TenTSTA(LP,parDL,Dl);
% % generate the high resolution patch and scale the contrast
% HP = tensor_prod(Dh,[],w,[]);      
% HP = lin_scale_P(HP, mNormP, mMeanP); %ȥ��һ����

% cntMat = zeros(size(seismic_l));%���棬ÿ��λ��Ԫ�ر������˼���
% i=1;
% for ii = 1:length(gridz)
%     for jj = 1:length(gridy)
%         for kk = 1:length(gridx)
%             
%             zz = gridz(ii);
%             yy = gridy(jj);
%             xx = gridx(kk);
%             
%             hPatch = HP(:,i,:);
%             i = i+1;
%             hPatch = reshape(hPatch,patch_size,patch_size,patch_size);        
%             hSeis(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1) = hSeis(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1) + hPatch;%�����ĸ߷ֱ�������           
%             cntMat(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1) = cntMat(xx:xx+patch_size-1, yy:yy+patch_size-1,zz:zz+patch_size-1) + 1;%�ƴ�λ��Ԫ�ؼ����˼���
%     
%         end
%     end
% end

% fill in the empty with bicubic interpolation
% idx = (cntMat < 1);
% hSeis(idx) = seismic_l(idx);
% cntMat(idx) = 1;
% hSeis = hSeis./cntMat; %����Ԫ�ؼ��������ƽ��


