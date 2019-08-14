%% estimate A based on Retinex Theory
% I, input image
% A, air color
function [ A ] = dp_airLight( I, r )
    if nargin < 2
        r = ceil(0.05*min(size(I,1),size(I,2)));
    end
    A = dp_atmosphere(im2double(I), imerode(min(I,[],3),strel('disk',r)));
end

