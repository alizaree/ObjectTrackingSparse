function [F] = objective1D(m, templates, f, Etempl, lambda, Dth)
%UNTITLED6 Summary of this function goes here
%   templates is a u*k*n matrix where n is the ans Etempl is u*k*u
n=size(templates,2);
u=size(templates,1);
D=findD1D(m, templates, Dth);
B=cat(2, templates,Etempl); % u*k*(n+u)
p1=0;

    p1=p1+norm(m-B*f)^2;


p2=0;
for i=1:n
    DD=diag(D(i));
    p2=p2+norm(DD*f(i));
end
for i=n+1:n+u
    
    p2=p2+norm(f(i));
    
end

F=0.5*p1+lambda*p2;

end


