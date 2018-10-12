function [Dh, Dl] = train_coupled_dict(Xh, Xl, dict_size, lambda, iter)

addpath(genpath('lib'));%���libĿ¼��������Ŀ¼Ϊ·��
%% should pre-normalize Xh and Xl !

[Xh, Xl] = normalized2(Xh,Xl,2);
hDim = size(Xh, 1);
lDim = size(Xl, 1);
% X = cat(1, sqrt(hDim)*Xh, sqrt(lDim)*Xl);%
% X = normalized(X,2);
X = cat(1, sqrt(hDim)*Xh, sqrt(lDim)*Xl);

X = normalized(X,2);

clear Xh Xl;

%% joint learning of the dictionary

[D] = TwoDSC(X,dict_size,lambda, iter);


Dh = D(1:hDim, :,:);%�߷ֱ���ͼ���ֵ�
Dl = D(hDim+1:end, :,:);%�ͷֱ���ͼ���ֵ�




