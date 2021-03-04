% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% LECTOR DE ARCHIVOS .TXT%
% Usa la función "HelperParseGPSData.m" propia de MATLAB %

% Cógigo implementado con los archivos:
% - Día 21/02/2021: 'antena_FINAL.txt' - Comparación del RX W7813 con las
% señales obtenidas con GNSSLogger, analizándolas con GNSSAnalysis
% - Día 24/02/2021: 'aversicuela.txt' - Lo usa la función "compara.m" para
% cotejar los datos del RX W7814 con los de la App GalileoPVT

function [GPRMCk,GPGGAk,GPGSV,GPGSAk] = nmea5 (datos)

% Función que guarda en variables tipo "struct" los datos en formato nmea
% escritos en archivos .txt, siendo:

%datos = importdata('archivo.txt');

%% Contadores
k=1; k1=1; k2=1; k3=1;

%% Lectura de datos
for i = 2: length(datos) %debe empezar en la primera línea válida
    chr = datos{i,1};                         
    C   = textscan(chr,'%s','Delimiter',',');
    t   = strcmp(C{1,1}{1}, '$GPRMC');
    t1  = strcmp(C{1,1}{1}, '$GPGGA');
    t2  = strcmp(C{1,1}{1}, '$GPGSV');
    t3  = strcmp(C{1,1}{1}, '$GPGSA');
    
    if t == 1 %true
        [GPRMC,~,~,~] = HelperParseGPSData(datos{i,1});
        GPRMCk(k)     = GPRMC;
        k             = k + 1;
    elseif t1 == 1
        [~,GPGGA,~,~] = HelperParseGPSData(datos{i,1});
        GPGGAk(k1)    = GPGGA;
        k1            = k1 + 1;
    elseif t2 == 1
%         [~,~,GPVTG,~] = HelperParseGPSData(datos{i,1});
%         GPVTGk(k2)    = GPVTG;
%         k2            = k2 + 1;
        GPGSV(k2).MensajeID      = 'GSV';
        GPGSV(k2).NumTotalMens   = str2num(C{1}{2});
        GPGSV(k2).NumMens        = str2num(C{1}{3});
        GPGSV(k2).SatelitesVista = str2num(C{1}{4});
        %primer sat 
        GPGSV(k2).SatID1     = str2num(C{1}{5});
        GPGSV(k2).Elevacion1 = str2num(C{1}{6});
        GPGSV(k2).Azimut1    = str2num(C{1}{7});
        GPGSV(k2).SNR1       = str2num(C{1}{8});
%         %segundo sat
        GPGSV(k2).SatID2     = str2num(C{1}{9});
        GPGSV(k2).Elevacion2 = str2num(C{1}{10});
        GPGSV(k2).Azimut2    = str2num(C{1}{11});
        GPGSV(k2).SNR2       = str2num(C{1}{12});
%         %tercer sat - no lo tolera
%         GPGSV(k2).SatID3     = str2num(C{1}{13});
%         GPGSV(k2).Elevacion3 = str2num(C{1}{14});
%         GPGSV(k2).Azimut3    = str2num(C{1}{15});
%         GPGSV(k2).SNR3       = str2num(C{1}{16});
%         %cuarto sat - no lo tolera
%         GPGSV(k2).SatID4     = str2num(C{1}{17});
%         GPGSV(k2).Elevacion4 = str2num(C{1}{18});
%         GPGSV(k2).Azimut4    = str2num(C{1}{19});
%         GPGSV(k2).Checksum   = C{1}{20,1};
        k2                   = k2+1;

    elseif t3 == 1
        [~,~,~,GPGSA] = HelperParseGPSData(datos{i,1});
        GPGSAk(k3)    = GPGSA;
        k3            = k3 + 1;
    end
end
end