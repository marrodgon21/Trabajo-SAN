function Data = GPS_in_2021(nombre_archivo)

% Funcion que se encarga de coger los datos nmea brutos guardados en un
% archivo de extensión .txt o .nmea y solo extraer las sentencias $GPGGA, 
% extrayendo su informacion relevante para nuestro problema, es decir,
% datos de latitud y longitud. Devuelve una structure GPS_Data.  
%
% Argumentos de entrada:
%
% nombre_archivo: nombre del archivo con los datos nmea escrito entre
% comillas con su extensión. Ej. 'mis_datos.txt'.

format long

NMEA = textread(nombre_archivo,'%s'); % Lectura de datos del archivo nmea. 
                                      % El formato es un "cell".

Bruto=cellfun(@nmealineread_2018,NMEA,'UniformOutput',false); 
                                      % Aplica la funcion nmealineread_2013 
                                      % a cada argumento del cell, devolvi-
                                      % endo una estructura con los datos 
                                      % de posición. 



% Este loop elimina los elementos de Bruto que no contienen datos extraídos
% por el programa nmealineread_2013, dejando un cell con solo los elementos 
% que nos interesan en formato struct. 

k = 1;
tama = size(Bruto);

while k <= tama(1)
    logic = isfield(Bruto{k},'posicion');
    if logic == 0
        Bruto(k) = [];
        borrado = 1;
    else 
        borrado = 0;
    end
    
    tam = size(Bruto);
    
    if k == tam(1)
        k = tama(1)+10;
    else
        if borrado == 1
            k = k;
        elseif borrado == 0
            k = k+1;
        end
    end
end

tamanofinal = size(Bruto);
Bruto(tamanofinal(1)) = [];

%Data = Bruto;

Bruto2=Bruto;
% Bruto3=struct;
y=0; w=1;
for j = 21:length(Bruto2)
    br = Bruto2{j,1}.posicion{1,1};
    if isnan(br)
        y=1;
    else
        Bruto3{w,1}.posicion{1,1} = Bruto2{j,1}.posicion{1,1};
        Bruto3{w,1}.posicion{2,1} = Bruto2{j,1}.posicion{2,1};
        Bruto3{w,1}.hora = Bruto2{j,1}.hora;
        w=w+1;
    end
end

Data=Bruto3;
