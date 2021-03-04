function [speeds] = calculo_velocidades (waypoints,freqmuestra)

% En esta función vamos a calcular las velocidades correspondientes a los
% tramos entre dos waypoints consecutivos. Para ello tomamos un valor de
% frecuencia de muestreo que iremos variando para el estudio a estima del
% navegador y calcularemos las distancias ortodrómicas(camino más corto 
% entre dos puntos de la superficie terrestre) entre los puntos de paso.

R_T = 6371*10^3;
j=2;

for i=2:length (waypoints)
    
    cos_alpha(j,1) = sind(waypoints(i-1,1))*sind(waypoints(i,1))+...
                      cosd(waypoints(i-1,1))*cosd(waypoints(i,1))*...
                       cosd(waypoints(i,2)-waypoints(i-1,2)) ;
    alpha(j,1)    = acosd (cos_alpha(j,1));                 % alpha [º]
    dist_ort(j,1) = alpha(j,1) * pi/180 * R_T;              % dist_ort [m]
    
    distancia(j,1) = dist_ort(j,1) / 1852;                  % distancia [nmi]
    speeds(j,1)    = distancia(j,1) * (freqmuestra * 3600); % speeds [kt]
    
    j=j+1;

end

% indspeeds=find(isnan(speeds));
% 
% speeds(indspeeds)=0;
% for i=2:length (waypoints)
%     if speeds(i)>200
%         speeds(i)=0;
%     else 
%     end
%     
      

end