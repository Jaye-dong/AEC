clc;
clear;
[far,fs_far] = audioread('./audio/8kHz_far.wav');
[near, fs_far_echo] = audioread('./audio/8kHz_near.wav');

%% 加窗分帧
frameSize = 1024;
window = ones(frameSize,1);                                                       % 矩形窗
Far = enframe(far, window);
Near = enframe(near, window);
e = enframe(zeros(length(near),1), window);

e_whole = zeros(length(near),1);


%% FDKF enframed
% Initial parameters
M = 32;beta=0.95;sgm2u=1e-2;sgm2v=1e-6;
    R(1:M+1,1) = sgm2v;                                                     % update each time       
    H_temp = zeros(M + 1, 1);H = complex(H_temp);                           % update each time      
    P(1:M+1,1) = sgm2u;                                                     % update each time   
    x_old = zeros(M,1);                                                     % update each time
    
for i=1:length(Near(:,1))
    [e(i,:), R, H, P, x_old] = FDKF_enframed(Far(i,:)', Near(i,:)', M, beta, sgm2u, sgm2v, R, H, P, x_old);
    e_whole(1+(i-1)*frameSize:i*frameSize) = e(i,:);                        % put together
end

%% 画图
plot(near,"c");
hold on;
plot(e_whole,"b");
ylim([-1 1]);
title("FDKF enframed AEC")
ylabel("amplitude");
xlabel("samples")

