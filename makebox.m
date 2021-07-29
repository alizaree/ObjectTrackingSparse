function [template] = makebox(cx,cy,hb,wb,hi,wi)
%cx,cy= center of box/ hb,hw=hight and width of box/ hi,wi= hight and width
%of image. x is the width and y is the hight
%  Ali Zare email: az2584@columbia.edu, ask for permission to use. algorithm based on Single and Multiple Object Tracking Using a Multi-Feature
%Joint Sparse Representation 
template=zeros(hi,wi);
x1=round(cx)-floor((wb+1)/2)+1;
x2=round(cx)+floor((wb)/2);
y1=round(cy)-floor((hb+1)/2)+1;
y2=round(cy)+floor((hb)/2);

if x2>wi
    x2=wi;
    x1=x2-wb+1;
end

if x1<1
    x1=1;
    x2=wb+x1-1;
end

if y2>hi
    y2=hi;
    y1=y2-hb+1;
end

if y1<1
    y1=1;
    y2=hb+y1-1;
end

template(y1:y2,x1:x2)=1;
end

