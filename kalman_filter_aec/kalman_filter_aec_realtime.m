function [e, Rmu, h_hat] = kalman_filter_aec_realtime(X,near,Rmu,w_cov,v_conv,IL,IP,h_hat)

    % 输入参数:
    %   far: 远端（扬声器）音频信号
    %   near: 近端（麦克风）音频信号
    %   L: 每帧长度
    %   P: 最近P个采样点（远端回声+近端噪声）信号
    %   delta: h(n)-h^(n)的值
    %   L: 过程噪声协方差
    %   w_cov: 远端噪声方差
    %   v_conv: 近端噪声方差
    % 输出参数:
    %   kalman_filter_aec_out: 基于卡尔曼滤波的回声消除消除后音频信号输出

   %% kalman filter
   
   Rm = Rmu + w_cov * IL; 
   Re = X' * Rm * X + v_conv * IP;
   K = Rm * X / (Re + 0.03);
   e = near - X' * h_hat;
   %h_old = h_hat;
   h_hat = h_hat + K * e;
   Rmu = (IL - K * X') * Rm;
   %delta_h = h_hat - h_old;
   %w_cov = alpha * w_cov + (1 - alpha) * (delta_h' * delta_h);
   %Rex = lambda_v * Rex + (1 - lambda_v) * X * e;
   %sigma_x = lambda_v * sigma_x + (1 - lambda_v) * X(end) * X(end);
   %sigma_e = lambda_v * sigma_e + (1 - lambda_v) * e * e;
   %v_conv = sigma_e - (1/(sigma_x + 0.03) * (Rex' * Rex));
   
end

