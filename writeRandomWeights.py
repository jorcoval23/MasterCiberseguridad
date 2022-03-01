from pyModbusTCP.client import ModbusClient
import random

c=ModbusClient()
c.host("10.0.2.6")
c.port(502)
c.unit_id(1)

c.open()

weight=100
while True:
    newItem=c.read_discrete_inputs(801,1)[0]

    if newItem==True:
        weight=random.randint(100,1000)

        is_ok=c.write_single_register(300,weight)
        if(is_ok):
            print("Wrote weight "+str(weight))
        else:
            print("Didnt write")


c.close()