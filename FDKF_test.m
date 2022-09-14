clear;
[x, fs_far] = audioread('../audio/8kHz_far.wav');
[d, fs_near] = audioread('../audio/8kHz_near.wav');

mu = 0.04;
M = 4;
mu_unconst = 0.04;
select = 1;
[en, yk, W] = FDAF(d,x,mu,mu_unconst, M, select);
%sound(en,16000)
%sound(d,16000)
addpath 'D:\code\m\AEC\ERLE';
erle = calc_ERLE(en,d,M);
%plot(erle)
%nanmean(erle)

nanmean(erle)
%maxerle = max(nanmean(erle),maxerle)
%% 画图
plot(d,"c");
hold on;
plot(en,"b");
ylim([-1 1]);
title("NLMS AEC")
ylabel("amplitude");
xlabel("samples")

