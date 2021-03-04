% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% REPRESENTACIÓN RUTA RX W7813 %
% Utiliza los códigos modificados del Trabajo "GPS: Representación cartográfica y
% navegación a la estima con distintos receptores." - Curso 2019/2020 %

% Cógigo implementado con los datos del día 21/02/2021
% 'antena_FINAL.txt' (RX W7813)

function ruta2 ()
%% Llamada a funciones
nombre_archivo = 'antena_FINAL.txt';
freqmuestra=1;
Data = GPS_in_2021(nombre_archivo);
[waypoints,gpslat,gpslong] = calculo_waypoints_2021 (Data);
[speeds] = calculo_velocidades (waypoints,freqmuestra);
[Ji] = calculo_rumbos (waypoints);
[drlat,drlong] = dead_reckoning (waypoints,Ji,speeds,freqmuestra);
[kflat,kflong]= kf_drr(drlat, drlong, gpslat,gpslong);

%% Latitud
kflat2  = []; kflong2 = [];
kflat2  = kflat(2:length(kflat),1);
kflong2 = kflong(2:length(kflong),1);

%% Longitud
drlat2  = []; drlong2 = [];
drlat2  = drlat(2:length(drlat),1);
drlong2 = drlong(2:length(drlong),1);

%% ploteo
figure('PaperSize',[20.99999864 29.69999902]);
geoplot(gpslat,gpslong,'*'); hold on
geoplot(kflat2,kflong2,'g*'); hold on
geoplot(real(drlat2),real(drlong2),'r*'); grid
geobasemap satellite
title('Ruta')
legend('Sin KF','Con KF','Nav. Estima')

