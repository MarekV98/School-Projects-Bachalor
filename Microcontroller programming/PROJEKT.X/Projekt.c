#pragma config FOSC = HSMP          // Oscillator Selection bits (HS oscillator (medium power 4-16 MHz))
#pragma config PLLCFG = ON          // 4X PLL Enable (Oscillator used directly)
#pragma config PRICLKEN = ON        // Primary clock enable bit (Primary clock is always enabled)
#pragma config WDTEN = OFF          // Watchdog Timer Enable bits (Watch dog timer is always disabled. SWDTEN has no effect.)

#include <xc.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include "lcd.h"

#define	XC_HEADER_TEMPLATE_H
#define _XTAL_FREQ 32E6
#define SETDUTY(x) CCPR1L = x

#define BTN1 PORTCbits.RC0
#define BTN2 PORTAbits.RA4
#define BTN3 PORTAbits.RA3
#define BTN4 PORTAbits.RA2

#define LED1 LATDbits.LATD2
#define LED2 LATDbits.LATD3
#define LED3 LATCbits.LATC4
#define LED4 LATDbits.LATD4
#define LED5 LATDbits.LATD5
#define LED6 LATDbits.LATD6





volatile uint16_t pot1;
volatile uint24_t n = 0;

char text[17];
char zapis[50];
char nadpis1[17];
char nadpis2[17];





void PWM_motor_led(void);
void PWM_init(void);

void Morseovka(void);
void Morseovka_init(void);

void Knight_rider_2000(void);
void Knight_rider_3000(void);

void Bargraph(void);
void Bargraph_init(void);

void Pong(void);
void Pong_init(void);

void putch(unsigned char data);





void init(void){
      LCD_Init();

      TRISCbits.RC0 = 1;
      TRISAbits.RA2 = 1;
      TRISAbits.RA3 = 1;
      TRISAbits.RA4 = 1;
      ANSELA = 0;
     
}



void kr_init(void){
    int kr=1;
    char k_r[17];
    char mor[17];
    
    while(1){
        if (BTN2){
            kr=2;
            }
        if (BTN1){
            kr=1;
         }
        switch(kr){
                case 1:
                sprintf(k_r,"* Model 2000    ");
                LCD_ShowString(1,k_r);
                sprintf(mor,"  Model 3000    ");
                LCD_ShowString(2,mor);
                 if (BTN3){
                Knight_rider_2000();
                     }
                break;
                case 2:
                sprintf(k_r,"  Model 2000    ");
                LCD_ShowString(1,k_r);
                sprintf(mor,"* Model 3000    ");
                LCD_ShowString(2,mor);
                if (BTN3){
                Knight_rider_3000();
                     }
                break;
                } 
                if (BTN4){
                __delay_ms(300);
                    return;
                }
                __delay_ms(150);
    }
}



void Morseovka_init(void){
    PEIE = 1;                                  
    GIE = 1;                   
    RC1IE = 1;                     
    
    ANSELC = 0x00;        
        
    TRISCbits.TRISC6 = 1;   
    TRISCbits.TRISC7 = 1;   
    
    SPBRG1 = 51;              
    RCSTA1bits.SPEN = 1;      
    TXSTA1bits.SYNC = 0;      
    TXSTA1bits.TXEN = 1;      
    RCSTA1bits.CREN = 1;        
}



void PWM_init(void){
    TRISD = 0b10000011;    
    TRISCbits.RC4 = 0;         
    
    TRISDbits.RD5 = 1;              
    TRISCbits.RC2 = 1;              
    PSTR1CONbits.STR1A = 1;
    PSTR1CONbits.STR1B = 1;
    
    CCPTMRS0bits.C1TSEL = 0b00; 
    PR2 = 199;                      
    CCP1CONbits.P1M = 0b00;         
    CCP1CONbits.CCP1M = 0b1101;    
    CCPR1L = 0;                        
    T2CONbits.T2CKPS = 0b00;       
    TMR2IF = 0;                     
    TMR2ON = 1;                    
    while(!TMR2IF){};               
        
    TRISDbits.RD5 = 0;              
    TRISCbits.RC2 = 0;            
            
    ANSELE = 0b1;                 
    ADCON2bits.ADFM = 1;       
    ADCON2bits.ADCS = 0b110;      
    ADCON2bits.ACQT = 0b110;        
    ADCON0bits.ADON = 1;           
    ADCON0bits.CHS = 5;            
    
    ADIF = 0;
    ADIE = 1;
    PEIE = 1;
    GIE = 1;     
}



