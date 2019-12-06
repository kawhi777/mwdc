clc;close all;
clear all;
m=10^5;
snr_dB=[0:1:20];
for j=1:1:length(snr_dB)
    n_err=0;
    n_bits=0;
    while n_err<100
        inf_bits=round(rand(1,m));
        x=-2*(inf_bits-0.5);
        N0=1/10^(snr_dB(j)/10);
        h=1/sqrt(2)*[randn(1,length(x))+i*randn(1,length(x))];
        y=h.*x+sqrt(N0/2)*(randn(1,length(x))+i*randn(1,length(x)));
        y=y./h;
        est_bits= y<0;
        diff=inf_bits-est_bits;
        n_err=n_err+sum(abs(diff));
        n_bits=n_bits+length(inf_bits);  end
    BER(j)=n_err/n_bits;
end
snr=10.^(snr_dB/10);
theoryBer=0.5.*(1-sqrt(snr./(snr+1)));
theoryBerAWGN=0.5*erfc(sqrt(10.^(snr_dB/10)));
semilogy(snr_dB,theoryBer,'-','LineWidth',2);hold on;
semilogy(snr_dB,BER,'or','LineWidth',2);hold on;
semilogy(snr_dB,theoryBerAWGN,'blad-','LineWidth',2);
legend('Rayleigh Theoretical','Rayleigh Simulated','AWGN Theoretical');
axis([0 20 10^-5 0.5]);
xlabel('SNR (dB)');
ylabel('BER');
grid on;
