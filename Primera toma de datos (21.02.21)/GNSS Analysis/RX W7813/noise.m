% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% REPRESENTACIÓN SNR RX W7813 SOBRE SNR's GNSSLogger%

% Cógigo implementado con los datos del día 21/02/2021
% 'antena_FINAL.txt' (RX W7813)

function [SNR1_Ant, SNR2_Ant] = noise ()

datos         = importdata('antena_FINAL.txt');
[~,~,GPGSV,~] = nmea5 (datos);

SNR1_Ant = [];
for i = 1:length(GPGSV)
    snr1 = GPGSV(i).SNR1;
    if isempty(snr1)
        SNR1_Ant(i) = 0;
    else
        SNR1_Ant(i) = [snr1];
    end
end

SNR2_Ant = [];
for j = 1:length(GPGSV)
    snr2 = GPGSV(j).SNR2;
    if isempty(snr2)
        SNR2_Ant(j) = 0;
    else
        SNR2_Ant(j) = [snr2];
    end
end

openfig('SNR.fig');hold on;
plot(SNR1_Ant,'g');
%plot(SNR_2_Ant,'b');

end