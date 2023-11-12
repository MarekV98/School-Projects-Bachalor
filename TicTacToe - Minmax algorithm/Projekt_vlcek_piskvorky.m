clc, clear all

GUI=piskvorky_projekt();


% Projekt GUI do RDO
% 
% Piškvorky s možností hrát s jiným hráčem na poli 3x3 na 3 znaky nebo 5x5 a 7x7 na 4 znaky
%
% Hráč 1 má křížky a hráč 2 kolečka, v případě hry proti počítači má hráč křížky
% 
% Hraje se na 3 vítězné kola, při remíze se přičítají body obou pro zamezení nekonečné hry   
% 
% Proti počítači lze hrát pouze na poli 3x3. Ostatní možnosti jsem musel odstranit z důvodu nedokonalosti umělé inteligence
%             --> Minimax algoritmus s alfa beta ořezáváním nebyl stále dostatečně rychlý, aby byla hra hratelná 
%                 bohužel jsem se už nedostal k zvýšení efektivity prohledávání
% 
% 
% Vytvořil: Marek Vlček
          
            
