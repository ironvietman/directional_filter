function  [union_set ang] = directional_filter2(img,ang_res,LEN,r)
%% Directional rank max opening 
%--------------------------------------------------------------------------
%
% Description: This program implements a bank of rank max directional 
% openings
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
%   union_set [MxN] Output filtered image
%
% Revision History:
%
%--------------------------------------------------------------------------
    [x,y] = size(img); % get size of image
% BW = image ~=0 ;
%    img = adapthisteq(img);

min_angle = 0; % smallest angle
max_angle = pi; % Biggest angle
ang = (min_angle:pi/(2*ang_res):max_angle)'; % Col vector of angles with spacing pi/(2*K)


% ang=linspace(0,170,ang_res); % Get the angle resolution
D = length(ang);
union_set= zeros(x,y,D);
    
lambda = LEN+1;
r = r+1;
%% Perform Filtering
    for i = 1:D
        kernel = kernel_build(LEN, ang(i)) % Get structuring element
%         se = strel('line',LEN,ang(i)); % line structuring element
%         lambda = length(se.getneighbors);
        if r ==lambda 
%             IMG = imopen(img,se); % if r = lambda
IMG = imopen(img,kernel); % if r = lambda
        else
%          IMG = ordfilt2(  ordfilt2(img,lambda-r+1,se.getnhood)  ,lambda,se.getnhood);
IMG = ordfilt2(  ordfilt2(img,lambda-r+1,kernel)  ,lambda,kernel);
        end
         union_set(:,:,i) = min(img,IMG); 
%    union_set(:,:,i) = bitand(uint8(img*255),uint8(IMG*255));
%    union_set(:,:,i) = union_set(:,:,i)/max(max(union_set(:,:,i)));
%         BW = min(BW,IMG); 
%         BW = BW + IMG;
        figure(1); imagesc(union_set(:,:,i));
    end