void Bargraph_init(void){
    ANSELA |= (1 << 5);             
    ANSELE = 0b1;                   
 
    ADCON2bits.ADFM = 1;            
    ADCON2bits.ADCS = 0b110;       
    ADCON2bits.ACQT = 0b110;        
    ADCON0bits.ADON = 1;           
    ADCON0bits.CHS = 5;             
    
    ADIF = 0;      
    PEIE = 1;       
    ADIE = 1;     
    GIE  = 1;       
}


void Pong_init(void){
    TRISCbits.RC0 = 1;
    TRISAbits.RA2 = 1;
    ANSELAbits.ANSA2 = 0;
}






void __interrupt() ISR (){
        
    if (ADIF & ADIE) {
        pot1 = (ADRESH << 8) | (ADRESL);
              ADIF = 0;
    }
    
     if(RC1IE && RC1IF){
           zapis[n] = RCREG1;
           n++;      
            }  
           }
         
      
    





void main(void){
    init();
    
    char k_r[17];
    char mor[17];
    char pwm[17];
    char barg[17];
    char pong[17];
    int m=1;
    
    while(1){
        LCD_Clear();
        if (BTN2){
            m++;
            if (m>8){
                m=8;
            }
        }
         if (BTN1){
            m--;
            if (m<1){
                m=1;
            }
         }
              
        switch(m){  
            case 1: 
            sprintf(k_r,"* Knight Rider  ");
            LCD_ShowString(1,k_r);
            sprintf(mor,"  Morseovka     ");
            LCD_ShowString(2,mor); 
            if (BTN3){
                __delay_ms(250);
                kr_init();
                
            }
            break;
            case 2:
            sprintf(k_r,"  Knight Rider  ");            
            LCD_ShowString(1,k_r);
            sprintf(mor,"* Morseovka     ");
            LCD_ShowString(2,mor);
            if (BTN3){
                Morseovka();
            }
            break;
            case 3:
            sprintf(mor,"* Morseovka     ");
            LCD_ShowString(1,mor); 
            sprintf(pwm,"  PWM motor     ");
            LCD_ShowString(2,pwm);
            if (BTN3){
                Morseovka();
            }
            break;  
            case 4:
            sprintf(mor,"  Morseovka     ");
            LCD_ShowString(1,mor);
            sprintf(pwm,"* PWM motor     ");
            LCD_ShowString(2,pwm);
            if (BTN3){
               PWM_motor_led();
            }
            break;
            case 5:
            sprintf(pwm,"* PWM motor     ");
            LCD_ShowString(1,pwm);
            sprintf(barg,"  Bargraph      ");
            LCD_ShowString(2,barg); 
            if (BTN3){
                PWM_motor_led();
            }
            break;
            case 6:
            sprintf(pwm,"  PWM motor     ");
            LCD_ShowString(1,pwm); 
            sprintf(barg,"* Bargraph      ");
            LCD_ShowString(2,barg); 
            if (BTN3){
                Bargraph();
            }
            break;
            case 7:
            sprintf(barg,"* Bargraph      ");
            LCD_ShowString(1,barg);
            sprintf(pong,"  Pong-2 PLAYERS");
            LCD_ShowString(2,pong);
            if (BTN3){
                Bargraph();
            }
            break;
            case 8:
            sprintf(barg,"  Bargraph      ");
            LCD_ShowString(1,barg);
            sprintf(pong,"* Pong-2 PLAYERS");
            LCD_ShowString(2,pong); 
            if (BTN3){
                Pong();
            }
            break;
    }
        if(BTN4){
            m=1;
        }
    __delay_ms(150);
    }    
}








