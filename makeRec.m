function [Video_True_Rec] = makeRec(video,cx,cy,hb,wb,W)
[hi, wi,~,nf]=size(video);
Video_True_Rec=video;
mask=makebox(cx,cy,hb+2*W,wb+2*W,hi,wi)-makebox(cx,cy,hb,wb,hi,wi);
for i=1:nf
    mask=makebox(cx(i),cy(i),hb+2*W,wb+2*W,hi,wi)-makebox(cx(i),cy(i),hb,wb,hi,wi);
    Video_True_Rec(:,:,1,i)=squeeze(Video_True_Rec(:,:,1,i))+uint8(mask*inf);
    Video_True_Rec(:,:,2,i)=squeeze(Video_True_Rec(:,:,2,i)).*uint8(~mask);
    Video_True_Rec(:,:,3,i)=squeeze(Video_True_Rec(:,:,3,i)).*uint8(~mask);
end

end

