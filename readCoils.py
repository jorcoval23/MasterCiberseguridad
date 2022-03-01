from pyModbusTCP.client import ModbusClient

c=ModbusClient()
c.host("10.0.2.6")
c.port(502)
c.unit_id(1)

c.open()


while True:
    coils=c.read_coils(800,8)
    if(coils):
        print(coils)
    else:
        print("Didnt read")

c.close()