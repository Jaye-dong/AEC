function [e, Rmu, h_hat] = kalman_filter_aec_realtime(X,near,Rmu,w_cov,v_conv,IL,IP,h_hat)

    % �������:
    %   far: Զ�ˣ�����������Ƶ�ź�
    %   near: ���ˣ���˷磩��Ƶ�ź�
    %   L: ÿ֡����
    %   P: ���P�������㣨Զ�˻���+�����������ź�
    %   delta: h(n)-h^(n)��ֵ
    %   L: ��������Э����
    %   w_cov: Զ����������
    %   v_conv: ������������
    % �������:
    %   kalman_filter_aec_out: ���ڿ������˲��Ļ���������������Ƶ�ź����

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

