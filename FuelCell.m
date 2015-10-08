function [Xout,Nout, W_out, n_CH4] = FuelCell(V_fc, TXNin)
global R Na e F;
R = 8.314;
Na = 6.022*10^23;
e = 1.602 * 10^-19;
F = 96485;  

%Inlets
Tin = TXNin(:,1);  
Xin = TXNin(:,2:8);
Nin = TXNin(:,9);

%Available electrons
n = 4;

%Reaction effectivenss
erxn2 = .6;
erxn3 = 1;

%Knowns
T_fuel = 300;
T_fc = 1000;
h = enthalpy(1000);

%Initial Assumption for reformation
util = .70;
error = .30;
while error > .1

    % Reactions occuring in SOFC %
    hrxn1 = 2*h(5)-2*h(4)-h(7); %2H2 + O2 -->  2H2O
    hrxn2 = h(3)+h(4)-h(2)-h(5); %CO + H20 --> CO2 + H2 
    hrxn3 = 3*h(4)+h(2)-h(1)-h(5); %CH4+H2O --> CO + 3H2


    x_ref = [.33 0 0 0 .66 0 0];   %Fuel for reformation
    x_fuel = [1 0 0 0 0 0 0];
    i = 4*1000*F*Nin;               %initial current based on nO2
    n_ac = (i/(2*1000*F));      
    n_H2 = n_ac/util;               %Hydrogen taking place in reaction
    n_fuel = n_H2/4;
    n_CH4 = n_fuel*(x_fuel(1));     %Flow of CH4 coming in



    R3 = ((x_fuel(1)*n_fuel))*erxn3;
    R2 = (x_fuel(2)*(n_fuel)+R3)*erxn2;
    R1 =(i/(4000*F));

    Nout = n_fuel + Nin - R1 + 2*R3;        %Total Nout of anode 

    Xout(1) = (x_fuel(1)*n_fuel-R3)/Nout;
    Xout(2) = ((x_fuel(2)*n_fuel)-R2+R3)/Nout;
    Xout(3) = ((x_fuel(3)*n_fuel)+R2)/Nout;                 %Mass balance
    Xout(4) = ((x_fuel(4)*n_fuel)-(2*R1)+R2+(3*R3))/Nout;
    Xout(5) = ((x_fuel(5)*n_fuel)-R2-(R3)+(2*R1))/Nout;
    Xout(6) = ((x_fuel(6)*n_fuel))/Nout;
    Xout(7) = ((x_fuel(7)*n_fuel + Nin)-R1)/Nout;
    
    n_recirc = (.05*n_CH4)/Xout(5);       %Flow coming back for reformation
    X_recirc = [n_CH4/(n_CH4+n_recirc),Xout(2:7)/((n_CH4+Nout)/Nout)];       %Composition of reformation
    


    [~,H_air] =  enthalpy(Tin, Xin, Nin);
    [~,H_CH4] =  enthalpy(T_fuel, x_fuel, n_fuel);      %Enthalpy of fuel
    [~,H_ref] = enthalpy(T_fc, X_recirc,n_recirc);      %Enthalpy coming from reformaer

    H_fuelin = H_CH4 + H_ref;                           %Actual enthalpy into cathode
    
    Nin = TXNin(9)+n_recirc;                            %New flow into anode
    
    error = n_ac/n_H2;                                  %New error based on active and total H2
    util = util+error;                                  %Updating util
end   
 
    W_out = V_fc*(i/1000);                  %Total power out based on Voltage and current
    H_out = H_fuelin+H_air-(R3*hrxn3)- W_out -(R1*hrxn1)-(R2*hrxn2);  %Total H_ouy




    % Tout = 1200;
    % T_error = 100;
    % while T_error > .1
    %    H_guess = enthalpy(Tout, Xout, Nout);
    %    Cp = SpecHeat(Tout, Xout);
    % 
    %    T_error = (H_out-H_guess)/(Cp*Nout);
    %    Tout = Tout+T_error;
    % end









