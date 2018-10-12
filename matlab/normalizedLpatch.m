function Y = normalizedLpatch(X,opt)
if opt == 1
    Xdim2 = reshape(X,size(X, 1)*size(X, 2),size(X, 3));
    xNorm = sqrt(sum(Xdim2.^2));%ÿ��ƽ���Ϳ���
    for i = 1:length(xNorm)
        if xNorm(i) > 1
            xNorm(i) = xNorm(i);%������һ����
        else
            xNorm(i) =1;
        end
    end
    Y = Xdim2./repmat(xNorm, size(Xdim2, 1), 1);%Ԫ�س��Ը��еĶ�����
    Y = reshape(Y,size(X));
end
if opt == 2
    Xdim2 = X(:);
    xNorm = sqrt(sum(Xdim2.^2));%ÿ��ƽ���Ϳ���
    if xNorm > 1
        xNorm = xNorm;%������һ����
    else
        xNorm =1;
    end
    Y = Xdim2./repmat(xNorm, size(Xdim2, 1), 1);%Ԫ�س��Ը��еĶ�����
    Y = reshape(Y,size(X));
end