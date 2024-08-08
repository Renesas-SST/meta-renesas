#!/usr/bin/python3

# Imports
import serial
import argparse
import time
import os
import zipfile
import subprocess
from subprocess import Popen, PIPE, CalledProcessError
from sys import platform
import glob
import shlex

class FlashUtil:
	def __init__(self):
		self.__scriptDir = os.getcwd()
		self.__rootDir = os.path.abspath(os.path.join(self.__scriptDir, '..', '..', '..', '..'))
		self.__imagesDir = os.path.abspath(os.path.join(self.__rootDir, 'target', 'images'))
		
		self.__setupArgumentParser()

		self.__setupSerialPort()
		self.__writeBootloader()

	# Setup CLI parser
	def __setupArgumentParser(self):
		# Create parser
		self.__parser = argparse.ArgumentParser(description='Utility to flash bootloader on RZ SBC Board.\n', epilog='Example:\n\t./bootloader_flash.py')

		# Add arguments
		# Serial port arguments
		self.__parser.add_argument('--serial_port', default='/dev/ttyUSB0', dest='serialPort', action='store', help='Serial port used to talk to board (defaults to: /dev/ttyUSB0).')
		self.__parser.add_argument('--serial_port_baud', default=115200, dest='baudRate', action='store', type=int, help='Baud rate for serial port (defaults to: 115200).')

		# Images
		self.__parser.add_argument('--image_writer', default=f'{self.__imagesDir}/Flash_Writer_SCIF_rzpi.mot', dest='flashWriterImage', action='store', type=str, help="Path to Flash Writer image (defaults to: <path/to/your/package>/target/images/Flash_Writer_SCIF_rzpi.mot).")
		self.__parser.add_argument('--image_bl2', default=f'{self.__imagesDir}/bl2_bp-rzpi.srec', dest='bl2Image', action='store', type=str, help='Path to bl2 image (defaults to: <path/to/your/package>/target/images/bl2_bp-rzpi.srec).')
		self.__parser.add_argument('--image_fip', default=f'{self.__imagesDir}/fip-rzpi.srec', dest='fipImage', action='store', type=str, help='Path to FIP image (defaults to: <path/to/your/package>/target/images/fip-rzpi.srec).')

		self.__args = self.__parser.parse_args()

	# Setup Serial Port
	def __setupSerialPort(self):
		try:
			self.__serialPort = serial.Serial(port=self.__args.serialPort, baudrate = self.__args.baudRate, timeout=15)
		except:
			die(msg='Unable to open serial port.')

	# Setup Serial Port SUP
	def __setupSerialPort_SUP(self):
		try:
			self.__serialPort = serial.Serial(port=self.__args.serialPort, baudrate = 921600, timeout=15)
		except:
			die(msg='Unable to open serial port 921600 bps.')

	# Function to write bootloader
	def __writeBootloader(self):
		start_time = time.time()

		# Check file exists
		if not os.path.exists(self.__args.flashWriterImage):
			print(f"The file {self.__args.flashWriterImage} does not exist.")
			exit()
		if not os.path.exists(self.__args.bl2Image):
			print(f"The file {self.__args.bl2Image} does not exist.")
			exit()
		if not os.path.exists(self.__args.fipImage):
			print(f"The file {self.__args.fipImage} does not exist.")
			exit()

		# Wait for device to be ready to receive image.
		print("Please power on board. Make sure you changed switches to SCIF download mode.")
		buf = self.__serialPort.read_until('please send !'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		# Write flash writer application
		time1 = time.time()
		print("Writing Flash Writer application...")
		self.__writeFileToSerial(self.__args.flashWriterImage)
		buf = self.__serialPort.read_until('>'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		time2 = time.time()
		elapsed_time = time2 - time1
		print(f"Elapsed time: Flash Writer: {elapsed_time:.6f} seconds")
		# Changing speed to 921600 bps.
		self.__serialPort.write('true\r'.encode())
		buf = self.__serialPort.read_until('>'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('SUP\r'.encode())
		buf = self.__serialPort.read_until('the terminal.'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__setupSerialPort_SUP()
		time.sleep(1)
		self.__serialPort.write('\r\r'.encode())
		buf = self.__serialPort.read_until('>'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		# Write BL2
		self.__serialPort.write('\rXLS2\r'.encode())
		buf = self.__serialPort.read_until('Please Input : H'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('11E00\r'.encode())
		buf = self.__serialPort.read_until('Please Input : H'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('\r00000\r'.encode())
		buf = self.__serialPort.read_until('please send !'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		print("Writing BL2...")
		self.__writeFileToSerial(self.__args.bl2Image)
		buf = self.__serialPort.read_until('Clear OK'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('\ry\r'.encode())
		buf = self.__serialPort.read_until('>'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		# Write FIP
		self.__serialPort.write('XLS2\r'.encode())
		buf = self.__serialPort.read_until('Please Input : H'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('00000\r'.encode())
		buf = self.__serialPort.read_until('Please Input : H'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('1D200\r'.encode())
		buf = self.__serialPort.read_until('please send !'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		print("Writing fip ...")
		self.__writeFileToSerial(self.__args.fipImage)
		buf = self.__serialPort.read_until('Clear OK'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		self.__serialPort.write('\ry\r'.encode())
		buf = self.__serialPort.read_until('>'.encode())
		if not buf:
			print("Returned value is not the expectation. Exiting.")
			exit()
		print(f'{buf.decode()}')

		print("Closed serial port.")
		self.__serialPort.close()

		end_time = time.time()
		elapsed_time = end_time - start_time
		print(f"Elapsed time: {elapsed_time:.6f} seconds")

	def __writeSerialCmd(self, cmd):
		self.__serialPort.write(f'{cmd}\r'.encode())

	# Function to write file over serial
	def __writeFileToSerial(self, file):
		with open(file, 'rb') as f:
			self.__serialPort.write(f.read())
			f.close()

	# Function to wait and print contents of serial buffer
	def __serialRead(self, cond='\n', print=False):
		buf = self.__serialPort.read_until(cond.encode())

		if print:
			print(f'{buf.decode()}')

# Util function to die with error
def die(msg='', code=1):
	print(f'Error: {msg}')
	exit(code)

def main():
	flashUtil = FlashUtil()

if __name__ == '__main__':
	main()
