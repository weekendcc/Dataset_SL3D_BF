%% phase2pc.m
%{ 
function: Convert the phase into a point cloud

Created: Sepetember 2024
Modified: Janurary 2025

input:
    LUT_path: The file path of the calibrate file
    phase_path: The file path of the phase file or the array of phase
    mask_path: The file path of the mask file or the array of mask
    zmin, zmax: Limitation of pointcloud
output:
    data: point cloud data 
    ptCloud: data converted to pointCloud 

Li Yiming <liyiming21@mails.tsinghua.edu.cn>
Tsinghua Shenzhen International Graduate School, Pengcheng Laboratory 
Li Zinan <lizn23@mails.tsinghua.edu.cn>
Tsinghua Shenzhen International Graduate School, Tsinghua Berkeley Shenzhen Institute
Chen Weikang <chenwk23@mails.tsinghua.edu.cn>
Tsinghua Shenzhen International Graduate School, Open FIESTA
%}
%%
function [data, ptCloud] = phase2pc(LUT_path, phase_path, mask_path, zmin, zmax)
    if nargin < 5
        zmin = 800;
        zmax = 1000;
    end
    LUT_Poly_Struct = load(LUT_path);
    LUT_Poly = LUT_Poly_Struct.LUT_Poly;
    [~, ~, im_w, im_h] = size(LUT_Poly);
    
    if size(phase_path, 1) == im_h-(600-448)
        phase = phase_path';
        phase = phase*400;
    elseif size(phase_path, 1) == im_w-(800-576)
        phase = phase_path;
        phase = phase*400;
    else
        phase = load(phase_path).output1';
        phase = phase*400;
        
    end
    
    
    if numel(mask_path) == 0
        mask = ones(im_w, im_h);
    elseif size(mask_path, 1) == im_h-(600-448)
        mask = mask_path';
    elseif size(mask_path, 1) == im_w-(800-576)
        mask = mask_path;
    else
        mask = load(mask_path).mask_save;
        mask = mask';
    end

    data=zeros(im_h*im_w,3);
    
    for v_idx=77:524
        for u_idx=113:688

            tempIdx = im_w*(v_idx-1)+u_idx;
            
            if mask(u_idx-112, v_idx-76) == 1   
                p1 = phase(u_idx-112,v_idx-76);
                p2 = p1*p1;
                p3 = p1*p2;
                ps = [1; p1;p2;p3];
                
                for k = 1:3
                    data(tempIdx,k) = LUT_Poly(k,:,u_idx,v_idx)*ps;
                end
            else
                data(tempIdx, :) = nan;
            end
        end
    end
    data(all(data==0,2),:) = []; % Remove all rows that are 0
    data(data(:, 3) > zmax | data(:, 3) < zmin, :) = [];

    data = data(all(~isnan(data), 2), :);    % Remove data that is nan
    ptCloud = pointCloud(data);

end