import numpy as np


# input file
fname = "../input/freezing.txt"

# open data
freezing_data = [[d.strip() for d in line.split('\t')] for line in open(fname).readlines()]

# lenght of experiment in minutes
minutes = 12

# length of experiment in ms
experiment_length_ms = minutes*60*1000

# empty array (every element represent one ms)
data = np.zeros(experiment_length_ms)

# list of lists - every sublist is the onset-offset of freezing
freezing_episodes = freezing_data[1:]

# loop over the list of freezing episodes and update the data to 1 according to onset-offset
# !!! hardcoded values !!!
# ---> onset and offset are in column 0 and 2
# ---> values are converted to integers on the fly...
for interval in freezing_episodes:
	np.add.at(data,np.arange(int(interval[0]),int(interval[2])),1)