function [best_z,tmpl_Coeffs,tmplDiff,best_F,best_loss] = track_next_frame1D(Picture, z_prev,z_scale,templates,sigma, nz, lambda, alpha,eps, etha,Dth)
% picture is u1*u2 * k and u = u1*u2 is the number of pixels and k is the number of
% features for each frame. templates is a u*k*n matrix where n is the
% number of templates. 
% of the center of 
%   Detailed explanation goes here
u1=size(Picture,1);
u2=size(Picture,2);
u=u1*u2;
n=size(templates,2);


% producing nz particles with a gaussian with sigma. and mean vector z_prev
Z=mvnrnd(z_prev, sigma,nz);
% for each z find the best decoder best on the rempelates. and return the
% error and tempelate Weights

best_z=z_prev;
max_likelyhood=0;
for i=1:size(Z,1)
    mask=repmat(makebox(floor(Z(i,1)),floor(Z(i,2)),z_scale(1),z_scale(2), u1,u2),1,1,1);
    m=Picture(logical(mask));
%    m=squeeze(reshape(m,[],K));% the picture now is u*k
    [F, loss]=fitSparseModel1D( m,templates, lambda, alpha, eps,Dth);
    W=F(1:n); % n
    R= norm(m-templates*W)^2;
    likelyhood=exp(-etha*R);
    if likelyhood>max_likelyhood
        best_z=Z(i,:)';
        tmpl_Coeffs=exp(W);
        tmplDiff=[];
        for j=1:n
            tmplDiff=[tmplDiff sum(vecnorm(m-templates(:,j)))^0.5];
        end
        best_F=F;
        best_loss=loss;
    end
   
end


end

