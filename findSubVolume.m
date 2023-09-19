% This function find the volume delimiited by three points.
% It is done finding the minimum and maximum values of each axis.
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function [xmin,xmax,ymin,ymax,zmin,zmax] = findSubVolume(Point1, Point2, Point3)

xmin = min([Point1(1),Point2(1),Point3(1)]);
ymin = min([Point1(2),Point2(2),Point3(2)]);
zmin = min([Point1(3),Point2(3),Point3(3)]);

xmin = floor(xmin);
ymin = floor(ymin);
zmin = floor(zmin);


xmax = max([Point1(1),Point2(1),Point3(1)]);
ymax = max([Point1(2),Point2(2),Point3(2)]);
zmax = max([Point1(3),Point2(3),Point3(3)]);

xmax = ceil(xmax);
ymax = ceil(ymax);
zmax = ceil(zmax);
