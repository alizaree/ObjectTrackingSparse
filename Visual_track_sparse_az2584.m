clc
clear all
%% read the dataset, 
name={'bolt', 'biker', 'kitesurf'};
name=name{3};
dirGT=['./data/',name,'/',name,'_ground.mat'];
dirIMG=['./data/',name,'/imgs/*img*.png'];
GT=load(dirGT);
imgList=dir(dirIMG);
imgID=[];
scale=1;
for i=1:length(imgList)
    imgID=[imgID, {imgList(i).name}];
end
imgName=imgID{1};
IMGadd=['./data/',name,'/imgs/',imgName];
temp=imresize(imread(IMGadd),scale);
video=uint8(zeros(size(temp,1),size(temp,2),size(temp,3),length(imgID)));
for i=1:size(video,4)
    imgName=imgID{i};
    IMGadd=['./data/',name,'/imgs/',imgName];
    temp=imresize(imread(IMGadd),scale);
    video(:,:,:,i)=temp;
end

%playvid(video)
%% box properties
Box_w=floor(40*scale);
Box_h=floor(90*scale);
%% Ground_truth video:

[hi, wi,Ich,nf]=size(video);
Video_True_Rec=makeRec(video,floor(GT.px*scale),floor(GT.py*scale),Box_h,Box_w,5);
%Video_True_Rec2=makeRecG(video,GT.px+15*randn(size(GT.px)),GT.py+15*randn(size(GT.py)),Box_h,Box_w,5);
%playvid(Video_True_Rec(:,:,:,28:40))

%% make template:
%templates is a u*k*n

nT=ceil(0.7*nf);
t1=makebox(GT.px(1)*scale,GT.py(1)*scale,Box_h,Box_w,hi, wi);
u=length(find(t1));
K=4;
templates=zeros(u,K,nT);
z_scale=[Box_h; Box_w];
for i=1:nT

    Pic=double(squeeze(video(:,:,:,i)))/255;
    Pic=add_feature(Pic);
    z=[GT.px(i)*scale; GT.py(i)*scale];
    mask=repmat(makebox(z(1),z(2),z_scale(1),z_scale(2), hi,wi),1,1,K);
    m=Pic(logical(mask));
    m=squeeze(reshape(m,[],K));% the picture now is u*k
    templates(:,:,i)=m;

end
%% find the segmantation for other frames for visual tracking:

nz=200;
lambda=1e-5;% regularization
eps=1e-4;% acceptable error for stoping optimization
etha=1/10;% likelyhood constant
delta=0.95;% forgetting factor for template weights
Dth=inf;
sigma_r=z_scale(1)/3.5;
sigma_c=z_scale(2)/2;
S=[sigma_r; sigma_c];
ro=0.5;
sigma= S*S'.*[1 ro;ro 1];
Z_predict=zeros(2,nf-nT);
Tmpl_Weights=ones(nT,1);
tmpl_thr=0.6;
z_prev=[GT.px(nT)*scale; GT.py(nT)*scale];
F=cell(1,nf-nT);
loss=cell(1,nf-nT);
load([name,'_frames_new.mat'])
for i=nT+1:nf
    Picture=double(squeeze(video(:,:,:,i)))/255;
    Picture=add_feature(Picture);
    [Z_predict(:,i-nT),tmpl_Coeffs,tmplDiff, F{i-nT},loss{i-nT}] = track_next_frame(Picture, z_prev,z_scale,templates,sigma, nz, lambda, [],eps, etha,Dth);
    save([name,'_frames_new.mat'],'Z_predict','F','loss');
    Tmpl_Weights=Tmpl_Weights.*tmpl_Coeffs.*delta;
    mask=repmat(makebox(Z_predict(1,i-nT),Z_predict(2,i-nT),z_scale(1),z_scale(2), hi,wi),1,1,K);
    m=Picture(logical(mask));
    m=squeeze(reshape(m,[],K));% the picture now is u*k
    if max(tmplDiff)/(norm(m,'fro')/K)>tmpl_thr
        [~,id]=max(tmplDiff);
        id
        templates(:,:,id)=m;
        Tmpl_Weights(id)=1;
    end
    z_prev=Z_predict(:,i-nT);
end



