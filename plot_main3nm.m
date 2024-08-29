clear
clc
load t0
load t3-7
load force0
kt=ones(1,61)*200;
for i=1:33
    E(:,i)=kt+i-1;
end

figure(1);
colormap(parula);
subplot(231);pcolor(deflection03,force0,E);
title('T=0.3 N/m');
xlim([0 1.1e-7]);
caxis([200 232]);
shading flat;
colorbar;
hold on;
f=plot(deflection03(:,27),force0(:,1),  'k--', 'LineWidth', 1);
hold off;
uistack(f);

subplot(232);pcolor(deflection04,force0,E);title('T=0.4 N/m');
xlim([0 1.1e-7]);
caxis([200 232]);
shading flat;
colorbar;
hold on;
f=plot(deflection04(:,1),force0(:,1),  'k--',deflection04(:,12),force0(:,1),  'k--', 'LineWidth', 1);
hold off;
uistack(f);

subplot(233);pcolor(deflection05,force0,E);
shading flat;
colorbar;
xlim([0 1.1e-7]);
caxis([200 232]);
hold on;
f=plot(deflection05(:,8),force0(:,1),  'k--',deflection05(:,31),force0(:,1),  'k--',deflection05(:,18),force0(:,1),  'k--',...
    deflection05(:,25),force0(:,1),  'k--',deflection05(:,31),force0(:,1),  'k--','LineWidth', 1);
hold off;
uistack(f);
title('T=0.5 N/m');

subplot(234);pcolor(deflection06,force0,E);title('T=0.6 N/m');
xlim([0 1.1e-7]);
caxis([200 232]);
shading flat;
colorbar;
hold on;
f=plot(deflection06(:,28),force0(:,1),  'k--','LineWidth', 1);
hold off;
uistack(f);

subplot(235);pcolor(deflection07,force0,E);title('T=0.7 N/m');
xlim([0 1.1e-7]);
caxis([200 232]);
shading flat;
colorbar;
hold on;
f=plot(deflection07(:,24),force0(:,1),  'k--','LineWidth', 1);
hold off;
uistack(f);