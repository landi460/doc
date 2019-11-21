#!/usr/bin/env python
import os
from random import *



######################################################################################################################################
############################################## Insert here all the input parameters ##################################################

# Number of signals
SignalsNumber = 4

# List containing the parallelism of each signal (the first one is referred to "IN1", the second one is referred to "IN2", ...)
GenericsAssignedValue = [16, 32, 1, 8]

# Number of steps
NumberOfSteps = 100

# Name of the file
Filename = "file_INPUTS.txt";
######################################################################################################################################







######################################################################################################################################
##################################################### File creation ##################################################################

# Clear previous version of the file
# Linux
CommandToEliminateTest = "rm ./" + Filename
os.system(CommandToEliminateTest)
# Windows
#CommandToEliminateTest = "del " + Filename
#os.system(CommandToEliminateTest) # Command used to execute external commands on the terminal

# Create and open file
Filepointer = open(Filename, "w")
######################################################################################################################################




######################################################################################################################################
##################################################### Generate numbers ###############################################################
# Loop for all steps
for i in range(0,NumberOfSteps):
	# Loop for all signals
	for i in range (0, SignalsNumber):
		# Generate integer number
		RandomInputInteger = randint(1,2**GenericsAssignedValue[i]-1)
		# Convert number to binary
		RandomInputBinary = ('{0:0{l}b}'.format((RandomInputInteger),l=GenericsAssignedValue[i]))
		# Write file
		Filepointer.write(RandomInputBinary + " ")
	# Write line termination
	Filepointer.write("\n")


# Closing testbench file
Filepointer.close()
