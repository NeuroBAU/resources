import math
import numpy as np

class ProjectionVector(object):
	"""
	Computes the projection vector from an input segment
	Input must be in the form: ((x0,y0),(x1,y1))
	"""
	def __init__(self, lineA):
		self.lineA = lineA
		self.vector = self.find_projection()
		self.slope = self.find_slope()
		self.intercept = self.find_intercept()

	def find_projection(self):
		return (self.lineA[1], (2*self.lineA[1][0]-self.lineA[0][0], 2*self.lineA[1][1]-self.lineA[0][1]))

	def find_slope(self):
		a =  self.vector[1][1]- self.vector[0][1] 
		if  self.vector[1][0] !=  self.vector[0][0]: # protect from zero division error
			return (a / ( self.vector[1][0]- self.vector[0][0]))
		else:
			return a

	def find_intercept(self):
		return  self.vector[1][1] - self.slope* self.vector[1][0]


def find_angle(lineB,VectorP):
	""" 
	Line A (not present in function) is the starting segment
	Line B is the following segment
	VectorP is an object of class ProjectionVector and it is derived from Line A
	"""
	vB = [(lineB[0][0]-lineB[1][0]), (lineB[0][1]-lineB[1][1])]
	vP = [(VectorP.vector[0][0]-VectorP.vector[1][0]), (VectorP.vector[0][1]-VectorP.vector[1][1])]
	dot_prod = np.dot(vB,vP)
	magA = np.sqrt(np.dot(vB, vB))
	magB = np.sqrt(np.dot(vP, vP))
	cos_ = dot_prod/(magA*magB)
	ang = np.arccos(cos_)
	ang_deg = math.degrees(ang)%360
	if lineB[1][1]<VectorP.slope*lineB[1][0] + VectorP.intercept:
	    ang_deg = -ang_deg
#	print(ang_deg)
	return -1*ang_deg	

if __name__ == '__main__':
	#input lines
	lineA = ((1, 1),(1, 2))
	# lineA = np.array([[-2, 2],[-4, 1.5]])
	lineB = ((1, 2),(2, 1))

	#projected vector
	vectorP = ProjectionVector(lineA)

	a = find_angle(lineB,vectorP)

# for i in range(0,len(a), 12):
# 	vP = ProjectionVector([a[i], a[i+1]])
# 	find_angle([a[i+1], a[i+2]],vP)
