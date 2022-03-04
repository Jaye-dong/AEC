clc;clear;
%% 模拟会议室冲击响应
fs = 16000;
M = fs/2 + 1;
frameSize = 2048;

% 切比雪夫2型滤波器
[B,A] = cheby2(4,20,[0.1 0.7]);

% 无限长度滤波器
impulseResponseGenerator = dsp.IIRFilter('Numerator', [zeros(1,6) B], ...
    'Denominator', A);

% 滤波器可视化工具fvtool(有滤波器的各种响应图）
% FVT = fvtool(impulseResponseGenerator);  % Analyze the filter
% FVT.Color = [1 1 1];

% 生成会议室响应滤波器
roomImpulseResponse = impulseResponseGenerator( ...
        (log(0.99*rand(1,M)+0.01).*sign(randn(1,M)).*exp(-0.002*(1:M)))');
roomImpulseResponse = roomImpulseResponse/norm(roomImpulseResponse)*4;
room = dsp.FIRFilter('Numerator', roomImpulseResponse');

% 画出会议室响应
% fig = figure;
% plot(0:1/fs:0.5, roomImpulseResponse);
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Room Impulse Response');
% fig.Color = [1 1 1];

%% 近端音频信号输入
% 输入内置的近端音频（音频是库自带的）
load nearspeech
% 注：以上语句也可以用如下语句代替
% [v, fs] = audioread("xxx.wav");

% 初始化实时音频播放器（用电脑设备播放音频）
player          = audioDeviceWriter('SupportVariableSizeInput', true, ...
                                    'BufferSize', 512, 'SampleRate', fs);
% 模拟信号源(从matlab工作区输入变量，一次输出一个frame大小）
nearSpeechSrc = dsp.SignalSource('Signal',v,'SamplesPerFrame',frameSize);

% 展示时域信号
nearSpeechScope = dsp.TimeScope('SampleRate', fs, ...
                    'TimeSpan', 35, 'TimeSpanOverrunAction', 'Scroll', ...
                    'YLimits', [-1.5 1.5], ...
                    'BufferLength', length(v), ...
                    'Title', 'Near-End Speech Signal', ...
                    'ShowGrid', true);

% 流处理循环（Stream processing loop）
while(~isDone(nearSpeechSrc))
    % 提取一帧采样点（Extract the speech samples from the input signal）
    nearSpeech = nearSpeechSrc();
    % 发送这一帧给电脑音频设备播放（Send the speech samples to the output audio device）
    player(nearSpeech);
    % 画出这一帧的信号（Plot the signal）
    nearSpeechScope(nearSpeech);
end
% 释放系统资源，让这个对象的输入和属性可以改变（此前绑定了近端信号）
release(nearSpeechScope);

