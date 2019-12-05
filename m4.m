clc;close all;clear all;
m=10^3;
snr_dB=[0:1:20];
for j=1:1:length(snr_dB)
    n_err=0;
    n_bits=0;
    while n_err<100
        inf_bits=round(rand(1,m));
        x=-2*(inf_bits-0.5);
        No=1/10^(snr_dB(j)/10);
        n1=sqrt(No/2)*abs((randn(1,length(x))+i*randn(1,length(x))));
        n2=sqrt(No/2)*abs((randn(1,length(x))+i*randn(1,length(x))));
        h1=sqrt(0.5)*abs((randn(1,length(x))+i*randn(1,length(x))));
        h2=sqrt(0.5)*abs((randn(1,length(x))+i*randn(1,length(x))));
        y1=h1.*x+n1;
        y2=h2.*x+n2;
        y_equal=0.5*(y1+y2);
        est_bits=y_equal<0;
        diff=inf_bits-est_bits;
        n_err=n_err+sum(abs(diff));
        n_bits=n_bits+length(inf_bits);
    end
    BER(j)=n_err/n_bits;
end
semilogy(snr_dB,BER,'or-','LineWidth',2);
legend('Rayleigh EGC simulated','Rayleigh theoretical');
axis([0 20 10^-5 1]);
xlabel('SNR(dB)');
ylabel('BER');
grid on;
