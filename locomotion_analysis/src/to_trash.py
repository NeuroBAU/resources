#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 29 13:03:02 2017

@author: lex
"""

import numpy as np
from Path import Path
from angle_analysis import ProjectionVector,findAngle
from load_excel_data import read_xls_data


def curvature_analysis(coordinatesIN,scaleIN):

    # read in coordinates and convert to path object
    p = Path(coordinatesIN)
    
    curvatures = []
    
    for unit_step in scaleIN:
    
        # subset path in segments in unit_steps
        p.subsetPath(unit_step)
    
        # list of projection vectors (minus the last vector, not to be used)
        projections = [ProjectionVector([segment[0],segment[-1]]) for segment in p.segmented_coordinates[0:-1]]
    
        # list of segments to be used for calculation (minus the first segment, not to be used)
        segments = [[i[0],i[-1]] for i in p.segmented_coordinates[1:]]
    
        # Build list of angles (same as above but faster)
        raw_angles =[findAngle(segments[i],projections[i]) for i in range(len(projections)) if len(projections) == len(segments)]                
    
        # list of curvatures
        curvature = np.abs(raw_angles)/unit_step
    
        curvatures.append(np.median(curvature)/100)

    return(curvatures)


#list_of_coordinates = read_xls_data('../data/Raw data-algea_h2o-Trial     9 water_only.xlsx')
list_of_coordinates = read_xls_data('../data/Raw data-algea_h2o-Trial    10  some_food.xlsx')


scale = np.arange(0.015,1.015,0.005)

db = []
for coordinates in list_of_coordinates:
    try:
        d = curvature_analysis(coordinates,scale)
        db.append(d)
    except:
        pass
        

d = np.asarray(db)
v = np.nanmean(d,axis=0)

