import tkinter as tk
from tkinter import ttk

#def on_combobox_change(event):
#  selected_value = opravy.current()
#  selected_text = options
 #   print(selected_text)
#    message_fix4.config(text=f"{selected_text[selected_value]}")



def on_combobox1_change(event):
    # Get the selected value from combobox1
    selected_value = opravy.current()
    # Set the value of combobox2 to the selected value from combobox1
    message_fix2.current(selected_value)
    message_fixpoly.current(selected_value)



class CRC:

    def __init__(self):
        self.cdw = ''

    
    def start(self):  # Fix method name and add self parameter
        nk = input('Zvolte si CRC3 nebo CRC4')

        if nk == '0':
            k = 4
            n = 7
            data = input('Vložte zprávu o délce 4 bit: \n')
            gen_poly = input('Zvolte si generující polynom: \n 1 pro 1101 \n 2 pro 1011 \n')
            if gen_poly == '1':
                key_value = '1101'
            elif gen_poly == '2':
                key_value = '1011'
        elif nk == '1':
            k = 11
            n = 15
            data = input('Vložte zprávu o délce 11 bit: \n')
            gen_poly = input('Zvolte si generující polynom: \n 1 pro 10011 \n 2 pro 11001 \n 3 pro 11111 \n')
            if gen_poly == '1':
                key_value = '10011'
            elif gen_poly == '2':
                key_value = '11001'
            elif gen_poly == '3':
                key_value = '11111'
        return data, key_value
    

    def encodedData(self):
        text = message_en_entry.get()
        if any(char not in ('0', '1') for char in text):
            error_label1.config(text="Vkládejte pouze znaky 1 a 0")
            message_sentpoly.config(text=" ")
            message_sentx.config(text=" ")
            vyber_polynomu2.config(text=" ")
            message_labelpoly.config(text="  ")
            message_en_entry.delete(0, tk.END)
            return
        error_label1.config(text="  ")
        data = message_en_entry.get()
        if not data:
            error_label1.config(text="Vložte zprávu")
            message_sentpoly.config(text=" ")
            message_sentx.config(text=" ")
            vyber_polynomu2.config(text=" ")
            message_labelpoly.config(text="  ")
            return
        data_poly=self.polynom(data)
        message_labelpoly.config(text=data_poly)
        if crc1.instate(['selected']) and not crc2.instate(['selected']):
            key='1011'
            vyber_polynomu2.config(text="1011")
        elif crc2.instate(['selected']) and not crc1.instate(['selected']):
            key='11001'
            vyber_polynomu2.config(text="11001")
        elif crc2.instate(['selected']) and crc1.instate(['selected']):
            error_label1.config(text="Může být zvolen pouze jeden typ CRC")
            message_sentpoly.config(text=" ")
            message_sentx.config(text=" ")
            vyber_polynomu2.config(text=" ")
            message_labelpoly.config(text="  ")
            return
        elif not crc2.instate(['selected']) and not crc1.instate(['selected']):
            error_label1.config(text="Zvolte typ CRC")
            message_sentpoly.config(text=" ")
            message_sentx.config(text=" ")
            vyber_polynomu2.config(text=" ")
            message_labelpoly.config(text="  ")
            return
        l_key = len(key)
        append_data = data + '0' * (l_key - 1)
        remainder = self.crc(append_data, key)
        codeword = data + remainder
        self.cdw += codeword
        message_sentx.config(text=codeword)
        message_poly=self.polynom(codeword)
        message_sentpoly.config(text=message_poly)
        

    def decodedData(self):
        text = message_de_entry.get()
        if any(char not in ('0', '1') for char in text):
            error_label2.config(text="Vkládejte pouze znaky 1 a 0")
            message_label2poly.config(text='')
            message_label3poly.config(text='')
            opravy.config(values=[''])
            opravy.current(0)
            opravy2.config(text='')
            message_fixpoly.config(values=[''])
            message_fixpoly.current(0)
            message_fix2.config(values=[''])
            message_fix2.current(0)
            message_de_entry2.delete(0, tk.END)
            message_de_entry.delete(0, tk.END)
            return
        
        text = message_de_entry2.get()
        if any(char not in ('0', '1') for char in text):
            error_label2.config(text="Vkládejte pouze znaky 1 a 0")
            message_label2poly.config(text='')
            message_label3poly.config(text='')
            opravy.config(values=[''])
            opravy.current(0)
            opravy2.config(text='')
            message_fixpoly.config(values=[''])
            message_fixpoly.current(0)
            message_fix2.config(values=[''])
            message_fix2.current(0)
            message_de_entry.delete(0, tk.END)
            message_de_entry2.delete(0, tk.END)
            return

        if len(message_de_entry.get())<11:
            l=3
        elif len(message_de_entry.get())>10:
            l=4
        key = message_de_entry2.get()
        key_poly=self.polynom(key)
        message_label3poly.config(text=key_poly)
        data = message_de_entry.get()
        data_poly=self.polynom(data)
        message_label2poly.config(text=data_poly)
        remainder = self.crc(data,key)
        if remainder == '000' or remainder == '0000':
            message_fix2.config(values=[''])
            message_fixpoly.config(values=[''])
            opravy.config(values=[''])
            message=data[:-l]
            opravy2.config(text='Ne, Zpráva nebyla poškozena')
            message_fix2.config(values=message)
            message_fix2.current(0)
            message_poly=self.polynom(message)
            message_fixpoly.config(values=[message_poly])
            message_fixpoly.current(0)
            return
        else: 
            o=0
            opravy_values=[]
            oprava_vysledek=[]
            oprava_vysledek_poly=[]
            for i in range(len(data)):
                flipped_data = data[:i] + str(1 - int(data[i])) + data[i+1:]
                new_remainder = self.crc(flipped_data, key)
                if new_remainder == '000' or new_remainder == '0000':
                    o=o+1
                    if o>1:
                        opravy2.config(text=f'Ano, jsou {o} možné opravy')
                    else:
                        opravy2.config(text='Ne, Pouze jedna oprava')
                    opravy_values.append(f'Chyba v bitu {i + 1}')
                    opravy.config(values=opravy_values)
                    opravy.set(opravy_values[0])
                    oprava_vysledek.append(f'Opraveno na {flipped_data[:-l]}')
                    message_fix2.config(values=oprava_vysledek)
                    message_fix2.set(oprava_vysledek[0])
                    message_poly=self.polynom(flipped_data[:-l])
                    oprava_vysledek_poly.append(message_poly)
                    message_fixpoly.config(values=oprava_vysledek_poly)
                    message_fixpoly.set(oprava_vysledek_poly[0])
                

    def crc(self, message, key):
            pick = len(key)
            tmp = message[:pick]

            while pick < len(message):
                if tmp[0] == '1':
                    tmp = self.devide(key, tmp) + message[pick]
                else:
                    tmp = self.devide('0' * pick, tmp) + message[pick]

                pick += 1

            if tmp[0] == "1":
                tmp = self.devide(key, tmp)
            else:
                tmp = self.devide('0' * pick, tmp)

            checkword = tmp
            return checkword

    def devide(self, a, b):
        result = []
        for i in range(1, len(b)):
            if a[i] == b[i]:
                result.append('0')
            else:
                result.append('1')

        return ''.join(result)
    
    def polynom(self,string):
        degree = len(string) - 1
        polynomial = ""

        for i, bit in enumerate(string):
            if bit == '1':
                if i == degree:
                
                    polynomial += '1'
                else:
                    polynomial += f"x^{degree-i} + "

        if polynomial.endswith(" + "):
            polynomial = polynomial[:-3]

        return polynomial


