# -*- coding: utf-8 -*-

import numpy as np
from load_excel_data import read_xls_data
from compute_curvature import compute_curvature

#define file name
fname = 'Raw data-algea_h2o-Trial     8.xlsx'

# read raw data
xls_data = read_xls_data('../data/'+fname) 

# define scale to be used
scale = np.arange(0.025, 1.025, 0.025)

# find curvature for the indicated scale
angles, tmp_curvature = compute_curvature(xls_data, scale)

data_out = np.array(tmp_curvature).T

# save data to text file
np.savetxt('../output/test_'+fname+'.txt',data_out,delimiter='\t',newline='\n')