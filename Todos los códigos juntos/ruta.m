% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% REPRESENTACIÓN RUTA RX W7813 %

% Cógigo implementado con los datos del día 21/02/2021
% 'antena_FINAL.txt' (RX W7813)

function [lat,long] = ruta()
%% Lectura de datos
datos = importdata('antena_FINAL.txt'); 
k=1;

%% Creación de la estructura GPGGA con Lat y Long
for i = 1: length(datos)
    chr = datos{i,1};                         
    C   = textscan(chr,'%s','Delimiter',',');
    t   = strcmp(C{1,1}{1}, '$GPGGA');
    
    if t == 1 %true
        if full(str2num(C{1,1}{3,1}))
            GPGGA(k).Latitud       = 1e-2*str2num(C{1,1}{3,1});
            GPGGA(k).Longitud      = -1e-2*str2num(C{1,1}{5,1});
            k                      = k+1;
        end
    end
end

%% Ploteo
lat  = [GPGGA.Latitud];                     
long = [GPGGA.Longitud];

figure(1)
plot(long,lat,'g*'); grid
title('Ruta');

lat2=deg2km(lat);
long2=deg2km(long);
figure(2)
plot(long2,lat2,'b*'); grid

figure(3)
geoscatter(lat,long); grid

figure(4)
gx = geoaxes('Basemap','colorterrain');
geoplot(gx,lat,long,'m'); grid

end