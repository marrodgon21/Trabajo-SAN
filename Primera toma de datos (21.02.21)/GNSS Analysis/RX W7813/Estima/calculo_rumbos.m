function [Ji] = calculo_rumbos (waypoints)

j=1;
for i = 2:length (waypoints)
    
    cos_alpha(j,1) = sind(waypoints(i-1,1))*sind(waypoints(i,1))+...
                      cosd(waypoints(i-1,1))*cosd(waypoints(i,1))*...
                       cosd(waypoints(i,2)-waypoints(i-1,2)) ;
    alpha(j,1)     = acosd (cos_alpha(j,1));
    
    % Cálculo de rumbos a partir de las coordenadas geográficas de los 
    % waypoints. Como hicimos anteriormente vamos a calcular rumbos de rutas
    % ortodrómicas ya que aunque el rumbo en estas rutas sea variable, para los
    % recorridos tan cortos que hacemos, esta variación de rumbos no se va a 
    % hacer notable en cuanto a errores obtenidos.

    cos_Ji(j,1) = (cosd(waypoints(i-1,1))*sind(waypoints(i,1))-...
                      cosd(waypoints(i,1))*sind(waypoints(i-1,1))*...
                       cosd(waypoints(i,2)-waypoints(i-1,2)))/...
                        sind(alpha(j,1)) ;
    
    % CORRECCIÓN: Si B está al Oeste(W) de A, tendremos que corregir el
    % rumbo obtenido anteriormente: Ji'(º) = 360º-arccos(cos_Ji).
    
    if waypoints(i,2)<waypoints(i-1,2)
        Ji_a_corregir(j,1) = acosd(cos_Ji(j,1));
        Ji(j,1) = 360 - Ji_a_corregir(j,1);
    else
        Ji(j,1) = acosd (cos_Ji(j,1));
    end
    
    j=j+1;

end

indrumbos=find(isnan(Ji)); 

Ji(indrumbos)=0;