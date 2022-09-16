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
e_whole = far;

%% FDKF VSNPFBLMS enframed
% VSNPFBLMS Initial parameters
mu=0.5; psi=0.1; alpha=0.995; vsFlag=0; eta=0.5;
M_vs=1;Lw = 64;
% FDKF Initial parameters
M = 1024;beta=0.95;sgm2u=1e-2;sgm2v=1e-6;
    R(1:M+1,1) = sgm2v;                                                     % update each time       
    H_temp = zeros(M + 1, 1);H = complex(H_temp);                           % update each time      
    P(1:M+1,1) = sgm2u;                                                     % update each time   
    x_old = zeros(M,1);                                                     % update each time

N=Lw; P=N/M_vs;
wF=zeros(2*M_vs,P); % update each time 
xF=zeros(2*M_vs,P); % update each time 
front = 1;
for i=1:length(Near(:,1))
    
    [e_back, R, H, P, x_old] = FDKF_enframed(Far(i,:)', Near(i,:)', M, beta, sgm2u, sgm2v, R, H, P, x_old);
    [e_front,wF,xF] = VSNPFBLMS_enframed(Far(i,:)', Near(i,:)',Lw,M_vs,mu,psi,alpha,eta,vsFlag,wF,xF);
    
    
    if front == 0
        e(i,:)=e_back;
    else
        e(i,:)=e_front;
    end
    if calc_ERLE(e_back, Near(i,:)', 256) > calc_ERLE(e_front, Near(i,:)', 256)
        front = 0;
    end
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
title("FDKF-VSNPFBLMS enframed AEC")
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
title("FDKF-VSNPFBLMS enframed AEC")
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