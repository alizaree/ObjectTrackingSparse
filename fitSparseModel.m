function [F,loss] = fitSparseModel(m,templates, lambda, alpha, eps,Dth)
% m is u*k
%   templates is a u*k*n matrix where n is the
loss=[];
K=size(templates,2);
u=size(templates,1);
n=size(templates,3);
Etempl=zeros(u,K,u);
for i=1:u
    Etempl(i,:,i)=1;
end


%d=[1./findD(m, templates, Dth); ones(u,K)];
B=cat(3, templates,Etempl); % u*k*(n+u)

if ~exist('alpha','var') || isempty(alpha)
    % Digital frequency w/ fs=100 Hz
%     alpha=[];
%     for k=1:K
%         alpha = [alpha; 1/norm(squeeze(B(:,k,:)),'fro')^2];
%     end
alpha=[];
for k=1:K
    alpha=[alpha;1/norm(squeeze(B(:,k,:)),'fro')^2];
end
%m=m/m_frob^2;
end
% sigmaP=std(m,[],1)/sqrt(B_forb2);% choose the approprate value
% sigmaE=std(m,[],1)/sqrt(B_forb2);% choose the approprate value
f=[];
for k=1:K
    sigmaP=std(m,[],1)/norm(squeeze(B(:,k,:)));% choose the approprate value
    sigmaE=std(m,[],1)/norm(squeeze(B(:,k,:)));% choose the sapproprate value
    f=[f,[sigmaP(k)*randn(n,1); sigmaE(k)*randn(u,1)]];
end
loss=[loss; objective(m, templates, f, Etempl, lambda, Dth)];
%t=0;
cond=1;
fn=f;
% v=f;
% dw2=zeros(3,1);
% RMSProp=1;
% RMSProp2=1e-8;
while cond
    % find f and v
    for k=1:K
        dw=alpha(k)*squeeze(B(:,k,:))'*(squeeze(B(:,k,:))*f(:,k)-m(:,k));
%         dw2(k)=RMSProp*dw2(k)+(1-RMSProp)*norm(dw)^2;
        fn(:,k)=(f(:,k)-dw); %d(:,k).*(f(:,k)-RMSProp2*dw./sqrt(dw2(k)));
    end
    % soft thresholding
    for i=1:n
        fn(i,:)=max(1-norm(lambda*alpha./fn(i,:)),0)*fn(i,:); %max(1-norm(RMSProp2*lambda*alpha./(fn(i,:).*sqrt(dw2))),0)*fn(i,:); % check later
    end
%     gamma=2/(2+t);
%     gammaP1=2/(3+t);
%     v=fn+(gammaP1*(1-gamma)/gamma)*(fn-f);
%     t=t+1;
%     for k=1:K
%         f(:,k)=fn(:,k)./norm(fn(:,k))*norm(m(:,k))/norm(squeeze(B(:,k,:)));
%     end
    f=fn;
%     alpha=RMSProp*alpha;
        
    loss=[loss; objective(m, templates, f, Etempl, lambda, Dth)];
%     if loss(end)-loss(end-1)>0
%         alpha=RMSProp2*alpha;
%     end
    
    if abs(loss(end)-loss(end-1))<=eps || length(loss)>1000
        cond=0;
    end
%     for k=1:K
%         fn(:,k)=d(:,k).*(v(:,k)-alpha(k)*(-1*squeeze(B(:,k,:))'*m(:,k)+squeeze(B(:,k,:))'*squeeze(B(:,k,:))*v(:,k)));
%     end
%     % soft thresholding
%     for i=1:n
%         fn(i,:)=max(1-norm(lambda*alpha./fn(i,:)),0)*fn(i,:); % check later
%     end
%     gamma=2/(2+t);
%     gammaP1=2/(3+1);
%     v=fn+(gammaP1*(1-gamma)/gamma)*(fn-f);
%     t=t+1;
%     f=fn;
%         
%     loss=[loss; objective(m, templates, f, Etempl, lambda, Dth)];
%     if abs(loss(end)-loss(end-1))<=eps
%         cond=0;
%     end
end
F=f;%*m_frob;
    
end

