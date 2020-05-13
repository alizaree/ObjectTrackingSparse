function [D] = findD(m, templates, Dth)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
n=size(templates,3);
K=size(templates,2);
u=size(templates,1);
d=zeros(n,K);
D=zeros(n,K);
for i=1:n
    for k=1:K
        d(i,k)=norm(m(:,k)-squeeze(templates(:,k,i)));
        if d(i,k)>Dth
            D(i,k)=exp(50);% instead of inf
        else
            D(i,k)=d(i,k);
        end
        
    end
end

for k=1:K
    D(:,k)=D(:,k)./max(d(:,k));
end
end

