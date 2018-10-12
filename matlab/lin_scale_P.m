function [xh] = lin_scale_P( X, mNormP, mMeanP)
X = permute(X,[1 3 2]);
xh = reshape(X,size(X, 1)*size(X, 2),size(X, 3));
hNorm = sqrt(sum(xh.^2));%ÿ��ƽ���Ϳ���
xh = xh.*mNormP*1.1;
xh = xh./repmat(hNorm, size(xh, 1), 1);%Ԫ�س��Ը��еĶ�����
xh = xh+mMeanP;
xh = reshape(xh,size(X, 1),size(X, 2),size(X, 3));
xh = permute(xh,[1 3 2]);

