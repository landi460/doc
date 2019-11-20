"""
A simple script used to apply Dadda algorithm to compress a generic
group of partial products. In particular, you have to generate a
matrix representing the partial products in dot notation (place dots
where a bit should be present). You also have to specify n_rows and
n_cols of the generated matrix. An example of an initial matrix is
provided.

"""

import numpy as np
import os

def print_to_file(text):
	with open("dadda_result.txt", "a+") as res:
		res.write(text)
		res.write('\n')


# Print a matrix entirely
def print_mat(mat):
	with open("dadda_result.txt", "a+") as res:
		for row in range(mat.shape[0]):
			for col in range(mat.shape[1]):
				res.write(str(mat[row][col]) + ' ')
			res.write('\n\n')

# Print an array without spaces
def print_arr(arr):
	with open("dadda_result.txt", "a+") as res:
		for col in range(arr.shape[0]):
			res.write(str(arr[col]) + ' ')
		res.write('\n\n')


def main():
	n_rows = 17
	n_cols = 64
	matrix = np.full((n_rows, n_cols), '-', dtype=np.str)
	remaining_dots = np.zeros(n_cols, dtype=np.int_)
	end = n_cols
	total_FA = 0
	total_HA = 0

	if os.path.exists("dadda_result.txt"):
		os.remove("dadda_result.txt")

	#Place dots in initial matrix
	for row in range(n_rows):
		if ((row == 0) or (row == 15)):
			start = end - 36
		elif (row == 16):
			start = end - 35
		else:
			start = end - 37
		for col in range(n_cols):
			if col >= start and col < end:
				matrix[row][col] = '•'
		if (row != 0):
			end -= 2

	# Create remaining_dots: an array containing
	# the sum of the dots for every column. It will
	# be reduced thanks to Dadda compression.
	temp = 0
	for col in range(n_cols):
		for row in range(n_rows):
			if matrix[row][col] == '•':
				temp += 1
		remaining_dots[col] = temp
		temp = 0
	print_to_file("Initial Matrix")
	print_mat(matrix)
	print_to_file("Remaining dots")
	print_arr(remaining_dots)

	# Calc the necessary number of stages and how many dots
	# there should be in every stage
	n_stages = 2
	dots_in_stage = [1, 2]
	while n_rows > (dots_in_stage[-1]*3/2):
		dots_in_stage.append(int(dots_in_stage[-1]*3/2))
		n_stages += 1
	FA_matrix = np.zeros((n_stages, n_cols), dtype=np.int_)
	HA_matrix = np.zeros((n_stages, n_cols), dtype=np.int_)
	print_to_file("Number of stages: {0} \n".format(n_stages))
	print_to_file("Max dots for every stage: {0} \n\n".format(dots_in_stage))

	# Apply Dadda compression
	for stage in range(n_stages):
		new_mat = np.full_like(matrix, '-', dtype=np.str)
		print_to_file("-" * 180)
		print_to_file("STAGE {0}".format(stage))
		max_dots = dots_in_stage[-(stage+1)]
		print_to_file("Max number of dots for every column: {0}\n".format(max_dots))
		for col in range(n_cols-1, -1, -1):
			if remaining_dots[col] > max_dots:
				diff = remaining_dots[col] - max_dots
				new_FA = int(diff/2)
				FA_matrix[stage][col] = new_FA
				total_FA += new_FA
				if diff%2 != 0:
					HA_matrix[stage][col] = 1
					total_HA += 1
					remaining_dots[col-1] += 1
				remaining_dots[col] = max_dots
				remaining_dots[col-1] += new_FA
			dots_temp = remaining_dots[col]
			if dots_temp > 0:
				for row in range(n_rows):
					if dots_temp <= 0:
						break
					if new_mat[row][col] != '•':
						new_mat[row][col] = '•'
						dots_temp -= 1

		print_to_file("New Dots Matrix")
		print_mat(new_mat)
		print_to_file("FA_matrix")
		print_mat(FA_matrix)
		print_to_file("HA_matrix")
		print_mat(HA_matrix)
		if stage != (n_stages-1):
			print_to_file("Remaining Dots")
			print_arr(remaining_dots)
		print_to_file("total_FA= {0}, total_HA= {1}".format(total_FA, total_HA))
		print_to_file("")
		

main()
