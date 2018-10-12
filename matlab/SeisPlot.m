function SeisPlot(M, fig, scale, varargin)
%Input : 
% M     - ��Ҫ���Ƶĵ����Σ�m * n��m��ʾ���ε��ţ� n��ʾʱ��ms��
% fig   - �Ƿ�ʹ���´��ڣ� 'old' 'new';
% scale - �Ƿ�Բ��ν�������;

% Author : Chirl Chen

if ~exist('fig', 'var')
    fig = {'figure', 'new'};
end
if ~exist('scale', 'var')
    scale = {'scale', 'no'};
end
corruptedSlice = squeeze(M)';
seisCorr = s_convert(corruptedSlice, 0, 1);
s_wplot(seisCorr, fig, scale, varargin{:});
end

