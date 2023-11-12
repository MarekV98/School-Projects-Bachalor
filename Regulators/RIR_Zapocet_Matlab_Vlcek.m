clc
clear all
close all
%% Hlavièka
% Matlab pro zápoètový projekt do pøedmìtu RIR
% Vytvoøil Marek Vlèek

%% Parametry soustavy
m1 = 10;                %hmotnost 1
m2 = 12;                %hmotnost 2
k = 1e4;                %tuhost pružiny
b = 80;                %tlumení


%% Matice A, B, C a D
A = [0 1 0 0; -k/m1 -b/m1 k/m1 0; 0 0 0 1; k/m2 0 -k/m2 0];  
B = [0; 0; 0; 1/m2];    
C = [1 0 0 0];          %Hledáme hodnotu dx1, proto je matice v tomto tvaru
D = [0];                %V našem tomto pøípadì 0

%Matice jsem vypoèetl pøes vyjádøení nejvyšší derivace a substitucí 
%       =>  x1=y1       dx1=x2
%           x2=dy1      dx2=ddx1
%           x3=y2       dx3=x4
%           x4=dy2      dx4=ddy2          

%% Póly (zvolené)
POL = [complex(-3.5,6) complex(-3.5,-6) complex(-7,0) complex(-6,0) complex(-12,0)];


%% Zjištìní rozšíøených matic rA, rB a rK
Z = [0; 0; 0; 0];       %Matice nul, kterou použijeme pro získání 5x5 matice rA
rA=[A Z;-C 0];          %Matice rA 
rB=[B;0];               %Matice rB

rK = acker(rA,rB,POL);    

%% Výpoèet KI a K
KI = -rK(5);             %Poslední hodnota KI
K = rK(1:4);            %První 4 èleny





