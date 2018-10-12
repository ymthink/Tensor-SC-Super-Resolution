function [HP, LP] = sample_patches2(video_h, patch_size, patch_num, upscale)
%��������+6������
%% �õ��ͷֱ���ͼ��͸߷ֱ���ͼ��
[nrow,ncol,nhei] = size(video_h);
video_l = zeros(nrow,ncol,nhei);
for k = 1 : nhei
    im = video_h(:,:,k);%��ȡ�ڼ�֡
    % generate low resolution counter parts
    lIm = im(1:upscale:nrow,1:upscale:ncol);%ͼ��ߴ�����һ��
    lIm = imresize(lIm, size(im), 'bicubic');%ͼ����ԭ���ĳߴ磨�ͷֱ���ͼ��-����upscale��
    video_l(:,:,k) =  lIm;
end
% video_l(1:upscale:nrow,1:upscale:ncol,:) = video_h(1:upscale:nrow,1:upscale:ncol,:);
%% queshi
% ratio=0.85;   %�������ݵİٷֱ�
% mask=genmask(reshape(video_h,nrow,ncol*nhei),ratio,'r',201415);  %���Ե���Ϊ��ȱʧ����ȱʧ�����ȱʧ
% mask=reshape(mask,nrow,ncol,nhei);
% seismic_l = video_h.*mask;
% 
% idx = (seismic_l == 0);
% seismic_l(idx) = video_l(idx);
% video_l = seismic_l;
%% �ͷֱ���������ȡ
lImfea = extr_lIm_fea(video_l);
clear video_l;

%% ���ѡȡ�����Ͻ�Ԫ������
x = randperm(nrow-2*patch_size-1) + patch_size;%��������������У��ټ��Ͽ��С
y = randperm(ncol-2*patch_size-1) + patch_size;
z = randperm(nhei-2*patch_size-1) + patch_size;

%% ȡ������
HP = [];%�洢�߷ֱ���ͼ���
LP = [];%�洢�ͷֱ���ͼ���
ii = 1;
num = 1;
while (ii <= patch_num)
    num = num +1;
    nrow =   randsrc(1,1,x);
    col =   randsrc(1,1,y);
    hei =   randsrc(1,1,z);
    
    Hpatch = video_h(nrow:nrow+patch_size-1,col:col+patch_size-1,hei:hei+patch_size-1);%�߷ֱ���������
    Hpatch = Hpatch-ones(patch_size,patch_size,patch_size)*mean(Hpatch(:));%�߷ֱ���������-������������ȥ��ֵ���洢����������������
    Hpatch = reshape(Hpatch,size(Hpatch, 1)*size(Hpatch, 2),1,size(Hpatch, 3));  
    Lpatch=[];
    for jj = 1:size(lImfea,4)  
        Lpatch1 = lImfea(nrow:nrow+patch_size-1,col:col+patch_size-1,hei:hei+patch_size-1,jj);
        Lpatch1 = reshape(Lpatch1,size(Lpatch1, 1)*size(Lpatch1, 2),1,size(Lpatch1, 3));
        Lpatch= cat(1, Lpatch, Lpatch1);
    end 
    ii = ii+1;
    HP= cat(2, HP, Hpatch);
    LP= cat(2, LP, Lpatch);
%     j=0;
%     for i = 1:patch_size
%         if  ~(isequal(Hpatch(:,:,i), zeros(patch_size*patch_size,1))) && ~(isequal(Lpatch1(:,:,i) , zeros(patch_size*patch_size*6,1)))
%             j = j+1;
%         end
%     end
%     if j==patch_size  
%         ii = ii+1;
%         HP= cat(2, HP, Hpatch);
%         LP= cat(2, LP, Lpatch);
%     end

end