%%%% Distribución binomial %%%%

clear;
clc;
n=100;
p=0.2;
x=1:1:n;
y=(factorial(n) ./ (factorial(x) .* factorial(n-x))).*(p.^x).*((1-p).^(n-x));
plot(x,y,'o')
binornd(n,p)