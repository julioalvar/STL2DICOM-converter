% This function fills the DICOM volume corresponding to the triangle
% delimited for the points Point1, Point2, Point3. The filling is used
% defined by fill value.
% the function determines the plane equation.
% then find a subvolumen delimited by the three points and iterates only
% over this subvolume.
% Each point of this subvolume is checked if it fits in the plane delimited
% by the three given points.
% If the point fits, then it is double checked if it lays inside the
% triangle delimited by the given points.
% Because the discrete nature of the problem, there are some tolerance
% errors that must be taken into account. These errors are partially solved
% by the use of the values planeThreshold and triangleThreshold.
% For more information about this threshold, please open the functions:
% - pointBelongsToPlane.m
% - pointLiesInsideTriangle.m
%
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function volume =  fillVolumeWithTriangleSurface(volume, Point1, Point2, Point3, fillValue,planeThreshold,triangleThreshold)

[a,b,c,d] = findPlaneEquation(Point1, Point2, Point3);

[xmin, xmax, ymin, ymax, zmin, zmax] = findSubVolume(Point1, Point2, Point3);

for x = xmin : xmax   
    for y = ymin : ymax        
       for z = zmin : zmax
           currentPoint = [x,y,z];
           if (pointBelongsToPlane(a,b,c,d,currentPoint,planeThreshold))
               if (pointLiesInsideTriangle(Point1, Point2, Point3, currentPoint,triangleThreshold))
                   volume(x,y,z) = fillValue;
               end
           end
       end        
    end    
end
