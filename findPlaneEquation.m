%This function receives three points as input and returns the plane
% normalized coefficients a,b,c,d.
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function [a,b,c,d] = findPlaneEquation(Point1, Point2, Point3)

P1P2 = Point2 - Point1;
P1P3 = Point3 - Point1;

normal = cross(P1P2,P1P3);
normal = normal/norm(normal);

a = normal(1);
b = normal(2);
c = normal(3);

d = [a b c]*Point1';
