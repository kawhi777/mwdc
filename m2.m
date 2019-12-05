clc;clear all; close all;
m = 10^5;
%Range of SNR values
snr_dB = [0:1:10];
for j=1:1:length(snr_dB)
    n_err=0;
    n_bits=0;
    while n_err<100
        inf_bits=round(rand(1,m));   %Generate sequence of binary bits
        x = -2*(inf_bits-0.5);    %BPSK constellation
        N0 = 1/10^(snr_dB(j)/10);    %Noise variance
        y =x+sqrt(N0/2)*(randn(1,length(x))+i*randn(1,length(x)));   %Send over gaussia link to receiver
        est_bits = y<0;    %Decsion making at receiver
        diff = inf_bits - est_bits;   %calculate bit errors
        n_err = n_err + sum(abs(diff));
        n_bits = n_bits + length(inf_bits);
    end
    BER(j) = n_err/n_bits;  %Calculate bit error rate
end
 
theoryBERAWGN = 0.5*erfc(sqrt(10.^(snr_dB/10)));
 
semilogy(snr_dB,BER,'or','LineWidth',2);
hold on;
semilogy(snr_dB,theoryBERAWGN,'blad-','LineWidth',2);
legend('AWGN simulated','AWGN theoretical');
axis([0 10 10^-5 0.5]);
xlabel('SNR(dB)');
ylabel('BER');
grid on;

