import machine
import network
import time
import socket
import json

import simul
import shovelCreds

serverIP = ('192.168.4.1',80)
wifi = network.WLAN(network.STA_IF)

wifi.active(False)
print('Wifi turned OFF')

global s
global socketExists
socketExists = False

def createSocket():
    global s
    if wifi.isconnected():
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((serverIP[0],serverIP[1]))
    else:
        pass
    socketExists = True
    
    
def sendToShovel(load):
    global s
    if not socketExists:
        createSocket()
    
    data = {'method':'POST','dumperID':'DumperID 10390', 'load':str(load)}
    data = json.dumps(data)
    a = s.write(str(data).encode('utf-8'))
    #print(a)
    s.close()
    print("Sent data:", data)
    print(load)
    

def correctNetwork():
    return True

    
def initiateTranser():
    current = time.ticks_ms()
    uart = UART(0, baudrate=9600)
    uart.write('ready')
    
    while True:
        if time.ticks_ms() - current > 9000:
            uart.write('get')
            if uart.any()>0:
                data = uart.read()
            else:
                continue
            print(data)
            sendToShovel(data)
            #sendToInternet(data)
            current = time.ticks_ms()
        
def initiateTransferSimulated():
    current = time.ticks_ms()
    sensorData = simul.sensorData('over',10)
    while True:
        if time.ticks_ms() - current > 3000:    
            data = next(sensorData)
            sendToShovel(data)
            #sendToInternet(data)
            current = time.ticks_ms()
        

while True:
    if not wifi.active():
        wifi.active(True)
        
    #print(1)
    if wifi.isconnected():
        wifi.active(False)
        time.sleep(0.01)
        wifi.active(True)
        
    availableNetworks = wifi.scan()
    for availableNetwork in availableNetworks:
        if availableNetwork[0] in shovelCreds.creds:
            ssid = availableNetwork[0]
            password = shovelCreds.creds[ssid]
            
        else:
            continue
        
        wifi.connect(ssid,password)
        current = time.ticks_ms()
        
        failedConnection = False
        print('trying for '+str(ssid))
        
        while not wifi.isconnected():
            if time.ticks_ms()-current>5000:
                print('inability to connect to '+str(ssid))
                failedConnection = True
                wifi.active(False)
                break
            
        if failedConnection:
            continue
        
        if not correctNetwork():
            continue
        
        print('Connected')
        print(wifi.ifconfig())
        initiateTransferSimulated()
        

        
        
