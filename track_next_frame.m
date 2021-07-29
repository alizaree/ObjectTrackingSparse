function [best_z,tmpl_Coeffs,tmplDiff,best_F,best_loss] = track_next_frame(Picture, z_prev,z_scale,templates,sigma, nz, lambda, alpha,eps, etha,Dth)
% picture is u1*u2 * k and u = u1*u2 is the number of pixels and k is the number of
% features for each frame. templates is a u*k*n matrix where n is the
% number of templates. 
% of the center of 
%   Detailed explanation goes here
u1=size(Picture,1);
u2=size(Picture,2);
u=u1*u2;
K=size(Picture,3);
n=size(templates,3);


% producing nz particles with a gaussian with sigma. and mean vector z_prev
Z=mvnrnd(z_prev, sigma,nz);
% for each z find the best decoder best on the rempelates. and return the
% error and tempelate Weights

best_z=z_prev;
max_likelyhood=0;
runningtime=[];
for i=1:size(Z,1)
    mask=repmat(makebox(floor(Z(i,1)),floor(Z(i,2)),z_scale(1),z_scale(2), u1,u2),1,1,K);
    m=Picture(logical(mask));
    m=squeeze(reshape(m,[],K));% the picture now is u*k
    tic
    [F, loss]=fitSparseModel( m,templates, lambda, alpha, eps,Dth);
    runningtime=[runningtime;toc];
    W=F(1:n,:); % n*K
    theta=1/K;
    R=0;
    for k=1:K
        R=R+ theta*norm(m(:,k)-squeeze(templates(:,k,:))*W(:,k))^2;
    end
    likelyhood=exp(-etha*R);
    if likelyhood>max_likelyhood
        best_z=round(Z(i,:)');
        tmpl_Coeffs=sum(exp(W),2);
        tmplDiff=[];
        for j=1:n
            tmplDiff=[tmplDiff sum(theta*vecnorm(m-squeeze(templates(:,:,j))))^0.5];
        end
        best_F=F;
        best_loss=loss;
    end
   
end


end

