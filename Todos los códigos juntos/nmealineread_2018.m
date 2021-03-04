function [data]  =  nmealineread_2018(nline)


caso = 0;
k = 1;

validos = cell([1 2]);
validos{1} = '$GPGGA';


while k < 3
    

    
    if (strfind(nline,validos{k})) < 5

        caso = k;
        k = 5;
        
    else 
       
        k = k + 1;
    
    end
       
end



if caso == 0
    
    %fprintf(1,'\n\tNo es una sentencia valida NMEA $GPGGA  -  %s ...\n',nline);
    data = 0;
    return
    
end



Posicion = 0;
Hora=0;

if caso == 1
   
    %$GPGGA,083541.000,3724.6781,N,00600.0938,W,1,07,1.4,2.8,M,49.7,M,,0000*49
    
    datos_GPGGA = textscan(nline, '%s%f%f%s%f%s%f%f%f%f%s%f%s%s','Delimiter',',');
    
    Posicion = cell(2);
    Posicion{1} = datos_GPGGA{3}/100;
    Posicion{3} = datos_GPGGA{4};
    Posicion{2} = datos_GPGGA{5}/100;
    Posicion{4} = datos_GPGGA{6};
    
    %Posicion, pause
    
    %primera fila: 1a columna: latitud (numérico), 2a columna: N o S.
    %segunda fila: 1a columma: longitud (numérico), 2a columna: E o W.
            
    Hora = [floor(datos_GPGGA{2}/100)]; %hhmm
    
    %Hora, pause
    
end
            
        
data = struct('posicion', {Posicion}, 'hora' , {Hora}); 
% Resultados en formato estructura. Para acceder a los resultados escribir
% "data.***" donde *** es el nombre que se ha escrito entre comillas en la 
% definición. Por ejemplo, para ver datos de hora, escribir data.hora   