#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 13:06:02 2017

@author: lex
"""

import numpy as np
from scipy.spatial import ConvexHull


class Path(object):
    """Transform a list of coordinates into a path object"""
    def __init__(self, coordinatesIN):
        super(Path, self).__init__()
        self.coordinates = coordinatesIN
        self.distances = self.get_euclidean_distance_array()
        self.explored_surface = self.get_explored_surface()

        
    def get_euclidean_distance_array(self):
        """ Compute the euclidean distance on the array of coordinates"""
        tmp = np.array([np.linalg.norm(self.coordinates[i, :]-self.coordinates[i+1, :]) for i in range(len(self.coordinates)-1)])
        return(np.insert(tmp, 0, 0))    # return array W/ zero value on first row        
#        return(tmp)

    def subset_path(self, path_length_step=0):
        """
        Split path into segments based on the cumulative distance indicated by path_length_step
        returns the segmented path as distance and coordinates
        """
        segment = []
        segment_coordinates = []
        indexes = []
        cumulative_sum = 0
        self.segmented_path = []
        self.segmented_coordinates = []
        
        for i in range(len(self.coordinates)):
            cumulative_sum += self.distances[i]
            segment.append(self.distances[i])
            segment_coordinates.append(np.asarray([self.coordinates[i, 0], self.coordinates[i, 1]]))
            
            if (cumulative_sum >= path_length_step) or (i+1 == len(self.distances)):
                self.segmented_path.append(np.asarray(segment))
                self.segmented_coordinates.append(np.asarray(segment_coordinates))
                start = i-len(segment)+1
                indexes.append((start, i))
                segment = []
                segment_coordinates = [np.array([self.coordinates[i, 0], self.coordinates[i, 1]])]
                cumulative_sum = 0

        print('step length (',path_length_step,') : found',len(self.segmented_coordinates),'segments')
    

    def get_explored_surface(self):
        """Compute convex hull on the array of coordinates"""
        tmp_hull = ConvexHull(self.coordinates)
        return tmp_hull.volume

