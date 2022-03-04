clear;clc;
%% 音频输入
[x, fs_far] = audioread('./audio/far_slice.wav');
[d, fs_near] = audioread('./audio/near_slice.wav');
far = x;
near = d;
ssin = near;
rrin = far;


N = 256;
len = length(ssin);
y = zeros(1,len);
w = zeros(1,N);
RRin = zeros(1,len+N-1);
SSin = zeros(1,len+N-1);
er = zeros(1,len);
RRin(1,N:end) = rrin;
SSin(1,N:end) = ssin;
u = 0.05;
for ii = N:len+N-1
    y(ii-N+1) = sum(RRin(1,ii-N+1:ii).*w);
    er(ii-N+1) = ssin(ii-N+1) - y(ii-N+1);
    w = w + u*RRin(1,ii-N+1:ii)*er(ii-N+1)/(sum(RRin(1,ii-N+1:ii).^2)+0.001);
end

erle = zeros(1,len);
for ii = N:len-1
    sumd = sum(SSin(1,ii-N+1:ii).^2);
    sume = sum(er(1,ii-N+1:ii).^2);
    erle(ii-N+1) = 10*log10(sumd/sume);
    if erle(ii-N+1) < 0
       erle(ii-N+1) = 0;
    end
       
end
% sound(er,16000)
max(erle)
plot(erle)
mean(erle)