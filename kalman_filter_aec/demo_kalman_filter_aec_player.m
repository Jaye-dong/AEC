
clear;clc;
%% 音频输入
[far, fs_far] = audioread('./audio/far_slice.wav');
[near, fs_near] = audioread('./audio/near_slice.wav');

%% 初始化变量和播放音频工具
%帧长
frameSize = 80;

% 初始化实时音频播放器（用电脑设备播放音频）
fs = fs_far;
player          = audioDeviceWriter('SupportVariableSizeInput', true, ...
                                    'BufferSize', 512, 'SampleRate', fs);
% 模拟信号源(从matlab工作区输入变量，一次输出一个frame大小）

nearSpeechSrc = dsp.SignalSource('Signal',near,'SamplesPerFrame',frameSize);
% 展示时域信号
nearSpeechScope = dsp.TimeScope('SampleRate', fs, ...
                    'TimeSpan', 20, 'TimeSpanOverrunAction', 'Scroll', ...
                    'YLimits', [-1.5 1.5], ...
                    'BufferLength', length(near), ...
                    'Title', 'Near-End Speech Signal', ...
                    'ShowGrid', true);
                
                
%% kalman filter 参数初始化
L = frameSize;
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
Far = zeros(length(far)+L,1);
Far(1:length(far),1) = far;

% stride
stride = 1;
%% 流处理循环
ii = 1;

while(ii<length(far)-L+1)
    % 提取一帧近端采样点
    nearSpeech = nearSpeechSrc();
    % 提取两帧远端采样点
    X = Far(ii:ii+2*frameSize-1);

    for jj = 0:frameSize-1
       if rem(jj, stride) == 0  % 如果有stride的情况
           [e(ii+jj), Rmu, h_hat] = kalman_filter_aec_realtime(X(1+jj:jj+L),nearSpeech(1+jj),Rmu,w_cov,v_conv,IL,IP,h_hat);
       else
            e(ii+jj) = nearSpeech(1+jj) - X(1+jj:jj+L)'*h_hat;
       end
    end
    % 提取AEC处理后的一帧
    e_L = e(ii:ii+L-1);
    % 发送这一帧给电脑音频设备播放（Send the speech samples to the output audio device）
    player(e_L');
    % 画出这一帧的信号（Plot the signal）
    nearSpeechScope(nearSpeech);
    ii = ii + L;
end

release(nearSpeechScope);


%% 计算ERLE
len = length(far);
N = L;
erle = zeros(1,len);
Near = zeros(1,len+N-1);
Near(1,N:end) = near;
er = e;
for ii = N:len-1
    sumd = sum(Near(1,ii-N+1:ii).^2);
    sume = sum(er(1,ii-N+1:ii).^2);
    erle(ii-N+1) = 10*log10(sumd/sume);
    if(erle(ii-N+1)<0)
        erle(ii-N+1) = 0;
    end
end
mean(erle)
plot(erle)
title("ERLE")
%% 播放效果
% sound(e,16000)