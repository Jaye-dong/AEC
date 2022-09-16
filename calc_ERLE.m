function ERLE = calc_ERLE(e, farSpeechEcho, framesize)
%CALC_ERLE ����ERLE
%   e: ���������Ľ��
%   farSpeechEcho: Զ�˲����Ļ���
%   framesize: ֡��

%% ��ʼ�������������
len = length(farSpeechEcho);
N = framesize;
% ��Far_echoǰ��0
FarSpeechEcho = zeros(len+N-1, 1);
FarSpeechEcho(N:end, 1) = farSpeechEcho;
% ��eǰ��0
E = zeros(len+N-1, 1);
E(N:end, 1) = e;
% ��ʼ��ERLE
ERLE = zeros(len, 1);

%% ����ERLE
for i = 1:len
    sum_far_echo = sum(FarSpeechEcho( i:i + N - 1).^2);
    sum_e = sum(E( i:i + N - 1).^2);
    ERLE(i) = 10 * log10(sum_far_echo / sum_e);
end

end

