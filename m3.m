clc;clear all;close all;
N=5;
m=10^6;
ip=rand(1,m)>0.5;
BPSK=2*ip-1;
snr_dB=0:1:15;
snr=10.^(snr_dB/10);
L=2;
p_R_MRC=1/2-1/2*(1+1./snr).^(-1/2);
ber_MRC_ana=p_R_MRC.^2.*(1+2*(1-p_R_MRC));
n_err=zeros(1,length(snr_dB));
for p=1:N
    for q=1:length(snr_dB)
        No=1/sqrt(2)*[randn(L,m)+1j*randn(L,m)];
        h=1/sqrt(2)*[randn(L,m)+1j*randn(L,m)];
        symbol=kron(ones(L,1),BPSK);
        rec_vector=h.*symbol+10^(-snr_dB(q)/20)*No;
       dec_matrix=sum(conj(h).*rec_vector,1)./sum(h.*conj(h),1);
        ip_hat=real(dec_matrix)>0;
        n_err(q)=n_err(q)+size(find([ip-ip_hat]),2);
    end
end
ber_MRC_sim=n_err/(N*m);
semilogy(snr_dB,ber_MRC_ana,'-r*','LineWidth',2)
hold on;
semilogy(snr_dB,ber_MRC_sim,'ob','LineWidth',2)
legend('ber MRC sim','ber MRC ana');
xlabel('SNR(dB)');
ylabel('BER');

