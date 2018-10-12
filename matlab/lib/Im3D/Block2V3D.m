function [E_V,Weight] = Block2V3D(VPat,par,sizeV)
% recovery the original 3D image from the estimated patches
% ImPat: ���㷨���ɵ�blocks���ϣ� Ϊ����������sizeV:ԭʼvideo��size��
%-----------------------------------------------------------------
% INPUT:
%       VPat: (patsize x patsize) x N x patsize;
%        par: structure
%            par.patsize: size of blocks
%            par.Pstep  : stride for the nearby blocks
%       sizeV: the original size of the 3D video
% OUTPUT:
%       E_Img: recovery video
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
TempR    = floor((sizeV(1)-patsize)/step)+1;
TempC    = floor((sizeV(2)-patsize)/step)+1;
TempS    = floor((sizeV(3)-patsize)/step)+1;
TempOffsetR = [1:step:(TempR-1)*step+1];
TempOffsetC = [1:step:(TempC-1)*step+1];
TempOffsetS = [1:step:(TempS-1)*step+1];
xx = length(TempOffsetR); % Video��row�п�����ȡ��patches��Ŀ
yy = length(TempOffsetC); % Video��column�п�����ȡ��patches��Ŀ
zz = length(TempOffsetS); % Video��spectral�п�����ȡ��patches��Ŀ

E_V       = zeros(sizeV);
Weight       = zeros(sizeV);

N = size(VPat,2);
ZPat = reshape(permute(VPat,[1 3 2]),[patsize patsize patsize N]);
for i = 1:patsize
    for j = 1:patsize
        for k = 1:patsize
            E_V(TempOffsetR-1+i,TempOffsetC-1+j,TempOffsetS-1+k) = E_V(TempOffsetR-1+i,TempOffsetC-1+j,TempOffsetS-1+k) + reshape(ZPat(i,j,k,:),[xx,yy,zz]);
            Weight(TempOffsetR-1+i,TempOffsetC-1+j,TempOffsetS-1+k) = Weight(TempOffsetR-1+i,TempOffsetC-1+j,TempOffsetS-1+k) + ones(xx,yy,zz);
        end
    end
end

E_V = E_V ./(Weight+eps);