#GUI
window = tk.Tk()
window.title("CRC Encoder/Decoder")
window.resizable(False, False)
frame = tk.Frame(window)
frame.pack()


encode_frame = tk.LabelFrame(frame, text="Encoder", borderwidth=5)
encode_frame.grid(row=0, column=0, padx=50,pady=10)
decode_frame = tk.LabelFrame(frame, text="Decoder", borderwidth=5)
decode_frame.grid(row=0, column=1,padx=50,pady=10)

error_label1 = tk.Label(frame, text='')
error_label1.grid(row=3,  column=0,padx=10,pady=10)

error_label2 = tk.Label(frame, text='')
error_label2.grid(row=3,  column=1,padx=10,pady=10)

message_label = tk.Label(encode_frame, text="Vložte zprávu:")
message_label.grid(row=0, column=0)

message_labelpoly = tk.Label(encode_frame, text="               ")
message_labelpoly.grid(row=1, column=1)

message_label2 = tk.Label(decode_frame, text="Vložte zprávu:")
message_label2.grid(row=0, column=0)

message_label2poly = tk.Label(decode_frame, text="             ")
message_label2poly.grid(row=1, column=1)

message_label3 = tk.Label(decode_frame, text="Vložte generující polynom:")
message_label3.grid(row=2, column=0)

