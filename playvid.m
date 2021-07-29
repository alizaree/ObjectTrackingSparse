function [] = playvid(video)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure()
for i=1:size(video,4)
imshow(squeeze(video(:,:,:,i)));
end
end

