function [kflat,kflong]= kf_drr(drlat, drlong, gpslat,gpslong) %dr

n=length(drlat);

P = 920*eye(2); % Matriz de covarianzas inicial
Q = 0.01*eye(2);
x=[drlat(1),drlong(1)]'; % Fix inicial
xe=x;
xp=xe;
z=xp;
kflat(1,1) = x(1,1); % Datos fix inicial
kflong(1,1)= x(2,1); % Datos fix inicial

for k=1:(length(drlat)-1)
% Kalman filter initialization
    xe = [drlat(k+1), drlong(k+1)]'; % Vector de estado 

% Ecuaciones de actualización
    A  = [[1,0,]',[0,1]'];               % Matriz de estados
    xp = A*xe+(rand(2,1))*0.00005;  % Vector de predicción
                                 % rand(2,1)*0.01 ruido de predicción
    PP = A*P*A' + Q;    % Pronóstico de covarianza del error
        
% Ecuaciones de medida
    xp = [gpslat(k+1),gpslong(k+1)]'; % Vector de medidas
    H  = [[1,0]',[0,1]']; 
    z  = H*xp+(rand(2,1))*0.00005;
    R  = [[0.2845,0.0045]',[0.0045,0.0455]']; % Matriz covarianza de la perturbación de la medida
    
% Ecuaciones de Estima
    K = PP*H'*inv(H*PP*H'+R); % Matriz de Kalman
    xf = xp + K*(z - H*xp); % x=[kflat, kflong]'
    P = (eye(2)-K*H)*PP; % Actualiza la covarianza del error

kflat(k+1,1)=xf(1,1);
kflong(k+1,1)=xf(2,1);

end





