clc;
clear;
[far,fs_far] = audioread('./audio/far.wav');
[near, fs_far_echo] = audioread('./audio/near.wav');

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
M=1;Lw = 64;


N=Lw; P=N/M;
wF=zeros(2*M,P); % update each time 
xF=zeros(2*M,P); % update each time 

for i=1:length(Near(:,1))
    [e(i,:),wF,xF] = VSNPFBLMS_enframed(Far(i,:)', Near(i,:)',Lw,M,mu,psi,alpha,eta,vsFlag,wF,xF);
    e_whole(1+(i-1)*frameSize:i*frameSize) = e(i,:);                        % put together
end

%% ERLE指标
% 画图
figure(1)
subplot(2,1,1)
plot(near,"c");
hold on;
plot(e_whole,"b");
ylim([-1 1]);
title("VSNPFBLMS enframed AEC")
ylabel("amplitude");
xlabel("samples")

% 计算ERLE
ERLE = calc_ERLE(e_whole, near, 256);

subplot(2,1,2)
plot(ERLE)
ylim([0,50])
ylabel("ERLE");
xlabel("samples")
for i = 1:length(ERLE)
    if ERLE(i) > 50
        ERLE(i) = 0;
    end
    if ERLE(i) < 0
        ERLE(i) = 0;
    end
    if isnan(ERLE(i))
        ERLE(i) = 0;
    end
end
mean(ERLE)
% sound(e_whole,16000)


%% 指标SuppFactor
% 画图
figure(2)
subplot(2,1,1)
plot(near(400000:end),"c");
hold on;
plot(e_whole(400000:end),"b");
ylim([-1 1]);
title("VSNPFBLMS enframed AEC")
ylabel("amplitude");
xlabel("samples")

% 计算SuppFactor
SuppFactor = calc_SuppFactor(e_whole, near, 1024);
subplot(2,1,2)
plot(SuppFactor(400000:end))
ylim([0,10])
ylabel("SuppFactor");
xlabel("samples")

for i = 1:length(SuppFactor)
    if SuppFactor(i) > 1
        SuppFactor(i) = 1;
    end
    if SuppFactor(i) < 0
        SuppFactor(i) = 0;
    end
    if isnan(SuppFactor(i))
        SuppFactor(i) = 0;
    end
end

mean(SuppFactor(400000:end))


