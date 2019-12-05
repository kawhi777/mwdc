clc;
close all;
clear all;
% Number of information bits
m=10;
f_data=1; % DATA FREQUENCY
f_chip= 7; % LENGTH OF CHIP SEQUENCE
fc=210; % RELATIVE CARRIER FREQUENCY
fs=fc*3; % SAMPLING FREQUENCY
N=fs/f_chip;% CODING RATE
%Range of SNR values
snr_dB = [0:2:26];
for jj=1:1:length(snr_dB) n_err=0;
n_bits = 0;
while n_err < 100
% Generate sequence of binary bits
inf_bits=round(rand(1,m));
PN_sequence=round(rand(11,1)); % GENERATION OF PN SEQUENCE
%Spread the information bits with PN sequence
j=1;
for i=1:m
    for k=j:j+f_chip-1
        msg_spread(k)=inf_bits(i);
    end;
    msg_spread(j:(j+f_chip-1))=xor(msg_spread(j:(j+f_chip-1))',PN_sequence(1:f_chip));
   j=f_chip*i+1;
end; len_msg_spr=length(msg_spread);
% MODULATING THE SPREAD MESSAGE
% BPSK Constellation symbols
x=-2*(msg_spread-0.5);
% Noise variance
N0=1/10^(snr_dB(jj)/10);
% Send over Gaussian Link to the receiver
y=x+sqrt(N0/2)*(randn(1,length(x))+i*randn(1,length(x)));
% Decision making at the Receiver
msg_demod=y<0;
% CORRELATING WITH THE PN SEQUENCE
j=1;
    for i=1:m
        msg_demod(j:(j+f_chip-1))=xor(msg_demod(j:(j+f_chip-1))',PN_sequence(1:f_chip)); j=f_chip*i+1;
    end;
% DESPREADING THE RECEIVED SIGNAL
j=1;
    for i=1:m sl=0;
        for k=j:j+f_chip-1
         sl=sl+msg_demod(k);
         end;
        if (sl>=6)
        msg_demod_rec(i)=1;
        else
            msg_demod_rec(i)=0;
        end
    j=f_chip*i+1;
    end;
% Calculate Bit Errors
diff=inf_bits-msg_demod_rec;
n_err=n_err+sum(abs(diff));
n_bits=n_bits+length(inf_bits);
end
% Calculate Bit Error Rate
BER(jj)=n_err/n_bits
end
semilogy(snr_dB,BER,'or-','LineWidth',2); 
legend('AWGN Simulated');
axis([0 26 10^-4 1]);
xlabel('SNR (dB)');
ylabel('BER'); grid on;

