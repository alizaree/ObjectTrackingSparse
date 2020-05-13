function [Pic] = add_feature(Pic, sigma)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('sigma','var') || isempty(sigma)
    sigma=5;
end
p=rgb2gray(Pic);
p2 = imgaussfilt(p,sigma);
E=edge(p2,'log');
Pic=cat(3,Pic,E);
end

