function Y = normalized(X)
Xdim2 = reshape(X,size(X, 1)*size(X, 3),size(X, 2));
xNorm = sqrt(sum(Xdim2.^2));%ÿ��ƽ���Ϳ���
Y = Xdim2./repmat(xNorm, size(Xdim2, 1), 1);%Ԫ�س��Ը��еĶ�����
Y = reshape(Y,size(X));
end