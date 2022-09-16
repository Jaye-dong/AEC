clc;
clear;
[x, fs_far] = audioread('./audio/far.wav');
[d, fs_far_echo] = audioread('./audio/near.wav');

%% VSNPFBLMS
mu=0.5; psi=0.1; alpha=0.995; vsFlag=1; eta=0.5;
M=1;opt.Lw = 64;

[e,~] = VSNPFBLMS(x,d,opt.Lw,M,mu,psi,alpha,eta,vsFlag);
e = [e;d(length(e)+1:end)];

%% 画图
plot(d,"c");
hold on;
plot(e,"b");
ylim([-1 1]);
title("VSNPFBLMS AEC")
ylabel("amplitude");
xlabel("samples")