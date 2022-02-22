function echo = echo_generator(far)
%ECHO_GENERATOR 此处显示有关此函数的摘要
% 输入参数:
%   far:远端音频信号
% 输出参数:
%   echo:远端音频信号产生的回声
    M = 1001;
    [B,A] = cheby2(4,20,[0.1, 0.7]);
    Hd = dfilt.df2t([zeros(1,6) B], A);
    H = filter(Hd,log(0.99*rand(1,M)+0.01).*...
        sign(randn(1,M)).*exp(-0.002*(1:M)));
    H = H/norm(H)*4;
    echo = 0.4*filter(H,1,far');
    echo = echo';
end


