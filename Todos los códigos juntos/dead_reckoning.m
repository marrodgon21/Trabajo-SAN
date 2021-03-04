function [drlat,drlong] = dead_reckoning (waypoints,Ji,speeds,freqmuestra)


% Calculamos las distancias recorridas entre dos datos de poisición a 
% partir de los datos de velocidad y sumamos sus correspondientes contri-
% buciones a los cambios de latitud y longitud.

R_T = 6371*10^3;
h=1;

% Situamos el fix inicial, que siempre será el primer waypoint
format long
i=1;

for k = 2:length (waypoints)
     if waypoints(k,1)==0 && waypoints(k,2)==0
    i=k
    distancia_recorrida(k,1) = (speeds(i-4)/3600*1852) *...
                                    (1/freqmuestra); % Conversion kt a m/s
    speeds(i-3)=speeds(i-4);
    distancia_lat(k,1)  = distancia_recorrida(k,1)*cosd(Ji(i-4));
    distancia_long(k,1) = distancia_recorrida(k,1)*sind(Ji(i-4));
    Ji(i-3)=Ji(i-4);
    lat_avance(k,1)  = atand(distancia_lat(k,1)/R_T );
    long_avance(k,1) = atand(distancia_long(k,1)/R_T );
    
    drlat(k,1)=drlat(k-1,1)+lat_avance(k,1);
    drlong(k,1)=drlong(k-1,1)+long_avance(k,1);
     
     else
    drlat(i+1,1)  = waypoints(i+1,1);
         drlong(i+1,1) = waypoints(i+1,2);
    distancia_recorrida(h,1) = (speeds(h,1)/3600*1852) *...
                                    (1/freqmuestra); % Conversion kt a m/s
    
    distancia_lat(h,1)  = distancia_recorrida(h,1) * cosd( Ji(h,1) );
    distancia_long(h,1) = distancia_recorrida(h,1) * sind( Ji(h,1) );
    
    lat_avance (h,1)  = atand ( distancia_lat(h,1) / R_T );
    long_avance (h,1) = atand ( distancia_long(h,1) / R_T );
    
    drlat (k,1)  = drlat (k-1) + lat_avance (h,1);
    drlong (k,1) = drlong (k-1) + long_avance (h,1);
    
     end
   
    h=h+1;
end