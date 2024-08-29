clear
clc
load t0
load t3-7
load force0
kt=ones(1,61)*200;
for i=1:33
    Ek(:,i)=kt+i-1;
end

X=rand(61,33,6);
X(:,:,1)=deflection0;
X(:,:,2)=deflection03;
X(:,:,3)=deflection04;
X(:,:,4)=deflection05;
X(:,:,5)=deflection06;
X(:,:,6)=deflection07;


Y=rand(61,33,6);
for i=1:6
    Y(:,:,i)=force0;
end

Z=rand(61,33,6);
Z(:,:,1)=0;
for i=2:6
    Z(:,:,i)=0.3+(i-1)*0.1;
end

E=rand(61,33,6);
for i=1:6
    E(:,:,i)=Ek;
end

x=reshape(X,[12078,1]);
y=reshape(Y,[12078,1]);
z=reshape(Z,[12078,1]);
E=reshape(E,[12078,1]);

figure(1)
scatter3(x, z, y, 100, E, 's', 'filled'); % 100表示点的大小，'filled'表示填充颜色
pbaspect([1 0.5 1])
xlim([0 1.1e-7]);
ylim([0 0.7]);
zlim([0 6e-7]);
colorbar; % 显示颜色条
shading flat;
caxis([200 233]);
xlabel('w(m)');
ylabel('T(N/m)');
zlabel('F(N)');
title('E-FEM');
view(15,30);
