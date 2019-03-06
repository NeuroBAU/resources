#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 29 15:02:47 2017

@author: lex
"""

import numpy as np
import pandas as pd

xls = pd.ExcelFile('../data/Raw data-algea_h2o-Trial    10  some_food.xlsx')
    
db = []

for n in xls.sheet_names:
    
    print('reading sheet:', n)

    # read the whole excel file
    tmp = xls.parse(sheet_name = n, header = 32)
    
    movement_status = tmp['Movement(Moving / center-point)']
    x = tmp['X center']
    y = tmp['Y center']
    
    db.append(np.array([movement_status,x,y]))

