#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 29 10:07:02 2017

@author: lex
"""

import numpy as np
from Path import Path
from angle_analysis import ProjectionVector,findAngle
from load_coordinates import loadData
#import matplotlib.pyplot as plt


#coordinates = loadData('../data/with_food_test.txt')
coordinates = loadData('../data/with_food_test_2.txt')
#coordinates = loadData('../data/water_test.txt')

# read in coordinates and convert to path object
p = Path(coordinates)


scale = np.arange(0.025,1.025,0.025)

curvatures = []

for unit_step in scale:

    # subset path in segments in unit_steps
    p.subsetPath(unit_step)


    # list of projection vectors (minus the last vector, not to be used)
    projections = [ProjectionVector([segment[0],segment[-1]]) for segment in p.segmented_coordinates[0:-1]]


    # list of segments to be used for calculation (minus the first segment, not to be used)
    segments = [[i[0],i[-1]] for i in p.segmented_coordinates[1:]]

    # build list of angle values
#    raw_angles = []
#    if len(projections) == len(segments):
#        for i in range(len(projections)):
#        		raw_angles.append(findAngle(segments[i],projections[i]))

    # Build list of angles (same as above but faster)
    raw_angles =[findAngle(segments[i],projections[i]) for i in range(len(projections)) if len(projections) == len(segments)]                

    # list of curvatures
    curvature = np.abs(raw_angles)/unit_step

    curvatures.append(np.median(curvature)/100)

#plt.ylim(0, 10)
#plt.hist(curvature/100, bins=15,color="#4a7ac0")
#plt.show()
#print(np.median(curvature/100))

