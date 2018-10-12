function [E_Img,Weight] = Patch2Im(ImPat,par,sizeX)
% recovery the original 2D image from the estimated patches
% ImPat: ���㷨���ɵ�patches���ϣ� Ϊ����������sizeX:ԭʼͼ�ε�size��
%-----------------------------------------------------------------
% INPUT: 
%      ImPat: patsize x N x patsize;
%        par: structure
%            par.patsize: size of blocks
%            par.Pstep  : stride for the nearby blocks
%       sizeX: the original size of the 2D image
% OUTPUT:
%       E_Img: recovery image
%       Weight: the weights of each pixels
%------------------------------------------------------------------
% written by FeiJiang @ sjtu
%-------------------------------------------------------------------

patsize = par.patsize;
if isfield(par,'Pstep')
    step = par.Pstep;
else
    step = 1;
end
TempR    = floor((sizeX(1)-patsize)/step)+1;
TempC    = floor((sizeX(2)-patsize)/step)+1;
TempOffsetR = [1:step:(TempR-1)*step+1];
TempOffsetC = [1:step:(TempC-1)*step+1];
xx = length(TempOffsetR); % ͼ���row�п�����ȡ��patches��Ŀ
yy = length(TempOffsetC); % ͼ���column�п�����ȡ��patches��Ŀ

E_Img       = zeros(sizeX);
Weight       = zeros(sizeX);

k = 0;
for i = 1:patsize
    for j = 1:patsize
        k = k + 1;
        E_Img(TempOffsetR-1+i,TempOffsetC-1+j) = E_Img(TempOffsetR-1+i,TempOffsetC-1+j) + reshape(ImPat(k,:),[xx,yy]);
        Weight(TempOffsetR-1+i,TempOffsetC-1+j) = Weight(TempOffsetR-1+i,TempOffsetC-1+j) + ones(xx,yy); 
    end
end

E_Img = E_Img ./(Weight+eps);
