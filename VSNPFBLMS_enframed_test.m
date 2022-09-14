clc;
clear;
[far,fs_far] = audioread('./audio/8kHz_far.wav');
[near, fs_far_echo] = audioread('./audio/8kHz_near.wav');

%% 加窗分帧
frameSize = 1024;
window = ones(frameSize,1);                                                       % 矩形窗
% window = hamming(frameSize);
Far = enframe(far, window);
Near = enframe(near, window);
e = enframe(zeros(length(near),1), window);

e_whole = zeros(length(near),1);


%% VSNPFBLMS enframed
% Initial parameters
mu=0.5; psi=0.1; alpha=0.995; vsFlag=1; eta=0.5;
M=1;Lw = 32;


N=Lw; P=N/M;
wF=zeros(2*M,P); % update each time 
xF=zeros(2*M,P); % update each time 

for i=1:length(Near(:,1))
    [e(i,:),wF,xF] = VSNPFBLMS_enframed(Far(i,:)', Near(i,:)',Lw,M,mu,psi,alpha,eta,vsFlag,wF,xF);
    e_whole(1+(i-1)*frameSize:i*frameSize) = e(i,:);                        % put together
end

%% 画图
plot(near,"c");
hold on;
plot(e_whole,"b");
ylim([-1 1]);
title("VSNPFBLMS enframed AEC")
ylabel("amplitude");
xlabel("samples")

