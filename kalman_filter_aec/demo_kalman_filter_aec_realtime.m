
clear;clc;
%% 音频输入
[x, fs_far] = audioread('./audio/far_slice.wav');
[d, fs_near] = audioread('./audio/near_slice.wav');
far = x;
near = d;

%% kalman filter 参数初始化
L = 256;
P = 1;
delta = 0.0001;
w_cov = 0.01;
v_conv = 0.1;

e = zeros(1,length(far));
h = zeros(L, 1);
h_hat = zeros(L, 1);
IL = eye(L);
IP = eye(P);

Rm = zeros(L, L);
Rmu = delta * IL;

for ii = 1:length(far)-L
    X = far(ii:ii+L-1);%%取出其中一帧
    [e(ii), Rmu, h_hat] = kalman_filter_aec_realtime(X,near(ii+L),Rmu,w_cov,v_conv,IL,IP,h_hat);
    
end

sound(e,16000)