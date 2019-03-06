#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 13 10:21:49 2017

@author: Leonardo Restivo
"""

import numpy as np
from Path import Path
from angle_analysis import ProjectionVector,find_angle

#import matplotlib.pyplot as plt

def compute_curvature(list_of_coordinates, scale_in):
    """
    Main function collecting other functions.
    takes a scale (in the form of a list of numbers) and perfroms path computations according to the scale
    the list of coordinates ---> must be numpy a list of arrays <----
    """
    # stores curvatures for every sheet in xls file
    list_of_curvatures = []
    list_of_angles = []

    for coordinates in list_of_coordinates:
        # read in coordinates and convert to path object
        p = Path(coordinates)

        # stores single curvatures for single xls sheet
        curvatures = []

        # stores single angles for single xls sheet
        angles = []

        for unit_step in scale_in:

            # subset path in segments in unit_steps
            p.subset_path(unit_step)

            # list of projection vectors (minus the last vector, not to be used)
            projections = [ProjectionVector([segment[0], segment[-1]]) for segment in p.segmented_coordinates[0:-1]]

            # list of segments to be used for calculation (minus the first segment, not to be used)
            segments = [[i[0],i[-1]] for i in p.segmented_coordinates[1:]]
            
            # Build list of  raw angles (i.e. with +/- sign)
            raw_angles =[find_angle(segments[i],projections[i]) for i in range(len(projections)) if len(projections) == len(segments)]                
        
            # list of curvatures for individual path (segmented according to the scale)
            curvature = np.abs(raw_angles)/unit_step
            
            # median curvature for the selected path (segmented)
            curvatures.append(np.median(curvature))
            # curvatures.append(np.median(curvature)/100) # activate this is the unit step is < 1 (i.e. trichoplax)

            # find angles that are positive (True) and count them
            positive_angles = np.array(raw_angles)>0
            positive_angles = positive_angles.sum()

            # find negative angles
            negative_angles = len(raw_angles) - positive_angles

            # return list of [positive, negative] angles
            angles.append([positive_angles,negative_angles])
        
        list_of_curvatures.append(curvatures)
        list_of_angles.append(angles)

    print('\nList of angles is [POSITIVE, NEGATIVE], example:',list_of_angles[0])
    
    return list_of_curvatures, list_of_angles
        
        #plt.ylim(0, 10)
        #plt.hist(curvature/100, bins=15,color="#4a7ac0")
        #plt.show()
        #print(np.median(curvature/100))

