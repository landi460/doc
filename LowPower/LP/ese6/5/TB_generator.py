#!/usr/bin/env python
import os
from random import *



######################################################################################################################################
############################################## Insert here all the input parameters ##################################################

# Name of the component to be tested (beware of capital/small letters, they must match)
EntityName = "TestCircuit"
# Name of the file with the component (beware of capital/small letters, they must match)
# The name of the file and the name of the entity of the testbench must match
FileName = "testcircuit_test"  

# Flag used to identify if there are or not generics
GenericFlag = 1; # 1 = yes, 0 = no
# List containing the name of the generics
GenericsList = ["Nbit", "Mbit"]
# List containing the type of each generic (the first one is referred to "IN1", the second one is referred to "IN2", ...)
GenericsType = ["Integer", "Natural"]
# List containing the default value of each generic (the first one is referred to "IN1", the second one is referred to "IN2", ...)
GenericsDefaultValue = [8, 16]
# List containing the assigned value of each generic (the first one is referred to "IN1", the second one is referred to "IN2", ...)
GenericsAssignedValue = [16, 32]

# List containing the name of the signals
SignalsList = ["IN1", "IN2", "IN3", "SEL1", "OUT1", "OUT2"]
# List containing the mode of each signal (the first one is referred to "IN1", the second one is referred to "IN2", ...)
SignalsMode = ["IN", "IN", "IN", "IN", "OUT", "OUT"]
# List containing the type of each signal (the first one is referred to "IN1", the second one is referred to "IN2", ...)
SignalsType = ["std_logic_vector", "std_logic_vector", "std_logic_vector", "std_logic", "std_logic_vector", "std_logic"]
# List containing the size of each signal (the first one is referred to "IN1", the second one is referred to "IN2", ...)
SignalsSize = ["Nbit-1", "Nbit", "6", "1", "Mbit-1", "1"]
# List containing a fixed size for the inputs, for test purpose. (substitution of GenericsAssignedValue inside SignalsSize)
# (the first one is referred to "IN1", the second one is referred to "IN2", ...)
# Example if GenericAssignedValue of Nbit is 16 and SignalsSize is Nbit-1 then insert 15
# Example if GenericAssignedValue of Nbit is 16 and SignalsSize is Nbit then insert 16
# For std_logic insert 1
SignalsSizeAssigned = [15, 16, 6, 1, 31, 1]

# Number of simulation steps
NumberOfSteps = 10000
# Delay between steps
DelayBetweenSteps = "1 ns"
######################################################################################################################################







######################################################################################################################################
##################################################### File creation ##################################################################

# Creation of file name
TestbenchFileName = FileName + ".vhd"

# Clear previous version of the file
# Linux
CommandToEliminateTest = "rm ./" + TestbenchFileName
os.system(CommandToEliminateTest)
# Windows
#CommandToEliminateTest = "del " + TestbenchName
#os.system(CommandToEliminateTest) # Command used to execute external commands on the terminal

# Create and open testbench file
TestbenchFile = open(TestbenchFileName, "w")
######################################################################################################################################




######################################################################################################################################
##################################################### Libraries definition ###########################################################

