%% Directional rank max opening Segmentation
%--------------------------------------------------------------------------
%
% Description: This program implements rank max openings in order to
% segment an image
%   
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   5 Dec 2012
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
%   buses [MxN] Output Image with segmented objects
%   num [Scaler] Number of segmented objects
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

TYPE = 'bus'; 
mkdir(['output_data/' TYPE])

%% Parameters
LEN = 14;   % length of the structuring element (even only)
LEN2 =24;
angle_res = 10;

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
%    img = adapthisteq(img);

[union_set ang] = directional_filter2(img,angle_res,LEN,LEN);
[union_set2 ang] = directional_filter2(img,angle_res,LEN2,LEN2);

% C = union_set(:,:,1);
% D = union_set2(:,:,1);
% for i=1:length(ang)-1
% C = union(C,  union_set(:,:,i+1),'rows');
% D = union(D,  union_set2(:,:,i+1),'rows');
% end

C = imreconstruct(max(union_set,[],3), img);
D = imreconstruct(max(union_set2,[],3), img);

% C = max(union_set,[],3);
% D = max(union_set2,[],3);

%  C = imdilate(sum(union_set,3);
%  D = sum(union_set2,3);
  


figure(1);imshow(C);
figure(2);imshow(D);
figure(3);imagesc(C-D);

buses = (C-D) >.3;
figure(4);imagesc(buses);
end

[L num] = bwlabel(buses);

clc;
fprintf('Number of Buses: %d\n', num);


