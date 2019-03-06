#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 13 14:18:01 2017

@author: Leonardo Restivo
"""

import numpy as np
from Path import Path
from load_excel_data import read_xls_data


def compute_convexHull(list_of_coordinates):
    
    # stores curvatures for every sheet in xls file
    list_of_convexHull = []

    for coordinates in list_of_coordinates:
    
        # read in coordinates and convert to path object
        p = Path(coordinates)

        list_of_convexHull.append(p.getExploredSurfaceArea())
    
    return list_of_convexHull


fname = 'Raw data-algea_h2o-Trial    11.xlsx'

xls_data = read_xls_data('../data/'+fname) 

data_out = compute_convexHull(xls_data)

np.savetxt('../output/convex_hull_'+fname+'.txt',data_out,delimiter='\t',newline='\n')