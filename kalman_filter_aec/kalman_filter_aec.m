function kalman_filter_aec_out = kalman_filter_aec(far, near, L, P, delta, w_cov, v_conv)
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

    % 本地变量:
    %   sigma_e: 构造平滑近端噪声的因子
    %   sigma_x: 构造平滑近端噪声的因子
    %   alpha: 用于远端噪声方差w的平滑因子
    %   lambda_v: 用于近端噪声方差v的平滑因子
    sigma_e = 0.001;
    sigma_x = 0.001;
    alpha = 0.9;
    lambda_v = 0.999;

    h = zeros(L, 1);
    h_hat = zeros(L, 1);
    IL = eye(L);
    IP = eye(P);

    Rm = zeros(L, L);
    Rmu = delta * IL;
    Rex = 1e-3 * ones(L, 1);

    frame_num = floor(length(far) / L);
    e = zeros(1,length(far));
    %% kalman filter主循环
    for i = 1:length(far) - L
       X = far(i:i+L-1);%%取出其中一帧
       Rm = Rmu + w_cov * IL; 
       Re = X' * Rm * X + v_conv * IP;
       K = Rm * X / (Re + 0.03);
       e(i) = near(i+L) - X' * h_hat;
       h_old = h_hat;
       h_hat = h_hat + K * e(i);
       Rmu = (IL - K * X') * Rm;


       delta_h = h_hat - h_old;
       w_cov = alpha * w_cov + (1 - alpha) * (delta_h' * delta_h);
       Rex = lambda_v * Rex + (1 - lambda_v) * X * e(i);
       sigma_x = lambda_v * sigma_x + (1 - lambda_v) * X(end) * X(end);
       sigma_e = lambda_v * sigma_e + (1 - lambda_v) * e(i) * e(i);
       v_conv = sigma_e - (1/(sigma_x + 0.03) * (Rex' * Rex));

    end
    kalman_filter_aec_out = e;
end
