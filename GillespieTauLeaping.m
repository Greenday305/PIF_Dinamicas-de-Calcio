%%%% Gillespie Tau Leaping %%%% 

clear;
clc;

N=3; %Número de componentes
M=4; %Número de reacciones

%Vector X de numero de moléculas de cada componente
X=zeros(1,N);
X(1)=1e5;
X(2)=0;
X(3)=0;

%Constantes de cada reacción
c=zeros(1,M);
c(1)=1;
c(2)=0.002;
c(3)=0.5;
c(4)=0.04;

%Matriz de reacciones v
v=zeros(M,N);
v(1,:)=[-1,0,0];
v(2,:)=[-2,1,0];
v(3,:)=[2,-1,0];
v(4,:)=[0,-1,1];

%Vector de kj's
k=zeros(1,M);

%Lambda
lambda=zeros(1,N);

%Vector de a's
a=zeros(1,M);

%Matriz de b's
b=zeros(M,N);

%Epsilon
eps=zeros(1,N);

%Taus
taus=zeros(1,M);

a0=0;
d=0;
ep=0.03;

T(1)=0;
n=1;
while T(n)<30
    %%%% Calcular tau %%%%
    b(1,1)=c(1);
    b(2,1)=2*c(2)*X(n,1);
    b(3,2)=c(3);
    b(4,2)=c(4);
    
    a(1)=c(1)*X(n,1);
    a(2)=c(2)*(X(n,1)^2); %%Duda en esta
    a(3)=c(3)*X(n,2);
    a(4)=c(4)*X(n,2);
    
    a0=sum(a);
    
    for j=1:M
        eps=eps+a(j)*v(j,:);
    end
    
    for j=1:M
        for i=1:N
            d=d+eps(i)*b(j,i);
        end
        d=abs(d);
        taus(j)=ep*a0/d;
    end
    d=0;
    eps=zeros(1,N);
    tau=min(taus);
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%% Calcular las demás cosas %%%%
    for j=1:M
        k(j)=poissrnd(a(j)*tau);
        lambda=lambda+k(j)*v(j,:);
    end
    T(n+1)=T(n)+tau;
    X(n+1,:)=X(n,:)+lambda;
    lambda=zeros(1,N);
    a0=0;
    n=n+1;
end
figure()
plot(T,X(:,1),'ko')
legend('X(1)')
figure()
plot(T,X(:,2),'o')
hold on
plot(T,X(:,3),'o')
legend('X(2)','X(3)')
disp('Número de pasos: ')
disp(n)