void Morseovka(void){
    Morseovka_init();
    LCD_Clear();
    int i = 0;
    int j = 0;
   
    printf("Enter only valid characters :)\n\n\n");
    
    while(1){
        sprintf(nadpis1,"Morse translator");
        LCD_ShowString(1,nadpis1);
        sprintf(nadpis2,"translating...  ");
        LCD_ShowString(2,nadpis2);
        if (n!=0){
        printf("\nPREKLAD:  ");
        for(i=0;i<n;i++){
            switch (zapis[i]){
           
                    case 'A':
                    case 'a':
                    printf(" . - |");
                    break;
                    case 'B':
                    case 'b':
                    printf(" - . . . |");
                    break;
                    case 'C':
                    case 'c':
                    printf(" - . - . |");
                    break;
                    case 'D':
                    case 'd':
                    printf(" - . . |");
                    break;
                    case 'E':
                    case 'e':
                    printf(" . |");
                    break;
                    case 'F':
                    case 'f':
                    printf(" . . - . |");
                    break;
                    case 'G':
                    case 'g':
                    printf(" - - . |");
                    break;
                    case 'H':
                    case 'h':
                    printf(" . . . . |");
                    break;
                    case 'I':
                    case 'i':
                    printf(" . . |");
                    break;
                    case 'J':
                    case 'j':
                    printf(" . - - - |");
                    break;
                    case 'K':
                    case 'k':
                    printf(" - . - |");
                    break;
                    case 'L':
                    case 'l':
                    printf(" . - . . |");
                    break;
                    case 'M':
                    case 'm':
                    printf(" - - |");
                    break;
                    case 'N':
                    case 'n':
                    printf(" - . |");
                    break;
                    case 'O':
                    case 'o':
                    printf(" - - - |");
                    break;
                    case 'P':
                    case 'p':
                    printf(" . - - . |");
                    break;
                    case 'Q':
                    case 'q':
                    printf(" - - . - |");
                    break;
                    case 'R':
                    case 'r':
                    printf(" . - . |");
                    break;
                    case 'S':
                    case 's':
                    printf(" . . . |");
                    break;
                    case 'T':
                    case 't':
                    printf(" - |");
                    break;
                    case 'U':
                    case 'u':
                    printf(" . . - |");
                    break;
                    case 'V':
                    case 'v':
                    printf(" . . . - |");
                    break;
                    case 'W':
                    case 'w':
                    printf(" . - - |");
                    break;
                    case 'X':
                    case 'x':    
                    printf(" - . . - |");
                    break;
                    case 'Y':
                    case 'y':    
                    printf(" - . - - |");
                    break;
                    case 'Z':
                    case 'z':    
                    printf(" - - . . |");
                    break;
                    case '0':   
                    printf(" - - - - - |");
                    break;
                    case '1':
                    printf(" . - - - - |");
                    break;
                    case '2':
                    printf(" . . - - - |");
                    break;
                    case '3':
                    printf(" . . . - - |");
                    break;
                    case '4':
                    printf(" . . . . - |");
                    break;
                    case '5':
                    printf(" . . . . . |");
                    break;
                    case '6':
                    printf(" - . . . . |");
                    break;
                    case '7':
                    printf(" - - . . . |");
                    break;
                    case '8':
                    printf(" - - - . . |");
                    break;
                    case '9':
                    printf(" - - - - . |");
                    break;
                    case '.':
                    printf(" . - . - . - . |");
                    break;
                    case ',':
                    printf(" - - . . - - |");
                    break;
                    case '!':
                    printf(" - - . . - |");
                    break;
                    case '?':
                    printf(" . . - - . . |");
                    break;
                    case ' ':
                    printf("|");
                    break;
                    }
        }
        n=0;
        i=0;
        printf("\n\n");
        }
        if (BTN4){
            __delay_ms(200);
            return;
        }
}
}







