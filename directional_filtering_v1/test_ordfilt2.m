%% Testing Rank Filters
%--------------------------------------------------------------------------
%
% Description: This program is used to test the implementation of the
% method ordfilt2. 
%   
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   19 Oct 2012
%
% Notes:
%   
%
% Input:
%   Images [MxN]
%
% Output:
%   MSE [Scalar] Mean Squared Error of images
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

%% Load Data
% disp('Reading input files...')
% TRAIN_INPUT = ['include/input_' TYPE '.txt'];
% datapath = textread(TRAIN_INPUT,'%s');
% 
% for imgid=1:length(datapath)
% 
% 
% end

%% About Ordfilt2
% From inspecting the code of ordfilt2, we can see that it calls the
% functino ordf. This is a mex file that has the algorithm similar to the
% code on A Fast 2D alg for Median paper. This is dedused from looking at
% the documentation of ordfilt2. Therefore we can use ordfilt2 as the rank
% filter implemented in Directional filtering. 

%% Medfilt2 and ordfilt2
% We can see that medfilt2 uses the ordfilt2. ordfilt2 is a rank filter and
% if we make the rank = n+1/2, where n is the number of elements in the
% Structure then we get a median filter
I = imread('eight.tif');
J = imnoise(I,'salt & pepper',0.02);
K = medfilt2(J);
imshow(J), figure, imshow(K)

B = ordfilt2(J,(9+1)/2,ones(3));

MSE1 = sum(sum((abs(double(B))-abs(double(K))).^2)/(numel(K)))


%% Dilate and max rank
% This examples uses a maximum filter with a [5 5] neighborhood. This is 
% equivalent to imdilate(image,strel('square',5)). max rank filter is where
% we choose the rank to be the last element in the structure. from this we
% can gather that an erode is a min rank filter.

A = imread('snowflakes.png');
B = ordfilt2(A,25,true(5));
figure, imshow(A), figure, imshow(B)

C = imdilate(A,strel('square',5));

MSE1 = sum(sum((abs(double(B))-abs(double(C))).^2)/(numel(B)))

%% Erode and min rank
% We can see that the two different methods are similar, but not exactly
% the same unlike the dilate method. The implementations for Dilate and
% Erode are diferent form the 
D = ordfilt2(A,1,true(5));
figure, imshow(A), figure, imshow(D)

E = imerode(A,strel('square',5));


MSE1 = sum(sum((abs(double(D))-abs(double(E))).^2)/(numel(D)))

%% Open and min/max rank
r = 25;

F = ordfilt2(  ordfilt2(A,25-r+1,true(5))  ,25,true(5));
F = min(A,F);
figure, imshow(A), figure, imshow(F)

G = imopen(A,strel('square',5));
figure, imshow(G)
MSE1 = sum(sum((abs(double(G))-abs(double(F))).^2)/(numel(F)))

