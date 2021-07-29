function [] = myvidwriter(buffer, name)
video = VideoWriter(name,'MPEG-4'); 
video.FrameRate = 10; 
open(video)
for i = 1:size(buffer,4)    
    img =squeeze(buffer(:,:,:,i)); 
    writeVideo(video,img); 
end
close(video);
end