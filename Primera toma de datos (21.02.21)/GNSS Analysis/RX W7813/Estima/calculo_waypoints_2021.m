function [waypoints,gpslat,gpslong] = calculo_waypoints_2021 (Data)

for i=1:length (Data)
    
    % LATITUDES: Casos N/S
    if Data{i,1}.posicion{1,1} > 0
        waypoints(i,1) = Data{i,1}.posicion{1,1};
    else
        waypoints(i,1) = - (Data{i,1}.posicion{1,1});
    end
    
    % LONGITUDES: Casos E/W
    if Data{i,1}.posicion{2,1} > 0
        waypoints(i,2) = -(Data{i,1}.posicion{2,1});
    else
        waypoints(i,2) = Data{i,1}.posicion{2,1};
    end
    
end

for k=1:length(waypoints)
    
    if waypoints(k,1)<0,
        gpslat(k,1)=floor(abs(waypoints(k,1)))*(-1)-5*(abs(waypoints(k,1))-floor(abs(waypoints(k,1))))/3;
    else
        gpslat(k,1)=floor(waypoints(k,1))+5*(waypoints(k,1)-floor(waypoints(k,1)))/3;
    end
    
    if waypoints(k,2)<0,
        gpslong(k,1)=floor(abs(waypoints(k,2)))*(-1)-5*(abs(waypoints(k,2))-floor(abs(waypoints(k,2))))/3;
    else
        gpslong(k,1)=floor(waypoints(k,2))+5*(waypoints(k,2)-floor(waypoints(k,2)))/3;
    end
    
end

for j=1:length(waypoints)
    
    if waypoints(j,1)<0,
        waypoints(j,1)=floor(abs(waypoints(j,1)))*(-1)-5*(abs(waypoints(j,1))-floor(abs(waypoints(j,1))))/3;
    else
        waypoints(j,1)=floor(waypoints(j,1))+5*(waypoints(j,1)-floor(waypoints(j,1)))/3;
    end
    
    if waypoints(j,2)<0,
        waypoints(j,2)=floor(abs(waypoints(j,2)))*(-1)-5*(abs(waypoints(j,2))-floor(abs(waypoints(j,2))))/3;
    else
        waypoints(j,2)=floor(waypoints(j,2))+5*(waypoints(j,2)-floor(waypoints(j,2)))/3;
    end
    
end



indlat=find(isnan(gpslat)); 

gpslat(indlat)=0; 

indlong=find(isnan(gpslong)); 

gpslong(indlong)=0;

indwaypoints=find(isnan(waypoints)); 

waypoints(indwaypoints)=0;


% for k=1:length(waypoints)
%     
%     if gpslong(k,1)==0
%         i=k;
%         gpslong(k-1,1)=0;
%         gpslong(k-2,1)=0;
%         gpslong(k-3,1)=0;
%         gpslong(k-4,1)=0;
%     else
%     end
%     if gpslat(k,1)==0
% 
%         gpslat(k-1,1)=0;
%         gpslat(k-2,1)=0;
%         gpslat(k-3,1)=0;
%         gpslat(k-4,1)=0;
%     else
%     end
%   
% end
% waypoints(i+1,1)=0;
% waypoints(i+1,2)=0;
% gpslong(i+1)=0;
% gpslat(i+1)=0;
% waypoints(i+2,1)=0;
% waypoints(i+2,2)=0;
% gpslong(i+2)=0;
% gpslat(i+2)=0;
% 
% waypoints(i+3,1)=0;
% waypoints(i+3,2)=0;
% gpslong(i+3)=0;
% gpslat(i+3)=0;
% 
% waypoints(i+4,1)=0;
% waypoints(i+4,2)=0;
% gpslong(i+4)=0;
% gpslat(i+4)=0;