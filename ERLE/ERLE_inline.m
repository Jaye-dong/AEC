clear;clc;
%% 音频输入
[far, fs_far] = audioread('./audio/far_slice.wav');
[near, fs_near] = audioread('./audio/near_slice.wav');
[res, er_near] = audioread('./audio/res_slice.wav');

%% 初始化计算所需变量
len = length(far);
N = 256;
Near = zeros(1,len+N-1);
Near(1,N:end) = near;
erle = zeros(1,len);

%% 计算ERLE
for ii = N:len-1
    sum_near = sum(Near(1,ii-N+1:ii).^2);
    sum_res = sum(er(1,ii-N+1:ii).^2);
    erle(ii-N+1) = 10*log10(sum_near/sum_res);
    if(erle(ii-N+1)<0)
        erle(ii-N+1) = 0;
    end
end

%% 画图
plot(erle)

%% ERLE最大值
max(erle)

%% ERLE平均值
mean(erle)