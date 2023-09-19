% **************************************************************************
% This script has as input an STL file name (path), which contain an STL file
% with coordinates in mm. Additionally, there is a FillValue field that
% indicates the voxel value in the DICOM, where the volume (element) exists.
% A Pixel spacing parameter allows the user to set the spacing in
% the DICOM set. This value is in mm, and it is possible to use
% submilimeter values, i.e., 0.1mm
% Because the discrete nature of the problem, there are some tolerance
% errors that must be taken into account. These errors are partially solved
% by the use of the values planeThreshold and triangleThreshold.
% For more information about this threshold, please open the functions:
% - pointBelongsToPlane.m
% - pointLiesInsideTriangle.m
% As a rule of thumb, planeThreshold can be a value around 0.9, and
% triangleThreshold something about 11.
% The output is a 3D matrix with a pixel spacing as indicated by the user.
%
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function [Volume, origin] = stl2matrix(stl_file, FillValue, PixelSpacing, planeThreshold,triangleThreshold)

% Reading and getting information of the STL file.
test=stlread(stl_file);
number_of_triangles = size(test.ConnectivityList,1);
vertices_list = test.ConnectivityList;
vertices_coordinates = test.Points;

%This swap is made for keeping the same coordinates in the DICOM as in the
%STL file
vertices_coordinates(:,[1 2]) = vertices_coordinates(:,[2 1]);

%%Finding the size of the Volume
% It is possible that the vertices have negative coordinates, so I shift
% the vertices to a positive quadrant
x_min=min(vertices_coordinates(:,1));
y_min=min(vertices_coordinates(:,2));
z_min=min(vertices_coordinates(:,3));

x_max=max(vertices_coordinates(:,1));
y_max=max(vertices_coordinates(:,2));
z_max=max(vertices_coordinates(:,3));

maxi = [y_max, x_max, z_max];

origin = [y_min, x_min, z_min];


vertices_coordinates(:,1) = vertices_coordinates(:,1) - x_min;
vertices_coordinates(:,2) = vertices_coordinates(:,2) - y_min;
vertices_coordinates(:,3) = vertices_coordinates(:,3) - z_min;

% Converting the units from mm(e-3) to user desired
factor = 1/PixelSpacing;

%Here 1 must be added because the shifting to the positive quadrant makes
%the volume to start in (0,0,0), but matlab only works with positive
%indeces. 
%vertices_coordinates(:,1) = vertices_coordinates(:,1)*factor + 1;
%vertices_coordinates(:,2) = vertices_coordinates(:,2)*factor + 1;
%vertices_coordinates(:,3) = vertices_coordinates(:,3)*factor + 1;

% The coordinates are transformed from mm to voxels using 1/pixelSpacing
vertices_coordinates(:,1) = vertices_coordinates(:,1)*factor;
vertices_coordinates(:,2) = vertices_coordinates(:,2)*factor;
vertices_coordinates(:,3) = vertices_coordinates(:,3)*factor;

% the maximum values are calculatated here. At this point, the range of
% voxels are from 0 to max
x_max=ceil(max(vertices_coordinates(:,1)));
y_max=ceil(max(vertices_coordinates(:,2)));
z_max=ceil(max(vertices_coordinates(:,3)));

% Because matlab indexation is from 1 to n, I need to add 1 to every
% component. In order to keep the size in the correct measurement, an
% additional scaling factor is used such as now the range is from 1 to max
vertices_coordinates(:,1) = vertices_coordinates(:,1).*(x_max-1)/x_max +1;
vertices_coordinates(:,2) = vertices_coordinates(:,2).*(y_max-1)/y_max +1;
vertices_coordinates(:,3) = vertices_coordinates(:,3).*(z_max-1)/z_max +1;

% Finding the edges of the volume
x_max=max(vertices_coordinates(:,1));
y_max=max(vertices_coordinates(:,2));
z_max=max(vertices_coordinates(:,3));

% The size of the volume is determined by the maximum value of the vertices
% coordinates. 
x_size = ceil(x_max);
y_size = ceil(y_max);
z_size = ceil(z_max);

%vertices_coordinates = round(vertices_coordinates);
Volume = zeros(x_size,y_size,z_size);

% I have one list with the vertices of the triangles forming the STL file
% and another list which reference how each triangle is composed.
% I read the reference list to get the three points forming the actual
% triangle under analisys. Then I load those points in variables and send
% them to the fillVolumeWithTriangleSurface() funtion. This returns the
% volume with the additional filling added for this new triangle.
% At the end of the for loop, the volume is filled with every triangle
% described in the STL file.
for actual_triangle_number = 1 : number_of_triangles
    
    Pointer_point1 = vertices_list(actual_triangle_number,1);
    Pointer_point2 = vertices_list(actual_triangle_number,2);
    Pointer_point3 = vertices_list(actual_triangle_number,3);
    Point1 = vertices_coordinates(Pointer_point1,:);
    Point2 = vertices_coordinates(Pointer_point2,:);
    Point3 = vertices_coordinates(Pointer_point3,:);
    Volume = fillVolumeWithTriangleSurface(Volume,Point1,Point2,Point3, FillValue,planeThreshold,triangleThreshold);
    
end

