% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% REPRESENTACIÓN ANTENA Y GALILEOPVT %
% Parte de código "decodingcsv.m" del Trabajo "Galileo" - Curso 2019/2020 %

% Código implementado con datos del día 24/02/2021
% 'aversicuela.txt' (RX W7813) & 'deb24.csv' (GalileoPVT)

function [NumSat_Ant,PDOP_Ant]= compara ()
%% Llamada a funciones
datos      = importdata('aversicuela.txt');
archivoCSV = ('deb24.csv');
[GPRMCk,GPGGAk,GPGSV,GPGSAk] = nmea5 (datos);
[coordenadas_Gal,altitud_Gal,timeUTC_Gal,NumeroSats_Gal,PDOP_Gal,Vel_Gal,coordenadas_GPS,altitud_GPS,timeUTC_GPS,NumeroSats_GPS,PDOP_GPS,Vel_GPS] = decodercsv(archivoCSV);

%% representa número de satelites
NumSat_Ant = [GPGGAk.NumSatelites];

figure(1);  
plot(NumeroSats_Gal,'r'); hold on; 
plot(NumeroSats_GPS,'b'); hold on; 
plot(NumSat_Ant,'g');

title('Número de satelites utilizados');
legend({'Galileo','GPS','RX W7813'},'Location','northeast')
xlabel('s'); ylabel('N.º Satélites'); grid

%% representa PDOP
PDOP_Ant = zeros(1,length(GPGSAk));
for j = 1:length(GPGSAk)
    pdop_conv = GPGSAk(j).PDOP;
    if isempty(pdop_conv)
       PDOP_Ant(j) = 0;
    else
       PDOP_Ant(j) =  [pdop_conv];
    end
end

figure(2);
plot(PDOP_Gal,'r'); hold on; 
plot(PDOP_GPS,'b'); hold on; 
plot(PDOP_Ant,'g');

title('Comparativa de PDOP');
legend({'Galileo','GPS','RX W7813'},'Location','northeast');
xlabel('s'); ylabel('PDOP'); grid

%% representa PDOP vs numero de satelites
figure(3);
plot (NumeroSats_Gal,PDOP_Gal,'r*');hold on;
plot (NumeroSats_GPS,PDOP_GPS,'b*');hold on;
% plot (NumSat_Ant,PDOP_Ant,'g*');

title('Influencia del N.º Satélites sobre el PDOP');
legend({'Galileo','GPS','RX W7813'},'Location','northeast');
xlabel('Satélites');ylabel('PDOP'); grid

%% representa altitud
str     = [GPGGAk.Altitude];
L       = textscan(str,'%s','Delimiter','m');
Alt_Ant = zeros(1,length(GPGGAk));
for p = 1:length(L{1,1}) %un poco fullero
%     alt_emp = GPGGAk(p).Altitude;
%     if isempty(alt_emp)
%        Alt_Ant(p) = 0;
%     else
%        Alt_Ant(p) =  [str2num(L{1,1}{p})];
%     end
    Alt_Ant(p) = [str2num(L{1,1}{p})];
end

figure(4);
plot (altitud_Gal,'r');hold on; 
plot(altitud_GPS,'b');hold on; 
plot(Alt_Ant,'g');

title('Comparativa de altitud');
legend({'Galileo','GPS','RX W7813'},'Location','northeast');
xlabel('s'); ylabel('m'); grid

%% representa velocidad
st      = [GPRMCk.SOG];
F       = textscan(st,'%s','Delimiter',{'knots'});
Vel_Ant = zeros(1,length(GPRMCk));
for q = 1:length(F{1,1}) %F{1,1}{1}
    vel_emp = GPRMCk(q).SOG;
    if isempty(vel_emp)
       Vel_Ant(q) = 0;
    else
       Vel_Ant(q) = [str2num(F{1,1}{q})];
    end
%     Vel_Ant(q) = [str2num(F{1,1}{q})];
end

figure(5);
plot(Vel_Gal,'r');hold on;
plot(Vel_GPS,'b');hold on;
plot(Vel_Ant,'g'); grid

title('Comparativa de velocidad');
legend({'Galileo','GPS','RX W7813'},'Location','northeast');
xlabel('s'); ylabel('kt');
end