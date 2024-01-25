import socket
import network
import time
import machine
from machine import Pin, SoftI2C
import ssd1306
import json
import ufirebase as firebase

GLOB_WLAN=network.WLAN(network.STA_IF)
GLOB_WLAN.active(True)
GLOB_WLAN.connect("Easy", "12345678")

while not GLOB_WLAN.isconnected():
  pass

firebase.setURL("https://elevate-d0ba0-default-rtdb.firebaseio.com/")

print("starting")


    
maxload = 14
i2c = SoftI2C(scl=Pin(4), sda=Pin(5))
oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, i2c)

load = None
dumper_max = 15
print("flash initialised")
oled.fill(1)
oled.show()
time.sleep(0.5)
oled.fill(0)
oled.show()



ap = network.WLAN(network.AP_IF)
ap.active(False)
time.sleep(0.1)
ap.active(True)
ap.config(essid="myssid", password="anmolgoel12",authmode=3)

server_ip = '192.168.4.1'

while ap.ifconfig()[0] == '0.0.0.0':
    time.sleep(0.1)
    
server_port = 80 
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((server_ip, server_port))
server_socket.listen(10)

print("Dumper Server listening on {}:{}".format(server_ip, server_port))


timer = machine.Timer(0)
def sendToCloud(timer):
    #implement gps
    pass
timer.init(period=5000, mode=machine.Timer.PERIODIC, callback=sendToCloud)

while True:
    try:
        oled.fill(0)
        oled.text("working",0,0,1)
        oled.show()
        time.sleep(1)
        if gc.mem_free() < 102000:
            gc.collect()
        
        
        client, client_address = server_socket.accept()
        client.settimeout(3.0)
        
        print("Connection from:", client_address)
        request = client.recv(1024)
        request= request.decode('utf-8')
        data = request
        
        print(data)
        if False:
            client.send('HTTP/1.1 200 OK\n')
            client.send("Content-type:text/html")
            if load == None:
                load = 0
            response = user_page(dumperid,load/maxLoad*100)
            client.send('Connection: close\n\n')
            client.sendall(response)
            client.close()
            
        else:
            data = json.loads(request)
            client.send('HTTP/1.1 200 OK\n')
            client.send('Connection: close\n\n')
            load = data['load']
            dumperid = data['dumperID']
            print(load)
            firebase.put(dumperid,{"load":load},bg=0)
            oled.fill(0)
            oled.text(str(load),0,0,1)
            oled.show()
            time.sleep(1)
            client.close()
            
            
    except OSError as e:
        client.close()
        print('Connection closed')
        
            
    
            
print("done")