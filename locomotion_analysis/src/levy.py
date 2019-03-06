#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 10:45:00 2017

@author: lex

Levy distribution
"""


import numpy as np
from Path import Path
from load_excel_data import read_xls_data


def compute_distances(list_of_coordinates):
    
    # stores curvatures for every sheet in xls file
    list_of_densities = []

    for coordinates in list_of_coordinates:
    
        # read in coordinates and convert to path object
        p = Path(coordinates)

        list_of_densities.append(np.histogram(p.distances,bins=20,range=(0,0.1))[0])
    
    return list_of_densities


fname = 'Raw data-algea_h2o-Trial    11.xlsx'

xls_data = read_xls_data('../data/'+fname)

#p = Path(xls_data[0])

data_out = compute_distances(xls_data)


c=1
m = 0.05
x = np.linspace(0.0001,0.1)

import random
import math


def levy_distro(mu):
	''' From the Harris Nature paper. '''
	# uniform distribution, in range [-0.5pi, 0.5pi]
	x = random.uniform(-0.5 * math.pi, 0.5 * math.pi)

	# y has a unit exponential distribution.
	y = -math.log(random.uniform(0.0, 1.0))

	a = math.sin( (mu - 1.0) * x ) / (math.pow(math.cos(x), (1.0 / (mu - 1.0))))
	b = math.pow( (math.cos((2.0 - mu) * x) / y), ((2.0 - mu) / (mu - 1.0)) )

	z = a * b
	return z


#np.savetxt('../output/levy_'+fname+'.txt',np.array(data_out).T,delimiter='\t',newline='\n')

