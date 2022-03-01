from pyModbusTCP.client import ModbusClient

c=ModbusClient()
c.host("10.0.2.6")
c.port(502)
c.unit_id(1)

c.open()


while True:
    reg=c.read_holding_registers(300,1)
    if(reg):
        print("Weight: "+str(reg))
    else:
        print("Didnt read")


c.close()