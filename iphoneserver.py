from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor

import RPi.GPIO as GPIO
import os
import subprocess as sub
import commands as cmds

GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
GPIO.setup(7, GPIO.OUT) ## Setup GPIO Pin 7 to OUT

def get_gpu_temp():
		gpu_temp = cmds.getoutput( '/opt/vc/bin/vcgencmd measure_temp' ).replace( 'temp=', '' ).replace( '\'C', '' )
		return float(1.8 * float(gpu_temp))+32

class RaspberryLight(Protocol):
	def connectionMade(self):
		self.transport.write("""PI Connected""")
		self.factory.clients.append(self)
		print "clients are ", self.factory.clients

	def connectionLost(self, reason):
		print "connection lost ", self.factory.clients
		self.factory.clients.remove(self)


	def dataReceived(self, data):
		msg = ""

		if (data == 'P7H'):
			msg = "Pin 7 is now High"
			self.transport.write("""Lights ON""")
			GPIO.output(7, True)

		elif (data == 'P7L'):
			msg = "Pin 7 is now Low"
			self.transport.write("""Lights OFF""")
			GPIO.output(7, False)

		if (data == 'reboot'):
			msg = "REBOOTING"
			self.transport.write(msg)
			os.system('reboot')

		if (data == 'shutdown'):
			msg = "SHUTTING DOWN"
			os.system('sudo shutdown now -h')

		if(data == 'users'):
			msg = "Getting Users"
			self.transport.write("""Getting Users..\n""")
			p = sub.Popen('who',stdout=sub.PIPE,stderr=sub.PIPE)
			output, errors = p.communicate()
			self.transport.write(output)

		if(data == 'temp'):
			msg = "Getting Temperature\n"
#			p = sub.check_output(["/opt/vc/bin/vcgencmd","measure_temp"])
#			self.transport.write(msg + p.split('=')[1])
			self.transport.write(msg + str(get_gpu_temp()) + " F")


			print msg

factory = Factory()
factory.protocol = RaspberryLight
factory.clients = []

reactor.listenTCP(7777, factory)
print "RaspberryLight server started"
reactor.run()
