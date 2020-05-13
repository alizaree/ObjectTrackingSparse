function [D] = findD1D(m, templates, Dth)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
n=size(templates,2);
u=size(templates,1);
d=zeros(n,1);
D=zeros(n,1);
for i=1:n
        d(i)=norm(m-templates(:,i));
        if d(i)>Dth
            D(i)=exp(50);% instead of inf
        else
            D(i)=d(i);
        end
        

end


    D=D./max(d);

end

