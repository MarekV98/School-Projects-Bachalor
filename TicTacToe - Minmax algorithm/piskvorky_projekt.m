
classdef piskvorky_projekt < handle
  properties
    window 
    winboard
    menu1
    menu2
    menu3
    exitmenu
    game
    border
    stats1
    stats2
    stats3
    stats4
    exit2
    reset
    mainmenu
    winner
    winnertext
    newgame
    pvp
    pvc
    exit
    x3
    x5
    x7
    x3pvc
    back
    backpvc
    nadpis
    b
    play
    congratz
    tie
  end
  methods
      function obj = piskvorky_projekt
          close all;
          obj.window.MenuBar = 'none';
          obj.window=figure('units','pixels',...               
                    'position',[400 100 600 600],...
                    'menubar','none',...
                    'numbertitle','off',...
                    'name','piskvorky',...
                    'resize','off',...
                    'color',[  1.0000    0.2667         0]);                   
    obj.border=uipanel('units','pixels',...                                 %pozadí
        'visible','on',...
        'position',[5 5 590 590],... 
        'HighLightColor','k',...
        'backgroundcolor',[  0.9882    0.9059    0.3569])
    
    obj.play=uicontrol(obj.window,...                                       %Play  tlačítko
                'style','push',...
                'units','pixels',...
                'position',[200 240 180 60],...
                'fontsize',30,...
                'string','START',...
                'tag','play',...
                'backgroundcolor',[1.0000    0.6863    0.3294],...
                'callback',{@menu1_call,obj});
    
    obj.menu1=uipanel('units','pixels',...                                   %Menu 1 pozadí
        'position',[150 50 300 320],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','menu1',...
        'backgroundcolor',[1.0000    0.6863    0.3294]);
          
    obj.pvp=uicontrol(obj.menu1,...                                          %PvP tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[40 260 220 40],...
        'fontsize',15,...
        'string',' Player vs. Player',...
        'Callback',{@pvp_call,obj});
    obj.pvc=uicontrol(obj.menu1,...                                          %PvC tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[40 210 220 40],...
        'fontsize',15,...
        'string','Player vs. COM',...
        'callback',{@pvc_call,obj});

    obj.exit=uicontrol(obj.menu1,...                                          %exit tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[85 40 130 40],...
        'fontsize',15,...
        'string','Exit',...
        'callback',{@exit_call,obj});
    
    obj.nadpis=uicontrol('style','text',...                                     %Nadpis
        'units','pixels',...
        'position',[20 410 550 140],...
        'visible','on',...
        'fontname','Ink Free',...
        'fontweight','bold',...
        'fontsize',90,...
        'Tag','nadpis',...
        'string','Piškvorky')                      
    set(obj.nadpis,'Backgroundcolor',[0.9882    0.9059    0.3569]);
  
  
    obj.menu2=uipanel('units','pixels',...                                  %Menu 2 pozadí
        'position',[150 50 300 320],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','menu2',...
        'backgroundcolor',[1.0000    0.6863    0.3294]);
     
    obj.menu3=uipanel('units','pixels',...                                  %Menu 3 pozadí
        'position',[150 50 300 320],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','menu3',...
        'backgroundcolor',[1.0000    0.6863    0.3294]);
    
     obj.x3pvc=uicontrol(obj.menu3,...                                      %3x3 tlačítko pro pvc
         'style','push',...             
        'units','pixels',...
        'position',[40 260 220 40],...
        'fontsize',15,...
        'string','3x3',...
        'callback',{@x3pvc_call,obj});
    
    obj.backpvc=uicontrol(obj.menu3,...                                     %Back tlačítko pro pvc
        'style','push',...               
        'units','pixels',...
        'position',[85 40 130 40],...
        'fontsize',15,...
        'string','Back',...
        'callback',{@back_call,obj});
    
    
    obj.x3=uicontrol(obj.menu2,...                                          %3x3 tlačítko
         'style','push',...             
        'units','pixels',...
        'position',[40 260 220 40],...
        'fontsize',15,...
        'string','3x3',...
        'callback',{@x3_call,obj});
    
    obj.x5=uicontrol(obj.menu2,...                                          %5x5 tlačítko  
        'style','push',...               
        'units','pixels',...
        'position',[40 210 220 40],...
        'fontsize',15,...
        'string','5x5',...
        'callback',{@x5_call,obj});
    
    obj.x7=uicontrol(obj.menu2,...                                          %7x7 tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[40 160 220 40],...
        'fontsize',15,...
        'string','7x7',...
        'callback',{@x7_call,obj});
    
    obj.back=uicontrol(obj.menu2,...                                          %Back tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[85 40 130 40],...
        'fontsize',15,...
        'string','Back',...
        'callback',{@back_call,obj});
    
    obj.winboard=uipanel('units','pixels',...                               %Pozadí pole na zapisování skóre
        'position',[40 20 300 170],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','ingame',...
        'backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.stats1=uicontrol(obj.winboard,...                                   %Player 1 staty
        'style','text',...               
        'units','pixels',...
        'position',[25 100 240 35],...
        'fontname','Ink Free',...
        'fontweight','bold',...
        'fontsize',19,...
        'string','Player 1 points: 0');                   
    set(obj.stats1,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.stats2=uicontrol(obj.winboard,...                                   %Player 2 staty
        'style','text',...               
        'units','pixels',...
        'position',[25 32.5 240 35],...
        'fontname','Ink Free',...
        'fontweight','bold',...
        'fontsize',19,...
        'string','Player 2 points: 0');                   
    set(obj.stats2,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.stats3=uicontrol(obj.winboard,...                                   %Vyhlášení vítěze kola
        'style','text',...               
        'units','pixels',...
        'position',[30 50 240 80],...
        'fontname','Ink Free',...
        'fontweight','bold',...
        'visible','off',...
        'fontsize',25,...
        'string',{'Player 1','won the round'});                   
    set(obj.stats3,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.stats4=uicontrol(obj.winboard,...                                   %Vyhlášení vítěze kola      
        'style','text',...               
        'units','pixels',...
        'position',[30 50 240 80],...
        'fontname','Ink Free',...
        'visible','off',...
        'fontweight','bold',...
        'fontsize',25,...
        'string',{'Player 2','won the round'});                   
    set(obj.stats4,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.congratz=uicontrol(obj.winboard,...                                   %Gratulace vítezi     
        'style','text',...               
        'units','pixels',...
        'position',[30 20 240 80],...
        'fontname','Ink Free',...
        'visible','off',...
        'fontweight','bold',...
        'fontsize',25,...
        'string',{'Congratulation'});                   
    set(obj.congratz,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.tie=uicontrol(obj.winboard,...                                      %Vyhlášení remízy     
        'style','text',...               
        'units','pixels',...
        'position',[25 25 240 80],...
        'fontname','Ink Free',...
        'visible','off',...
        'fontweight','bold',...
        'fontsize',30,...
        'string',{'Tie'});                   
    set(obj.tie,'Backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.exitmenu=uipanel('units','pixels',...                              %Pozadí pro tlačítka ingame
        'position',[375 20 185 170],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','ingame',...
        'backgroundcolor',[1.0000    0.6863    0.3294]);
    
    obj.exit2=uicontrol(obj.exitmenu,...                                   %Exit ve hře
        'style','push',...              
        'units','pixels',...
        'position',[30 10 125 40],...
        'fontsize',15,...
        'string','Exit',...
        'callback',{@exit_call,obj});
    
    obj.mainmenu=uicontrol(obj.exitmenu,...                                %Zpět do menu tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[30 65 125 40],...
        'fontsize',15,...
        'string','Menu',...
        'callback',{@backmenu_call,obj});
    
    obj.reset=uicontrol(obj.exitmenu,...                                   %Reset hry tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[30 120 125 40],...
        'fontsize',15,...
        'string','Reset',...
        'callback',{@reset_call,obj});
   
    obj.game=uipanel('units','pixels',...                                  %Parent pro tlačítka
        'position',[120 210 355 355],...
        'visible','off',...
        'Tag','buttons',...
        'backgroundcolor','k');
   
    obj.winner=uipanel('units','pixels',...                                %Výherní screen
        'position',[135 225 325 325],...
        'visible','off',...
        'HighLightColor','k',...
        'Tag','winscr',...
        'backgroundcolor',[  1.0000    0.4863    0.3020]);
    
      obj.newgame=uicontrol(obj.winner,...                                 %New game tlačítko
        'style','push',...               
        'units','pixels',...
        'position',[105 60 125 40],...
        'fontsize',15,...
        'string','New Game',...
        'callback',{@reset_call,obj});
    
    obj.winnertext=uicontrol(obj.winner,...                                %Vyhlášení vítěze hry
        'style','text',...               
        'units','pixels',...
        'position',[15 140 300 60],...
        'fontname','Ink Free',...
        'fontweight','bold',...
        'fontsize',32);               
    set(obj.winnertext,'Backgroundcolor',[ 1.0000    0.4863    0.3020]);
    
    
%Funkce na vytvoření hracího pole  
function Vytvorpole(varargin)
    set(obj.b,'enable','off');
    w=0;
    for(a=0:1:(pole-1))
        for(c=0:1:(pole-1))
        w=w+1;
    obj.b(w)=uicontrol(obj.game,...
        'style','push',... 
        'units','normalized',...
        'position',[(1/pole)*a (1/pole)*c 1/pole 1/pole],...
        'fontsize',220/pole,...
        'backgroundcolor',[1.0000    0.6863    0.3294],...
        'callback',{@b_call,obj}); 
        end
    end
end


function []=menu1_call(obj,handle,eventdata)                                %Stisk tlačítka menu1
set(findobj('Tag','menu1'),'visible','on')
set(findobj('Tag','0'),'visible','off')
set(findobj('Tag','play'),'visible','off')
end
function []=pvp_call(obj,handle,eventdata)                                  %Stisk tlačítka pvp
set(findobj('Tag','menu1'),'visible','off')
set(findobj('Tag','menu2'),'visible','on')
com=0;
end
function []=pvc_call(obj,handle,eventdata)                                  %Stisk tlačítka pvc
set(findobj('Tag','menu1'),'visible','off')
set(findobj('Tag','menu3'),'visible','on')
com=1;
end
function []=back_call(obj,handle,eventdata)                                 %Stisk tlačítka back
set(findobj('Tag','menu1'),'visible','on')
set(findobj('Tag','menu2'),'visible','off')
set(findobj('Tag','menu3'),'visible','off')
end

%hrací plocha 3x3 pro PvC
function []=x3pvc_call(varargin)
pole=3;
goal=3;
Vytvorpole();
set(findobj('Tag','buttons'),'visible','on')
set(findobj('Tag','ingame'),'visible','on')
set(findobj('Tag','menu3'),'visible','off')
set(findobj('Tag','nadpis'),'visible','off')        
move = zeros(pole,pole);
 set(obj.stats1,'string',['Player points: ',num2str(score1)]);
 set(obj.stats2,'string',['Computer points: ',num2str(score2)]);
end


%Hrací plocha 3x3
function []=x3_call(varargin)
pole=3;
goal=3;
Vytvorpole();
set(findobj('Tag','buttons'),'visible','on')
set(findobj('Tag','ingame'),'visible','on')
set(findobj('Tag','menu2'),'visible','off')
set(findobj('Tag','nadpis'),'visible','off')        
move = zeros(pole,pole);
end
          
%Hrací plocha 5x5           
function []=x5_call(varargin)                  
pole=5;
goal=4;
Vytvorpole();
set(findobj('Tag','buttons'),'visible','on')
set(findobj('Tag','ingame'),'visible','on')
set(findobj('Tag','menu2'),'visible','off')
set(findobj('Tag','nadpis'),'visible','off')          
move = zeros(pole,pole);
end
          
%Hrací plocha 7x7             
function []=x7_call(varargin)                  
pole=7;
goal=4;
Vytvorpole();
set(findobj('Tag','buttons'),'visible','on')
set(findobj('Tag','ingame'),'visible','on')
set(findobj('Tag','menu2'),'visible','off')
set(findobj('Tag','nadpis'),'visible','off')
move = zeros(pole,pole);
end
  
%Reset tlačítko
function []=reset_call(varargin)
set(findobj('Tag','winscr'),'visible','off')
win1=0;
win2=0;
score1=0;
score2=0;
set(obj.stats1,'string',['Player 1 points: ',num2str(score1)]);
set(obj.stats2,'string',['Player 2 points: ',num2str(score2)]);
if com==1
  set(obj.stats1,'string',['Player points: ',num2str(score1)]);
  set(obj.stats2,'string',['Computer points: ',num2str(score2)]);
end
set(obj.b,'string',' ');
set(obj.b,'Enable','on')
set(obj.congratz,'visible','off');
set(obj.stats1,'visible','on');
set(obj.stats2,'visible','on');
move = zeros(pole,pole)
hrac=1;
end                   
   
%exit tlačítko
function []=exit_call(obj,handle,eventdata)
          close all; 
end

%back tlačítko
function []=backmenu_call(varargin) 
          set(obj.b,'string',' ');
          set(obj.b,'Enable','on')
          hrac=1;
          score1=0;
          score2=0;
          win1=0;
          win2=0;
          set(obj.stats1,'string',['Player 1 points: ',num2str(score1)]);
          set(obj.stats2,'string',['Player 2 points: ',num2str(score2)]);
          set(obj.stats3,'string',{'Player 1','won the round'});
          set(obj.stats4,'string',{'Player 2','won the round'});
          set(obj.congratz,'visible','off');
          set(obj.stats1,'visible','on');
          set(obj.stats2,'visible','on');
          set(findobj('Tag','menu1'),'visible','on')
          set(findobj('Tag','buttons'),'visible','off')
          set(findobj('Tag','ingame'),'visible','off')
          set(findobj('Tag','nadpis'),'visible','on')
          set(findobj('Tag','winscr'),'visible','off')    
end
          

          
global hrac move pole goal com
global wboard tie
global v1 v2 h1 h2 d1 d2 d3 d4 bflag kl kp gp c2 
global score1 score2 win1 win2
global subPoziceX subPoziceY Num bestNum 
hrac=1;
v1=0;
v2=0;
h1=0;
h2=0;
d1=0;
d2=0;
d3=0;
d4=0;
score1=0;
score2=0;
win1=0;
win2=0;
bflag=0;
c2=0;


function []=b_call(varargin)  
    
% Tah člověka 
    pozice=get(gcbo,'position');  
   
       x=(pozice(1)/(1/pole))+1;
       y=(pozice(2)/(1/pole))+1;       
   
% Konvertování souřadnic na x,y matice       
            subPoziceY=y;
            subPoziceX=x;
            Num=0;
            if subPoziceX>1
            subPoziceY=pole;
            end
            for(o=1:1:x)
                for(p=1:1:subPoziceY)
                 Num=Num+1; 
                end
                subPoziceX=subPoziceX-1;
                if subPoziceX>1
                 subPoziceY=pole;
                else 
                 subPoziceY=y;  
                end   
            end

 %Zapsání tahu do herního pole a matice
          if hrac == 1 
          set(obj.b(Num),'string','✖');
          set(obj.b(Num),'Enable','off')
          move(y,x)=1;
          elseif hrac == 0
          set(obj.b(Num),'string','⬤');
          set(obj.b(Num),'Enable','off')
          move(y,x)=2;
          end
          
          hrac = ~hrac;
      
          checkwinner(move,x,y);
          results();
          
          if com==1
            aiplayer(x,y)
          end
end

 
% Tah počítače
function aiplayer(varargin)
          Num=0;
          bestscore=-inf
          score=0;
          alpha=-inf
          beta=inf 
          for x=1:1:pole
              for y=1:1:pole
                  Num=Num+1;
                  if (move(y,x)==0) 
                     if move(2,2)==0
                         besty=2;
                         bestx=2;
                         bflag=1
                         bestNum=5;
                         break
                     end
                     move(y,x)=2;
                     tempx=x;
                     tempy=y; 
                     [score]=minimax(move,0,false,x,y,alpha,beta);
                     x=tempx;
                     y=tempy;
                     move(y,x)=0;
                     if (score > bestscore)
                        bestscore=score
                        bestNum=Num
                        besty=y;
                        bestx=x;
                     end
                  end
              end 
              if bflag==1
                  bflag=0
                  break
              end
          end
          y=besty;
          x=bestx;
          tie=0;
          wboard=0;
          
          %Zapsání tahu do herního pole a matice
          if hrac == 1 
          set(obj.b(bestNum),'string','✖');
          set(obj.b(bestNum),'Enable','off')
          move(y,x)=1
          elseif hrac == 0
          set(obj.b(bestNum),'string','⬤');
          set(obj.b(bestNum),'Enable','off')
          move(y,x)=2
          end
          hrac = ~hrac;
          checkwinner(move,x,y);
          results;
     end
    
function [bestscore]=minimax(move,depth,maximizing,x,y,alpha,beta)          %Minimax funkce (Rekurzivně hledá nejlepší tah)
              
              %Zjišťování stavu herního pole (WIN/LOSE/TIE)
              [mm]=checkwinner(move,x,y);      
              if (mm~=0) 
                 tmp = [0 10 -10]
                 bestscore = tmp(mm)-depth;
                 mm=0;
                 return
              end  
          
              %Maximizing prvek (AI)
          if maximizing
            bestscore=-inf;
         	for x=1:1:pole
              for y=1:1:pole
                  if move(y,x)==0 
                      move(y,x)=2;
                      tempx=x;
                      tempy=y; 
                      [score]=minimax(move,depth+1,false,x,y,alpha,beta)
                      x=tempx;
                      y=tempy;
                      move(y,x)=0;
                      alpha=max(score,alpha)
                      bestscore=max(score,bestscore)
                      tie=0;
                      if alpha>=beta
                          bflag=1;
                          break
                      end
                  end  
              end
              if bflag == 1
                  bflag=0
                  break
              end
           end
     return
                
     
          %Minimazing prvek (Hráč)
          else
            bestscore=inf; 
         	for x=1:1:pole
              for y=1:1:pole
                  if move(y,x)==0 
                     move(y,x)=1;
                     tempx=x;
                     tempy=y;
                     [score]=minimax(move,depth+1,true,x,y,alpha,beta)  
                     x=tempx;
                     y=tempy;
                     move(y,x)=0;
                     beta=min(score,beta)  
                     bestscore = min(score, bestscore) 
                     if beta<=alpha
                        bflag=1;
                         break
                     end
                  end
              end 
              if bflag==1
                  bflag=0;
                  break
              end
            end
       return 
  end 
end

function [mm]=checkwinner(move,x,y)     
        % Vertikální kontrola
        move
        x
        y
        mm=0;
        wboard=0;
          for a=1:1:pole
        if move(a,x) == 1
          v1=v1+1;
          v2=0;
          if v1==goal
            break
          end
      end
      if move(a,x) == 2
          v2=v2+1;
          v1=0;
          if v2==goal
              break
          end
      end
        if move(a,x) == 0
          v2=0;
          v1=0; 
        end
        end
      
      % Horizontální kontrola
      for c=1:1:pole
      if move(y,c) == 1
          h1=h1+1;
          h2=0;
          if h1==goal
              break
          end
      end
       if move(y,c) == 2
          h2=h2+1;
          h1=0;
          if h2 == goal
              break
          end
      end
      if move (y,c) == 0
          h2=0;
          h1=0;
      end
      end
      
      % Diagonální kontrola 1
      for kk=-3:1:3 
          kp=kk;
          kl=0;
          if kk < 0
             kl=abs(kk);
             kp=abs(kk);
             kk=0;
          end
      for k=1:1:(pole-kp)
      if move(k+kl,k+kk) == 1
          d1=d1+1;
          d2=0;
          if d1== goal
            bflag=1;
            break
          end
      end
      if move(k+kl,k+kk) == 2
          d2=d2+1;
          d1=0;
          if d2== goal
           bflag=1;
           break
          end
      end
      if  move(k+kl,k+kk) == 0
         d1=0;
         d2=0;
      end
      end
    
      if bflag ==1
          bflag=0;
          break
      end
      d1=0;
      d2=0;
      end
      
      % Diagonální kontrola 2
      for go=-4:1:3  
          gp=1;
          if go < 0
             gp=abs(go);
             go=0;
          end
      g=(pole-go);  
      for l=gp:1:(pole-go)    
      if move(l,g) == 1
          d3=d3+1;
          d4=0;
          if d3==goal
              bflag=1;
              break
          end
      end
      if move(l,g) == 2
          d4=d4+1;
          d3=0;
          if d4== goal
              bflag=1;
              break
          end
      end
      if move(l,g)==0
          d3=0;
          d4=0;
      end
      g=g-1;
      end
      if bflag==1
        bflag==0;
        break
      end
      d3=0;
      d4=0;
      end
    
      % Ukončení kola
      if (h1 == goal) || (v1 == goal) || (d1 == goal) || (d3 == goal)
          c2=1;
          mm=3;
          wboard=1;
      end
      if (h2 == goal) || (v2 == goal) || (d2 == goal)|| (d4 == goal)
          c2=1;
          mm=2;
          wboard=2;
      end
 
      
% Vyhodnocení remízy
      c = min(move,[],'all');
      if (c == 1) && (c2~=1)
          tie=1;
          mm=1;
      end

       
 % Reset proměnných 
      g=pole;
      v1=0;
      v2=0;
      h1=0;
      h2=0;
      d1=0;
      d2=0;
      d3=0;
      d4=0;      
      c2=0;
    end
 
    
 %Vyhodnocení výsledků   
    
function []=results(varargin)
                
    if tie==1 
          win1=win1+1;
          win2=win2+1;
          score1=score1+1;
          score2=score2+1;
          set(obj.stats1,'visible','off');
          set(obj.stats2,'visible','off');
          set(obj.tie,'visible','on');
          pause(1.5);
          set(obj.stats1,'string',['Player 1 points: ',num2str(score1)]);
          set(obj.stats2,'string',['Player 2 points: ',num2str(score2)]);
          if com ==1
            set(obj.stats1,'string',['Player points: ',num2str(score1)]);
            set(obj.stats2,'string',['Computer points: ',num2str(score2)]);
          end
          set(obj.stats1,'visible','on');
          set(obj.stats2,'visible','on');
          set(obj.tie,'visible','off');
          set(obj.b,'string',' ');
          set(obj.b,'Enable','on')
          move = zeros(pole,pole)
          hrac=~hrac; 
          tie=0;
          if com==1
              hrac=~hrac;
          end
    end
               
    if wboard==1
      
      score1=score1+1;
      win1=win1+1;
      set(obj.b,'Enable','off');
      set(obj.stats1,'visible','off');
      set(obj.stats2,'visible','off');
      set(obj.stats3,'visible','on');
      set(obj.stats1,'string',[' Player 1 points: ',num2str(score1)]); 
       if com ==1
       set(obj.stats2,'string',['Player points: ',num2str(score1)]);
       set(obj.stats3,'string',{'Player','won the round'});
       end
      pause(1.5);
      set(obj.b,'backgroundcolor',[1.0000    0.6863    0.3294]);
      set(obj.stats1,'visible','on');
      set(obj.stats2,'visible','on');
      set(obj.stats3,'visible','off');
      set(obj.b,'string',' ');
      set(obj.b,'Enable','on');
      move = zeros(pole,pole)
      hrac=0;
      wboard=0;
    end
    
    if wboard==2

       score2=score2+1;
       win2=win2+1;
       set(obj.b,'Enable','off')
       set(obj.stats1,'visible','off');
       set(obj.stats2,'visible','off');
       set(obj.stats4,'visible','on');
       set(obj.stats2,'string',['Player 2 points: ',num2str(score2)]);
       if com ==1
       set(obj.stats2,'string',['Computer points: ',num2str(score2)]);
       set(obj.stats4,'string',{'Computer','won the round'});
       end
       pause(1.5);
       set(obj.b,'backgroundcolor',[1.0000    0.6863    0.3294]);
       set(obj.stats1,'visible','on');
       set(obj.stats2,'visible','on');
       set(obj.stats4,'visible','off');
       set(obj.b,'string',' ');
       set(obj.b,'Enable','on')
       move = zeros(pole,pole)
       hrac=1; 
       wboard=0;   
    end 
   
    
% Celková výhra
   if (win1==3) ||(win2==3)
   if (win1 == 3) && (win2 ~= 3)
        set(obj.winnertext,'string','Player 1 wins')
        set(findobj('Tag','winscr'),'visible','on')
         if com == 1
            set(obj.winnertext,'string','Player wins')
        end
   end
   if (win2 == 3)  && (win1 ~= 3)
        set(obj.winnertext,'string','Player 2 wins')
        set(findobj('Tag','winscr'),'visible','on')
        if com == 1
            set(obj.winnertext,'string','Computer wins')
        end
   end
   
   if (win2 == 3)  && (win1 == 3)
       set(obj.winnertext,'string','Tie game')
        set(findobj('Tag','winscr'),'visible','on')
   end
       set(obj.stats1,'visible','off');
       set(obj.stats2,'visible','off');
       set(obj.congratz,'visible','on');
   end
end 
end
end  
end

