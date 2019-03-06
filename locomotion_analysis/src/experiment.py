#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 21 15:17:57 2017

@author: lex
"""
import numpy as np
from Path import Path
from angle_analysis import ProjectionVector,findAngle
from load_coordinates import loadData
import matplotlib.pyplot as plt


coordinates = loadData('../data/with_food_test.txt')
#coordinates = loadData('../data/water_test.txt')

# read in coordinates and convert to path object
p = Path(coordinates)

unit_step = 0.0124

# subset path in segments in unit_steps
p.subsetPath(unit_step)


# list of projection vectors (minus the last vector, not to be used)
projections = [ProjectionVector([segment[0],segment[-1]]) for segment in p.segmented_coordinates[0:-1]]


# list of segments to be used for calculation (minus the first segment, not to be used)
segments = [[i[0],i[-1]] for i in p.segmented_coordinates[1:]]

# build list of angle values
raw_angles = []
if len(projections) == len(segments):
    for i in range(len(projections)):
    		raw_angles.append(findAngle(segments[i],projections[i]))


curvature = np.abs(raw_angles)/unit_step

plt.ylim(0, 10)
plt.hist(curvature/100, bins=15,color="#4a7ac0")
plt.show()
print(np.median(curvature/100))