# Write libraries definition 
TestbenchFile.write("library ieee;\n")   # Command used to write on a file
TestbenchFile.write("use ieee.std_logic_1164.all;\n")
TestbenchFile.write("use ieee.numeric_std.all;\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Entity creation ################################################################

# Write testbench entity
TestbenchFile.write("entity " + FileName + " is\n")
TestbenchFile.write("end " + FileName + ";\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Architecture definition ########################################################

# Architecture definition
TestbenchFile.write("architecture test of " + FileName + " is\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Component declaration ##########################################################

# Component declaration
TestbenchFile.write("component " + EntityName + "\n")
# Check if there are generics in the code
if GenericFlag == 1:
    # Write generics declaration
	TestbenchFile.write("generic (\n")
	# Check if there is only one generic
	if len(GenericsList) == 1:
		TestbenchFile.write("         " + GenericsList[0] + ": " + GenericsType[0] + ":= " + str(GenericsDefaultValue[0]) + ");\n")
	# Check if there are more then one generics
	elif len(GenericsList) > 1:
		# Loop on all generics
		for i in range(0,len(GenericsList)):
			# Check if we have reached the last element of the list
			if i != (len(GenericsList)-1):
				TestbenchFile.write("         " + GenericsList[i] + ": " + GenericsType[i] + " := " + str(GenericsDefaultValue[i]) + ";\n")
			# if we have reached the last element
			else:
				TestbenchFile.write("         " + GenericsList[len(GenericsList)-1] + ": " + GenericsType[len(GenericsList)-1] + " := " + str(GenericsDefaultValue[len(GenericsList)-1]) + ");\n")
# Write ports declaration
TestbenchFile.write("port (\n")
for i in range(0,len(SignalsList)):
	# Check if we have reached the last element of the list
	if i != (len(SignalsList)-1):
		# Check if single bit
		if SignalsType[i] == "std_logic":
			TestbenchFile.write("      " + SignalsList[i] + ": " + SignalsMode[i] + " " + SignalsType[i] + ";\n")
		# if vector
		else:
			TestbenchFile.write("      " + SignalsList[i] + ": " + SignalsMode[i] + " " + SignalsType[i] + "(" + SignalsSize[i] + " downto 0);\n")
	# if we have reached the last element
	else:
		# Check if single bit
		if SignalsType[len(SignalsList)-1] == "std_logic":
			TestbenchFile.write("      " + SignalsList[len(SignalsList)-1] + ": " + SignalsMode[len(SignalsList)-1] + " " + SignalsType[len(SignalsList)-1] + ");\n")
		# if vector
		else:
			TestbenchFile.write("      " + SignalsList[len(SignalsList)-1] + ": " + SignalsMode[len(SignalsList)-1] + " " + SignalsType[len(SignalsList)-1] + "(" + SignalsSize[len(SignalsList)-1] + " downto 0));\n")
# Closign component
TestbenchFile.write("end component;\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Signals definition #############################################################

# Loop for all signals
for i in range(0,len(SignalsList)):
	# Check if single bit
	if SignalsType[i] == "std_logic":
		TestbenchFile.write("signal " + SignalsList[i] + "_i" + ": " + SignalsType[i] + ":= '0';\n")
	# if vector
	else:
		TestbenchFile.write("signal " + SignalsList[i] + "_i" + ": " + SignalsType[i] + "(" + str(SignalsSizeAssigned[i]) + " downto 0) := (others => '0');\n")
TestbenchFile.write("\n");
######################################################################################################################################




######################################################################################################################################
##################################################### Begin architecture #############################################################

# Architecture definition
TestbenchFile.write("begin\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Component instantiation ########################################################

# Component instantiation
TestbenchFile.write("DUT:" + EntityName + "\n")
# Check if there are generics in the code
if GenericFlag == 1:
    # Write generics declaration
	TestbenchFile.write("generic map (\n")
	# Check if there is only one generic
	if len(GenericsList) == 1:
		TestbenchFile.write("             " + GenericsList[0] + "=> " + str(GenericsAssignedValue[0]) + ")\n")
	# Check if there are more then one generics
	elif len(GenericsList) > 1:
		# Loop on all generics
		for i in range(0,len(GenericsList)):
			# Check if we have reached the last element of the list
			if i != (len(GenericsList)-1):
				TestbenchFile.write("             " + GenericsList[i] + " => " + str(GenericsAssignedValue[i]) + ",\n")
			# if we have reached the last element
			else:
				TestbenchFile.write("             " + GenericsList[len(GenericsList)-1] + " => " + str(GenericsAssignedValue[len(GenericsList)-1]) + ")\n")
# Write ports declaration
TestbenchFile.write("port map (\n")
for i in range(0,len(SignalsList)):
	# Check if we have reached the last element of the list
	if i != (len(SignalsList)-1):
		TestbenchFile.write("          " + SignalsList[i] + " => " + SignalsList[i] + "_i,\n")
	# if we have reached the last element
	else:
		TestbenchFile.write("          " + SignalsList[len(SignalsList)-1] + " => " + SignalsList[len(SignalsList)-1] + "_i);\n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Generation of input signals ####################################################

# Starting process
TestbenchFile.write("TEST: process \n\n")
TestbenchFile.write("begin \n\n")

# Loop for all simulation steps
for i in range(0,NumberOfSteps):
	# Loop for all signals
	for i in range(0,len(SignalsList)):
		# Check if input signal
		if SignalsMode[i] == "IN":
			# Check if single bit
			if SignalsType[i] == "std_logic":
				RandomInputInteger = randint(1,2**SignalsSizeAssigned[i]-1)
				RandomInputBinary = ('{0:0{l}b}'.format((RandomInputInteger),l=SignalsSizeAssigned[i]))
				TestbenchFile.write("   " + SignalsList[i] + "_i <= \'" + RandomInputBinary + "\';\n")
			# Check if not single bit
			else:
				RandomInputInteger = randint(1,2**SignalsSizeAssigned[i]-1)
				RandomInputBinary = ('{0:0{l}b}'.format((RandomInputInteger),l=SignalsSizeAssigned[i]+1))
				TestbenchFile.write("   " + SignalsList[i] + "_i <= \"" + RandomInputBinary + "\";\n")
	TestbenchFile.write("   " + "wait for "	+ DelayBetweenSteps + ";\n\n")

TestbenchFile.write("wait; \n\n")
TestbenchFile.write("end process; \n\n")
######################################################################################################################################




######################################################################################################################################
##################################################### Closing architecture ###########################################################

TestbenchFile.write("end test;")



# Closing testbench file
TestbenchFile.close()
