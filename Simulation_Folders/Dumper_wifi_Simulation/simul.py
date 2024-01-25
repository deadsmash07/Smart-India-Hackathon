import random
import math

factor=4

total_time_s=1000

wheel_count=1

increase=4

decrease=6

def gauss(mu, sigma):
  """Returns a random number drawn from a Gaussian distribution."""
  z = random.uniform(0, 1)
  u1 = -math.log(z)
  u2 = random.uniform(0, 1)
  v = math.sqrt(2*u1)*math.cos(2*math.pi*u2)
  return mu + sigma*v

def time_data(randomization=False):
    if not randomization:
        loading_time=127.38
        moving_time_loaded=284.76
        moving_time_empty=216.66
        dumping_time=52.5
        waiting_time=64.61
        spotting_time_load=29.45
        spotting_time_dump=26.6
    
    else:
        loading_time=81+84*random.betavariate(5,4)
        moving_time_loaded=253.285+76.5*random.betavariate(7,10)
        moving_time_empty=192.72+76.5*random.betavariate(7,10)
        dumping_time=22+48*random.betavariate(9,5)
        waiting_time=279*random.betavariate(3,10)
        spotting_time_load=8+60*random.betavariate(1,2)
        spotting_time_dump=10+46*random.betavariate(1,2)
        
    return [loading_time, moving_time_loaded, spotting_time_dump, dumping_time, moving_time_empty, waiting_time, spotting_time_load]

def max_data(randomization):
    if not randomization:
        return 20
    else:
        return 19.5+random.betavariate(1,1)

def min_data(randomization):
    if not randomization:
        return 0
    if randomization:
        return 0.1*random.betavariate(1,1)
    
def capacity_data(randomization=False):
    l={}
    max=[]
    min=[]
    for _ in range(wheel_count):
        max.append(max_data(randomization))
        min.append(min_data(randomization))
    l["max"]=max
    l["min"]=min
    return l

def time_state(time_list, vartime):
    current=vartime
    loading_time=time_list[0]
    dumping_time=time_list[3]
    
    total=sum(time_list)
    
    current%=total

    i=0

    while i<len(time_list):
        if current>time_list[i]: 
            current-=time_list[i]
            i+=1
        else: break
    state=""
    if i==1 or i==2: state="max"
    elif i==4 or i==5 or i==6: state="min"
    elif i==0: 
        # value= (min_capacity+(max_capacity-min_capacity)*(current/loading_time))
        # difference=(max_capacity-min_capacity)/factor
        time_difference=loading_time/factor
        j=0
        while current>time_difference:
            j+=1
            current-=time_difference
        state=str(j)
    elif i==3: state="dump"

    return state, current, dumping_time

def load_sensor(state, current, dumping_time, max_capacity, min_capacity):
    value=0
    if state=="max": value=max_capacity
    elif state=="min": value=min_capacity
    elif state=="dump":
        value= (max_capacity-(max_capacity-min_capacity)*(current/dumping_time))
    else:
        difference=(max_capacity-min_capacity)/factor
        value=min_capacity+difference*int(state)
    value=max(0,gauss(value, 0.3))
    return ((value*100)//1)/100

# serial_port = serial.Serial('COM1', baudrate=9600, timeout=1)

time_list=time_data()
capacities=capacity_data()



def sensorData(loading_status,timeIncrement=5):
    if(loading_status=="over"):
        for _ in range(len(capacities["max"])):
            capacities["max"][_]+=increase
    elif loading_status=="under":
        for _ in range(len(capacities["max"])):
            capacities["max"][_]-=decrease
    count=0
    while True:
        state, current, dumping_time=time_state(time_list, count*1)
        yield load_sensor(state, current, dumping_time, capacities["max"][0], capacities["min"][0])
        count+=timeIncrement
