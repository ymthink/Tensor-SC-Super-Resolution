function [Xh, Xl] = rnd_smp_patch(dataRoad, patch_size, num_patch, upscale)

load(dataRoad);
fg = fg(1:300,1:200,:);
[Xh, Xl] = sample_patches2(fg, patch_size, num_patch, upscale);



