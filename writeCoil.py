from pyModbusTCP.client import ModbusClient

c=ModbusClient()
c.host("10.0.2.6")
c.port(502)
c.unit_id(1)

c.open()


while True:
    is_ok=c.write_single_coil(802,1)
    if(is_ok):
        print("Wrote go to left")
    else:
        print("Didnt write")


c.close()