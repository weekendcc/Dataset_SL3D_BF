%% dl_output_recon.m
%{ 
function: read phase file, convert phase into a point cloud and show

Created: Sepetember 2024
Modified: Janurary 2025


%}
%% Set parameters
clear; clc; close all;

phase_root = './result';
mask_root = './mask';
save_dir = './pointcloud';
lut_path = './LUT_PSP.mat';

zmin = 850;
zmax = 950;
view1 = 0;
view2 = -80;
zoom1 = 1.2;

%% phase2pc
for k = 1
    phase_path = fullfile(phase_root, sprintf('%06d-results.mat', k));
    mask_path = fullfile(mask_root, sprintf('%06d-mask.mat', k));

    gt = load(phase_path).gt1';
    phase = load(phase_path).output1';

    [ptData, ptCloud] = phase2pc(lut_path, phase ,mask_path,zmin,zmax);
    [ptData_gt, ptCloud_gt] = phase2pc(lut_path, gt ,mask_path,zmin,zmax);

    figure(1)
    set(figure(1), 'Position', [30, 80, 750, 541]);
    pcshow(ptCloud);
    view(view1,view2)
    zoom(zoom1)
    axis("off")
    zlim([zmin,zmax])
    caxis([zmin,zmax])
    colormap("jet")

    figure(2)
    set(figure(2), 'Position', [30+750, 80, 750, 541]);
    pcshow(ptCloud_gt);
    view(view1,view2)
    zoom(zoom1)
    axis("off")
    zlim([zmin,zmax])
    caxis([zmin,zmax])
    colormap("jet")    
end
