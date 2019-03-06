#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 16:24:06 2017

@author: lex
"""
import numpy as np

def loadData(pathToFile):
    """ 
    Reads from txt files
    !!! fix the missing values using cascade heuristic
    """
    tmp=[line.split() for line in open(pathToFile,'r')]
    for i in range(len(tmp)):
        try:
            tmp[i][0] = float(tmp[i][0])
        except:
            print('datapoint #',i, 'is missing:',tmp[i][0],'| replaced with',tmp[i-1][0])
            tmp[i][0] = float(tmp[i-1][0])
        try:
            tmp[i][1] = float(tmp[i][1])
        except:
            print('datapoint #',i, 'is missing:',tmp[i][1],'| replaced with',tmp[i-1][1])
            tmp[i][1] = float(tmp[i-1][1])
    print('Loaded',len(tmp),'data points')
    tmp_path = np.array(tmp)
    
    return(np.array(tmp_path))
    
if __name__ == '__main__':
	
	coord = loadData('../data/test.txt')
