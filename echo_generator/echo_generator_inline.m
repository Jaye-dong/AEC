clear;
% 远端信号
[far,fs] = audioread("far.wav");

M = 1001;
[B,A] = cheby2(4,20,[0.1, 0.7]);
Hd = dfilt.df2t([zeros(1,6) B], A);
H = filter(Hd,log(0.99*rand(1,M)+0.01).*...
    sign(randn(1,M)).*exp(-0.002*(1:M)));
H = H/norm(H)*4;
echo = 0.4*filter(H,1,far');
sound(far,16000)
sound(echo,16000)