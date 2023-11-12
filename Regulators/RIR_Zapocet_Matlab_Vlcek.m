clc
clear all
close all
%% Hlavi�ka
% Matlab pro z�po�tov� projekt do p�edm�tu RIR
% Vytvo�il Marek Vl�ek

%% Parametry soustavy
m1 = 10;                %hmotnost 1
m2 = 12;                %hmotnost 2
k = 1e4;                %tuhost pru�iny
b = 80;                %tlumen�


%% Matice A, B, C a D
A = [0 1 0 0; -k/m1 -b/m1 k/m1 0; 0 0 0 1; k/m2 0 -k/m2 0];  
B = [0; 0; 0; 1/m2];    
C = [1 0 0 0];          %Hled�me hodnotu dx1, proto je matice v tomto tvaru
D = [0];                %V na�em tomto p��pad� 0

%Matice jsem vypo�etl p�es vyj�d�en� nejvy��� derivace a substituc� 
%       =>  x1=y1       dx1=x2
%           x2=dy1      dx2=ddx1
%           x3=y2       dx3=x4
%           x4=dy2      dx4=ddy2          

%% P�ly (zvolen�)
POL = [complex(-3.5,6) complex(-3.5,-6) complex(-7,0) complex(-6,0) complex(-12,0)];


%% Zji�t�n� roz���en�ch matic rA, rB a rK
Z = [0; 0; 0; 0];       %Matice nul, kterou pou�ijeme pro z�sk�n� 5x5 matice rA
rA=[A Z;-C 0];          %Matice rA 
rB=[B;0];               %Matice rB

rK = acker(rA,rB,POL);    

%% V�po�et KI a K
KI = -rK(5);             %Posledn� hodnota KI
K = rK(1:4);            %Prvn� 4 �leny





