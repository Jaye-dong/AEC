clear;clc;
%% 音频输入
[far, fs_far] = audioread('./audio/far_slice.wav');
[near, fs_near] = audioread('./audio/near_slice.wav');
len = length(far);

N = 256;
erle = zeros(1,len);

Near = zeros(1,len+N-1);
Near(1,N:end) = near;
er = eCopy;
for ii = N:len-1
    sumd = sum(Near(1,ii-N+1:ii).^2);
    sume = sum(er(1,ii-N+1:ii).^2);
    erle(ii-N+1) = 10*log10(sumd/sume);
    if(erle(ii-N+1)<0)
        erle(ii-N+1) = 0;
    end
end

max(erle)
plot(erle)
mean(erle)
%% 画图
figure(1);
subplot(3,1,1);
plot(res);
subplot(3,1,2);
plot(e);
subplot(3,1,3);
plot(eCopy);