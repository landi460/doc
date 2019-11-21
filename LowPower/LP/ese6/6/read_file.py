#!/usr/bin/env python
import os
from random import *



######################################################################################################################################
############################################## Insert here all the input parameters ##################################################

# Name of the file
Filename = "file_INPUTS.txt";
######################################################################################################################################


######################################################################################################################################
############################################## Read values ###########################################################################

# Open file and acquire data 
with open(Filename, "r") as f:
	InputsBinary = [x.strip().split() for x in f]

# Creation of a matrix to store values converted in decimal
InputsDecimal = InputsBinary

# Calculation of matrix size
width = len(InputsBinary[0])
height = len(InputsBinary)

# Conversion of values from binary to decimal
for i in range(0, height):
	for j in range(0, width):
		InputsDecimal[i][j] = [int(InputsBinary[i][j], 2)]