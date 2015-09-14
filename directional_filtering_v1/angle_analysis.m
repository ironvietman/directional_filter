%% Directional rank max opening
%--------------------------------------------------------------------------
%
% Description: This program runs rank max openings in order to
% extract orientation information from images.
%   
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   25 Oct 2012
%
% Notes:
%   
%
% Input:
%   Image [MxN] Input image
%   ang_res [Scaler] Number of angles to use
%   LEN [Scalar] parameter for size of structuring element
%   r [Scalar] Activity paramenter for opening
%
% Output:
%   HSI_image [MxN] Output Image with orientation information
%
% Revision History:
%
%--------------------------------------------------------------------------

%% Clear all
clc; clear; close all; %clearing up the workspace and desktop

%% Set the type you want to analyze

% Type List
%-----------
% CA
% IH
% shape_large
% shape_medium
% shape_small
%-----------

TYPE = 'test'; 
mkdir(['output_data/' TYPE])

%% Parameters
LEN = 20;   % length of the structuring element
angle_res = 18;

%% Load Data
disp('Reading input files...')
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');

for imgid=1:length(datapath)
    
    img = imread(datapath{imgid});
    [x,y,Dim] = size(img); % get size of image
    

if Dim >=3
RGB = img; %Use these lines if you have colored image
img = rgb2gray(RGB(:,:,1:3));
end


 img = double(img)/max(max(double(img)));
% BW = image ~=0 ;
     img = adapthisteq(img);

[union_set ang] = directional_filter(img,angle_res,LEN,LEN);

    %% Get the Direction of fibers
    difference= zeros(x,y,length(ang));
    
    for i=1:length(ang)
    difference(:,:,i) = abs(union_set(:,:,i) - double(img));
    end
    
    [c loc] =min(difference,[],3);
    
    dir = zeros(x,y);
    
    for i=1:numel(loc)
    dir(i) = ang(loc(i))*180/pi;
    end
    
    gdir = max(union_set,[],3) - min(union_set,[],3);
    
    HSI_image= zeros(x,y,3);
    HSI_image(:,:,1) = (dir*pi/180)/(pi);
    HSI_image(:,:,2) = 1;
    HSI_image(:,:,3) = gdir/max(max(gdir));
    
    figure(2); imagesc(dir);
    
    HSI_image(:,:,1) = abs(HSI_image(:,:,1)-1);
    
    RGB_image = hsv2rgb(HSI_image); % Flip the angles so the colors match
   
    fig = figure(3); imagesc(RGB_image,'CDataMapping','scaled'); colormap(hsv); caxis([0 180]);
    colorbar; mycmap = get(fig,'Colormap'); set(fig,'Colormap',flipud(mycmap)); axis off; axis image ;
    
    figure(4); imagesc(img); colormap gray;
    figure(5); imagesc(HSI_image(:,:,3));
    %imagesc(max(union_set,[],3))
end

