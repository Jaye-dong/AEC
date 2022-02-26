
clear;clc;
%% 音频输入
[x, fs_far] = audioread('./audio/far_slice.wav');
[d, fs_near] = audioread('./audio/near_slice.wav');
far = x;
near = d;

%% 播放远端信号
%sound(far, 16000);

%% 播放近端信号
sound(near, 16000);

%% kalman filter 参数初始化
L = 32;
P = 1;
delta = 0.0001;
w_cov = 0.01;
v_conv = 0.1;

%% 执行kalman filter
res = kalman_filter_aec(far, near, L, P, delta, w_cov, v_conv);

%% 播放处理后效果
sound(res, 16000);