
clear;clc;
%% 音频输入
[x, fs_far] = audioread('./audio/far_slice.wav');
[d, fs_near] = audioread('./audio/near_slice.wav');
far = x;
near = d;

%% kalman filter 参数初始化
L = 128;
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
    if rem(ii,2) == 0
        [e(ii), Rmu, h_hat] = kalman_filter_aec_realtime(X,near(ii+L),Rmu,w_cov,v_conv,IL,IP,h_hat);
    else
        e(ii) = near(ii+L) - X'*h_hat;
    end
    
end
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
% audiowrite("1024_kalman_filter.wav",e, fs_near);
% sound(e,16000)