message_label3poly = tk.Label(decode_frame, text="              ")
message_label3poly.grid(row=3, column=1)


message_en_entry = tk.Entry(encode_frame)
message_de_entry = tk.Entry(decode_frame)
message_de_entry2 = tk.Entry(decode_frame)
message_en_entry.grid(row=0,column=1,columnspan=2, pady=5,padx=10)
message_de_entry.grid(row=0,column=1, pady=5, padx=10)
message_de_entry2.grid(row=2,column=1, pady=5, padx=10)

crc_label = tk.Label(encode_frame, text="Zvolte typ CRC:")
crc_label.grid(row=2, column=0)

message_sentpoly = tk.Label(encode_frame, text="            ")
message_sentpoly.grid(row=2, column=1,pady=5, padx=10)

vyber_polynomu = tk.Label(encode_frame, text="Zvolený polynom")
vyber_polynomu.grid(row=3, column=0,pady=5, padx=10)

vyber_polynomu2 = tk.Label(encode_frame, text="         ")
vyber_polynomu2.grid(row=3, column=1,pady=5, padx=10)

message_sent = tk.Label(encode_frame, text="Odeslaná zpráva:")
message_sent.grid(row=4, column=0,pady=5, padx=10)

message_sentpoly = tk.Label(encode_frame, text="                ")
message_sentpoly.grid(row=5, column=1,pady=5, padx=10)

message_sentx = tk.Label(encode_frame, text="")
message_sentx.grid(row=4, column=1,pady=5)

opravy = tk.Label(decode_frame, text="Více možných oprav?")
opravy.grid(row=4, column=0,pady=5, padx=10)

opravy2 = tk.Label(decode_frame, text="")
opravy2.grid(row=4, column=1,pady=5, padx=10)

message_miss = tk.Label(decode_frame, text="Detekce chyby:")
message_miss.grid(row=5, column=0,pady=5, padx=10)


message_fix = tk.Label(decode_frame, text="Přijatá zpráva:")
message_fix.grid(row=6, column=0,pady=5, padx=10)

message_fixpoly = ttk.Combobox(decode_frame, values=[],width=80)
message_fixpoly.grid(row=7, column=1,pady=5, padx=10)
message_fixpoly.config(justify="center")
message_fixpoly['state'] = 'readonly'

message_fix2 = ttk.Combobox(decode_frame, values=[],width=30)
message_fix2.grid(row=6, column=1,pady=5)
message_fix2.config(justify="center")
message_fix2['state'] = 'readonly'

button_encode = tk.Button(frame, text="Zakódovat", command=CRC().encodedData)
button_encode.grid(row=1, column=0,padx=10,pady=20)
button_decode = tk.Button(frame, text="Dekódovat", command=CRC().decodedData)
button_decode.grid(row=1, column=1,padx=10,pady=20)

crc_frame = tk.LabelFrame(encode_frame, borderwidth=0)
crc_frame.grid(row=2, column=1)

crc1 = ttk.Checkbutton(crc_frame, text='CRC-3',state=tk.ACTIVE)
crc1.grid(row=0, column=0)
crc2 = ttk.Checkbutton(crc_frame, text='CRC-4')
crc2.grid(row=0, column=1)

opravy=ttk.Combobox(decode_frame, values=[],width=30)
opravy.grid(row=5, column=1,pady=5)
opravy.bind("<<ComboboxSelected>>", on_combobox1_change)
opravy.config(justify="center")
opravy['state'] = 'readonly'

window.mainloop()
