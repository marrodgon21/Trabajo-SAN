% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% LECTOR DE ARCHIVOS .CSV - Lee datos parcialmente %
% Parte de código "decodingcsv.m" del Trabajo "Galileo" - Curso 2019/2020 %

% Código implementado con datos del día 24/02/2021
% 'aversicuela.txt' (RX W7813) & 'deb24.csv' (GalileoPVT)

function [coordenadas_Gal,altitud_Gal,timeUTC_Gal,NumeroSats_Gal,PDOP_Gal,Vel_Gal,coordenadas_GPS,altitud_GPS,timeUTC_GPS,NumeroSats_GPS,PDOP_GPS,Vel_GPS] = decodercsv(archivoCSV)
% Este algoritmo extrae los parametros de mayor interes de un fichero
% .csv generado por la app GalileoPVT. Ejemplo de llamada a
% la funcion: decodingcsv('Log_RAW_20200206_210546.csv');
close all; clc

[~,~,data] = xlsread(archivoCSV);
[m,~]      = size(data);

%% Inicialización de variables
coordenadas_Gal = [];   coordenadas_GPS = [];
altitud_Gal     = [];       altitud_GPS = [];
timeUTC_Gal     = [];       timeUTC_GPS = [];
NumeroSats_Gal  = [];    NumeroSats_GPS = [];
PDOP_Gal        = [];          PDOP_GPS = [];
Vel_Gal         = [];           Vel_GPS = [];
for i=146:m %la informacion útil comienza en la línea 15a del archivo csv
    %lee linea a linea el archivo:
    C = textscan(data{i},'%s','Delimiter',',');
    %true/false: comapara ambas cadenas de caracteres, 1 si coinciden:
    tf = strcmp(C{1,1}{1}, 'CalculatedPVT');
    if tf == 1
        if strcmp(C{1,1}{3,1},'Galileo')
            lat             = str2num(C{1,1}{6,1});
            long            = str2num(C{1,1}{7,1});
            coordenadas_Gal = [coordenadas_Gal;lat, long];           %lat y long en grados
            altitud_Gal     = [altitud_Gal,str2num(C{1,1}{8,1})];    %altitud expresada en metros
            timeUTC_Gal     = [timeUTC_Gal,str2num(C{1,1}{13,1})];
            NumeroSats_Gal  = [NumeroSats_Gal,str2num(C{1,1}{4,1})]; %num de satelites utilizados
            PDOP_Gal        = [PDOP_Gal, str2num(C{1,1}{12,1}) ];
            
            velN = str2num(C{1,1}{9,1});
            velE = str2num(C{1,1}{10,1});
            velD = str2num(C{1,1}{11,1});
            nVel_Gal  = norm([velN velE velD]);
            Vel_Gal = [Vel_Gal, nVel_Gal]; 
            
        else if strcmp(C{1,1}{3,1},'GPS')
                lat             = str2num(C{1,1}{6,1});
                long            = str2num(C{1,1}{7,1});
                coordenadas_GPS = [coordenadas_GPS;lat, long];
                altitud_GPS     = [altitud_GPS,str2num(C{1,1}{8,1})];
                timeUTC_GPS     = [timeUTC_GPS,str2num(C{1,1}{13,1})];
                NumeroSats_GPS  = [NumeroSats_GPS,str2num(C{1,1}{5,1})];
                PDOP_GPS        = [PDOP_GPS, str2num(C{1,1}{12,1}) ];
                
            velN = str2num(C{1,1}{9,1});
            velE = str2num(C{1,1}{10,1});
            velD = str2num(C{1,1}{11,1});
            nVel_GPS  = norm([velN velE velD]);
            Vel_GPS = [Vel_GPS, nVel_GPS];
            end
        end
        
    end
    
end
end