clear;
clc;

N=1;
M=2;
y0=3000;
y02=10;
c(1)=0.1;
c(2)=0.005;
X=5/c(1);
Y(1,1)=y0;
Y(2,1)=y02;
T(1)=0;
a0=0;
am=0;
n=1;

while T(n)<5
    for k=1:2
    h(1)=X*Y(k,n);
    h(2)=(1/2)*Y(k,n)*(Y(k,n)-1);
    for i=1:M
        a0=a0+h(i)*c(i);
    end
    tau=(1/a0)*log(1/rand);
    r2=rand;
    for j=1:M
        mu=j;
        am=am+h(j)*c(j);
        if am>=(r2*a0)
            break
        end
    end
    a0=0;
    am=0;
    if mu==1
        Y(k,n+1)=Y(k,n)+1;
    elseif mu==2
        Y(k,n+1)=Y(k,n)-2;
    end
    end
    T(n+1)=T(n)+tau;
    n=n+1;
end

plot(T,Y(1,:))
grid on
xlim([0 5])
xlabel('T')
ylabel('Y')
hold on
plot(T,Y(2,:))