void PWM_motor_led(void) {
    PWM_init();
    LCD_Clear();         
    
    LED1 = 1;
    LED2 = 1;
    LED3 = 1;
    LED4 = 1;
    LED5 = 1;
    LED6 = 1;
    
    int strida;
    
    while (1){
        sprintf(nadpis1,"PMW Control     ");
        LCD_ShowString(1,nadpis1);
        GODONE = 1;                
        while(GODONE){};            
        strida=pot1/4;
        SETDUTY(strida); 
        sprintf(text, "Duty = %d             ", strida);
        LCD_ShowString(2, text);
        
        if (BTN4){          
             PSTR1CONbits.STR1B = 0;             
             TRISCbits.RC2 = 1;   
             LED1=0;
             LED2=0;
             LED3=0;
             LED4=0;
             LED5=0;
             LED6=0;    
             __delay_ms(200);
             return;
        }
    }
}






void Knight_rider_3000(void){
    LCD_Clear;
    TRISDbits.TRISD2 = 0;
    TRISDbits.TRISD3 = 0;
    TRISCbits.TRISC4 = 0;
    TRISDbits.TRISD4 = 0;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    
    LED1 = 1;
    LED2 = 1;
    LED3 = 1;
    LED4 = 1;
    LED5 = 1;
    LED6 = 1;
    
    int i=0;
    int j=2;
    
    while (1){
        sprintf(nadpis1,"Knight Rider    ");
        LCD_ShowString(1,nadpis1);
        sprintf(nadpis2,"On the way...   ");
        LCD_ShowString(2,nadpis2);
        
        for(i;i<=2;i++){
            __delay_ms(75);
            switch (i){

                    case 0:
                        LED3 = 0;
                        LED4 = 0;
                        break;      
                    case 1:
                        LED5 = 0;
                        LED2 = 0;
                        break;
                    case 2:          
                        LED6 = 0;
                        LED1 = 0;
                        break;
                    }
        if (BTN4){
         LED1 = 0;
         LED2 = 0;
         LED3 = 0;
         LED4 = 0;
         LED5 = 0;
         LED6 = 0;
         __delay_ms(200);
         return;
        }
    }
   for(j;j>=0;j--){
        switch (j){
            case 0:
               LED3 = 1;
               LED4 = 1;
               break;    
            case 1:
                LED5 = 1;
                LED2 = 1;
                break;
            case 2:
                LED6 = 1;
                LED1 = 1;
                break;
            }
        if (BTN4){
         LED1 = 0;
         LED2 = 0;
         LED3 = 0;
         LED4 = 0;
         LED5 = 0;
         LED6 = 0;
         __delay_ms(200);
         return;
        }
        __delay_ms(75);   
        }
      i=0;
      j=5; 
    } 
}







void Knight_rider_2000(void){
    LCD_Clear();
    TRISDbits.TRISD2 = 0;
    TRISDbits.TRISD3 = 0;
    TRISCbits.TRISC4 = 0;
    TRISDbits.TRISD4 = 0;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    
    LED1 = 1;
    LED2 = 1;
    LED3 = 1;
    LED4 = 1;
    LED5 = 1;
    LED6 = 1;
    
   
    int i=0;
    int j=5;
    int r=0;
    while (1){
        sprintf(nadpis1,"Knight Rider    ");
        LCD_ShowString(1,nadpis1);
        sprintf(nadpis2,"On the way...   ");
        LCD_ShowString(2,nadpis2);
        while(r<2){
        for(i;i<=5;i++){
        switch (i){
            case 0:
                LED1 ^= 1;
                break;
            case 1:
                LED2 ^= 1;
                break;
            case 2:          
                LED3 ^= 1;          
                break;
            case 3:         
                LED4 ^= 1;
                break;
            case 4:
                LED5 ^= 1;
                break;
            case 5:
                LED6 ^= 1;
                break;
            }
         if (BTN4){
         LED1 = 0;
         LED2 = 0;
         LED3 = 0;
         LED4 = 0;
         LED5 = 0;
         LED6 = 0;
         __delay_ms(200);
         return;
        }
        __delay_ms(50);
        
       }
         r++;
         i=0;
        }
        r=0;
        while(r<2){
        for(j;j>=0;j--){
        switch (j){
            case 0:
                LED1 ^= 1;
                break;
            case 1:
                LED2 ^= 1;
                break;
            case 2:
                LED3 ^= 1;
                break;
            case 3:
                LED4 ^= 1;
                break;
            case 4:         
                LED5 ^= 1;
                break;
            case 5:      
                LED6 ^= 1;
                break;
            }
         if (BTN4){
         LED1 = 0;
         LED2 = 0;
         LED3 = 0;
         LED4 = 0;
         LED5 = 0;
         LED6 = 0;
         __delay_ms(200);
         return;
        }
        __delay_ms(50);     
        }
      j=5;     
       r++;
        }
        r=0;
    } 
}







