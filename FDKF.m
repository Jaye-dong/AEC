function e = FDKF(x, d, M, beta, sgm2u, sgm2v)
%FDKF Frequence Domain Kalman Filter
%   input:
%       x: farSpeech
%       d: MicroPhone signal
%       M: blocksize
%   output:
%       e: AEC result
    Q = sgm2u;           
    R(1:M+1,1) = sgm2v;          
    H_temp = zeros(M + 1, 1);H = complex(H_temp);         
    P(1:M+1,1) = sgm2u;         
                 
    window = hanning(M);          
    x_old = zeros(M,1);           
                 
    num_block = floor(length(x)/M);            
    e = zeros(num_block * M,1);            
                 
    for n = 1:num_block            
        x_n = [x_old; x(1+(n-1)*M:n*M)];           
        d_n = d(1+(n-1)*M : n*M);       
        x_old = x(1+(n-1)*M : n*M);        
                 
        X_n = v_rfft(x_n);        
                 
        y_n_temp = v_irfft(H .* X_n); y_n = y_n_temp(M+1:end);
        e_n = d_n - y_n;        
                 
        e_fft = [zeros(M,1); e_n .* window];        
        E_n = v_rfft(e_fft);        
                 
        R =  R * beta  +   (abs(E_n).^2) * (1.0 - beta);        
        P_n = P + Q *(abs(H));        
        K = P_n .* conj(X_n)./ (X_n .* P_n .* conj(X_n) + R);        
        P = (1.0 - K .* X_n) .* P_n;        
                 
        H = H + K .* E_n;       
        h = v_irfft(H);        
        h(M+1:end) = 0;       
        H = v_rfft(h);        
                 
        e(1+(n-1)*M : n*M) = e_n;        
    end
end

