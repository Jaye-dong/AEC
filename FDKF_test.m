clc;
clear;
[x, fs_far] = audioread('./audio/8kHz_far.wav');
[d, fs_far_echo] = audioread('./audio/8kHz_near.wav');
M = 32;beta=0.95;sgm2u=1e-2;sgm2v=1e-6;
%% FDKF
e = FDKF(x, d, M, beta, sgm2u, sgm2v);
e = [e;d(length(e)+1:end)];
% %% 写入txt
% fid = fopen("D:\code\m\AEC\C_results\e_m.txt","w");% 写入文件路径	
% for i=1:length(e)
% fprintf(fid,'%.16f, ',e(i));		% 按行输出
% end
% fclose(fid);		% a为要保存的变量名，记得更改!!!
%% 画图
plot(d,"c");
hold on;
plot(e,"b");
ylim([-1 1]);
title("FDKF AEC")
ylabel("amplitude");
xlabel("samples")