void Bargraph(void){
    Bargraph_init();
    LCD_Clear();
    
    char text[17];
    int i;
    int n;
    char graph[17];
  
    while(1){
         GODONE = 1;         
        __delay_ms(50);
        sprintf(text, "VALUE = %d       ",pot1);
        LCD_ShowString(1, text);
        
        if ((pot1>1) && (pot1<65)){
        sprintf(graph, "O               ");
        LCD_ShowString(2, graph);
        }
   
        else if ((pot1>65) && (pot1<130)){
        sprintf(graph, "OO              ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>130) && (pot1<195)){
        sprintf(graph, "OOO             ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>195) && (pot1<260)){
        sprintf(graph, "OOOO            ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>260) && (pot1<325)){
        sprintf(graph, "OOOOO           ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>325) && (pot1<390)){
        sprintf(graph, "OOOOOO          ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>390) && (pot1<455)){
        sprintf(graph, "OOOOOOO         ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>455) && (pot1<520)){
        sprintf(graph, "OOOOOOOO        ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>520) && (pot1<585)){
        sprintf(graph, "OOOOOOOOO       ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>585) && (pot1<650)){
        sprintf(graph, "OOOOOOOOOO      ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>650) && (pot1<715)){
        sprintf(graph, "OOOOOOOOOOO     ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>715) && (pot1<780)){
        sprintf(graph, "OOOOOOOOOOOO    ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>780) && (pot1<845)){
        sprintf(graph, "OOOOOOOOOOOOO   ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>845) && (pot1<910)){
        sprintf(graph, "OOOOOOOOOOOOOO  ");
        LCD_ShowString(2, graph);
        }
        else if ((pot1>910) && (pot1<975)){
        sprintf(graph, "OOOOOOOOOOOOOOO ");
        LCD_ShowString(2, graph);
        }
        else if (pot1>975){
        sprintf(graph, "OOOOOOOOOOOOOOOO");
        LCD_ShowString(2, graph);
        }
        
     if (BTN4){
         __delay_ms(200);   
         return;
        }
    }
}
      






void Pong(void){
    Pong_init();
    LCD_Clear();
    
    int P1=3;
    int P2=3;
    int i=1;
    int j=14;
    char micek[17];
    char zivoty[17];
    char gameover[17];
    char vitez[17];
    int n=0;
    int r=0;
    int z=20;
    int t=20;
    
    while(1){
             
        if (n==0){
         sprintf(zivoty,"P1 ***    *** P2");
         LCD_ShowString(1, zivoty);
        } 
        if (r==1){
            i=2;
        }
        
        for(i;i<15;i++){
            switch (i){
                
                case 1:
                    sprintf(micek,"%co             %c",219,219);
                     LCD_ShowString(2, micek);
                     r=1;
                break;
                case 2:
                    sprintf(micek,"%c o            %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 3:
                    sprintf(micek,"%c  o           %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 4:
                    sprintf(micek,"%c   o          %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 5:
                    sprintf(micek,"%c    o         %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 6:
                    sprintf(micek,"%c     o        %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 7:
                    sprintf(micek,"%c      o       %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 8:
                    sprintf(micek,"%c       o      %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 9:
                    sprintf(micek,"%c        o     %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 10:
                    sprintf(micek,"%c         o    %c",219,219);
                     LCD_ShowString(2, micek); 
                break;
                case 11:
                    sprintf(micek,"%c          o   %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 12:
                    sprintf(micek,"%c           o  %c",219,219);
                     LCD_ShowString(2, micek); 
                break;
                case 13:
                    sprintf(micek,"%c            o %c",219,219);
                     LCD_ShowString(2, micek);
                     if(BTN4){
                         TRISAbits.RA2 = 0;
                     }
                     break;
                case 14:
                    sprintf(micek,"%c             o%c",219,219);
                     LCD_ShowString(2, micek);
                     t--;
                     r=1;
                     if (!BTN4){
                         i=0;
                         P2--;
                         n=1;
                         r=0;
                         t=20;
                         z=20;
                         TRISAbits.RA2 = 1;
                         switch (P2){
                             case 2:
                                 zivoty[10]=' ';
                                 LCD_ShowString(1, zivoty);
                                 break;
                             case 1:
                                 zivoty[11]=' ';
                                 LCD_ShowString(1, zivoty);
                                 break;
                             case 0:
                                 zivoty[12]=' ';
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(500);
                                 LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                 LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                  LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                 sprintf(gameover,"   GAME OVER!   ");
                                 sprintf(vitez," PLAYER 1 WINS ");
                                 LCD_ShowString(1, gameover);
                                 LCD_ShowString(2, vitez);
                                 __delay_ms(2000);
                                 return;
                         }
                         __delay_ms(500);
                     }  
                break;
            }
                for(z;z>1;z--){
            __delay_ms(15);     
            }
            z=t;
        }
         if (r==1){
            j=13;
        }      
        for(j;j>=1;j--) {
            switch (j){
                 
                case 1:
                    sprintf(micek,"%co             %c",219,219);
                     LCD_ShowString(2, micek);
                     t--;
                     r=1;
                     if (!BTN1){
                         j=15;
                         P1--;
                         n=1;
                         r=0;
                         t=20;
                         z=20;
                         TRISCbits.RC0 = 1;
                     
                         switch (P1){
                             
                             case 2:
                                 zivoty[5]=' ';
                                 LCD_ShowString(1, zivoty);
                                 break;
                             case 1:
                                 zivoty[4]=' ';
                                 LCD_ShowString(1, zivoty);
                                 break;
                             case 0:
                                 zivoty[3]=' ';
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(500);
                                 LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                 LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                  LCD_Clear();
                                 __delay_ms(250);
                                 LCD_ShowString(1, zivoty);
                                 __delay_ms(250);
                                 sprintf(gameover,"   GAME OVER!   ");
                                 sprintf(vitez," PLAYER 2 WINS ");
                                 LCD_ShowString(1, gameover);
                                 LCD_ShowString(2, vitez);
                                 __delay_ms(2000);
                                 return;    
                         }
                      __delay_ms(500);
                      }
                     break;
                case 2:
                    sprintf(micek,"%c o            %c",219,219);
                     LCD_ShowString(2, micek);
                     if(BTN1){
                         TRISCbits.RC0 = 0;
                     }
                break;
                case 3:
                    sprintf(micek,"%c  o           %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 4:
                    sprintf(micek,"%c   o          %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 5:
                    sprintf(micek,"%c    o         %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 6:
                    sprintf(micek,"%c     o        %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 7:
                    sprintf(micek,"%c      o       %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 8:
                    sprintf(micek,"%c       o      %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 9:
                    sprintf(micek,"%c        o     %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 10:
                    sprintf(micek,"%c         o    %c",219,219);
                     LCD_ShowString(2, micek); 
                break;
                case 11:
                    sprintf(micek,"%c          o   %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 12:
                    sprintf(micek,"%c           o  %c",219,219);
                     LCD_ShowString(2, micek); 
                break;
                case 13:
                    sprintf(micek,"%c            o %c",219,219);
                     LCD_ShowString(2, micek);
                break;
                case 14:
                    sprintf(micek,"%c             o%c",219,219);
                     LCD_ShowString(2, micek);
                     r=1;
                break;
            }
            for(z;z>1;z--){
            __delay_ms(15);     
            }
            z=t;
        }
     i=1;
     j=14;
     }
    }




void putch(unsigned char data){
    while(!TX1IF);
    TXREG1 = data;
}
