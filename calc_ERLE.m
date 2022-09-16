function ERLE = calc_ERLE(e, farSpeechEcho, framesize)
%CALC_ERLE 计算ERLE
%   e: 回声消除的结果
%   farSpeechEcho: 远端产生的回声
%   framesize: 帧长

%% 初始化计算所需变量
len = length(farSpeechEcho);
N = framesize;
% 在Far_echo前补0
FarSpeechEcho = zeros(len+N-1, 1);
FarSpeechEcho(N:end, 1) = farSpeechEcho;
% 在e前补0
E = zeros(len+N-1, 1);
E(N:end, 1) = e;
% 初始化ERLE
ERLE = zeros(len, 1);

%% 计算ERLE
for i = 1:len
    sum_far_echo = sum(FarSpeechEcho( i:i + N - 1).^2);
    sum_e = sum(E( i:i + N - 1).^2);
    ERLE(i) = 10 * log10(sum_far_echo / sum_e);
end

end

