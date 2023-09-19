% This function returns the Area of the triangle delimited by three points
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	      AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function area = areaTriangle(Point1, Point2, Point3)

P1P2 = Point2 - Point1;
P1P3 = Point3 - Point1;

normal = cross(P1P2,P1P3);

area = norm(normal)/2;

