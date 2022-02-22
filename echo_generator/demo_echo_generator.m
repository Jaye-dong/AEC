clear;
% 远端信号
[far,fs] = audioread("far.wav");
echo = echo_generator(far);
sound(echo,16000)

