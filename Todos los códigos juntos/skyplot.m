% ----- SAN - CURSO 2020/21 ----- %
% COMPARACIÓN DE DISTINTOS GNSS's %

% REPRESENTACIÓN SKYPLOT RX W7813 %

% Cógigo implementado con los datos del día 21/02/2021
% 'antena_FINAL.txt' (RX W7813)

function skyplot()

datos         = importdata('antena_FINAL.txt');
[~,~,GPGSV,~] = nmea5 (datos);

%% satélite 31 
valuetofind = GPGSV(1).SatID1; %31
posID1 = find(arrayfun(@(s) ismember(valuetofind, s.SatID1), GPGSV));
elevacion1 = []; azimut1=[];
for i =1:length(posID1)
    elevacion1(i) =  GPGSV(posID1(i)).Elevacion1; %elevacion del sat nº31
    azimut1(i) = GPGSV(posID1(i)).Azimut1;
end

%% satélite 29
valuetofind2 = GPGSV(2).SatID1;
posID2 = find(arrayfun(@(s) ismember(valuetofind2, s.SatID1), GPGSV));
elevacion2 = []; azimut2=[];
for i =1:length(posID2)
    elevacion2(i) =  GPGSV(posID2(i)).Elevacion1;
    azimut2(i) = GPGSV(posID2(i)).Azimut1;
end

%% satélite 20
valuetofind3 = GPGSV(3).SatID1;
posID3 = find(arrayfun(@(s) ismember(valuetofind3, s.SatID1), GPGSV));
elevacion3 = []; azimut3=[];
for i =1:length(posID3)
    elevacion3(i) =  GPGSV(posID3(i)).Elevacion1;
    azimut3(i) = GPGSV(posID3(i)).Azimut1;
end

%% satélite 18
valuetofind4 = GPGSV(6).SatID1;
posID4 = find(arrayfun(@(s) ismember(valuetofind4, s.SatID1), GPGSV));
elevacion4 = []; azimut4=[];
for i =1:length(posID4)
    elevacion4(i) =  GPGSV(posID4(i)).Elevacion1;
    azimut4(i) = GPGSV(posID4(i)).Azimut1;
end

%% satélite 16
valuetofind5 = GPGSV(7).SatID1;
posID5 = find(arrayfun(@(s) ismember(valuetofind5, s.SatID1), GPGSV));
elevacion5 = []; azimut5=[];
for i =1:length(posID5)
    elevacion5(i) =  GPGSV(posID5(i)).Elevacion1;
    azimut5(i) = GPGSV(posID5(i)).Azimut1;
end

%% satélite 26
valuetofind6 = GPGSV(21).SatID1;
posID6 = find(arrayfun(@(s) ismember(valuetofind6, s.SatID1), GPGSV));
elevacion6 = []; azimut6=[];
for i =1:length(posID6)
    elevacion6(i) =  GPGSV(posID6(i)).Elevacion1;
    azimut6(i) = GPGSV(posID6(i)).Azimut1;
end

%% satélite 10
valuetofind7 = GPGSV(23).SatID1;
posID7 = find(arrayfun(@(s) ismember(valuetofind7, s.SatID1), GPGSV));
elevacion7 = []; azimut7=[];
for i =1:length(posID7)
    elevacion7(i) =  GPGSV(posID7(i)).Elevacion1;
    azimut7(i) = GPGSV(posID7(i)).Azimut1;
end


%% ploteo
polarplot(azimut1,elevacion1,'g*'); hold on;
polarplot(azimut2,elevacion2,'b*'); hold on;
polarplot(azimut3,elevacion3,'m*'); hold on;
polarplot(azimut4,elevacion4,'r*'); hold on;
polarplot(azimut5,elevacion5,'c*'); hold on;
polarplot(azimut6,elevacion6,'y*'); hold on;
polarplot(azimut7,elevacion7,'k*');
legend('Sat 31','Sat 29','Sat 20','Sat 18', 'Sat 16','Sat 10', 'Sat 26')
title('Evolución temporal')

end