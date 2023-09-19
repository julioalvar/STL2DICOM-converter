% **************************************************************************
% This is a debugging script for the function stl2matrix.m
% for more information refere to such file.
%
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

clc;
clear;

% This is the value that the walls of the volume will have in the DICOM
fillValue = 1;

% This value is the pixel spacing in mm units. It is possible to use
% submilimeter values, i.e., 0.1mm.
pixel_spacing = 1;

planeThreshold = 0.7;
triangleThreshold = 30;

test=stlread('Xspot_likeDevice.stl');
number_of_triangles = size(test.ConnectivityList,1);
vertices_list = test.ConnectivityList;
vertices_coordinates = test.Points;

%%Finding the size of the Volume

% Shifiting the vertices to a positive quadrant
x_min=min(vertices_coordinates(:,1));
y_min=min(vertices_coordinates(:,2));
z_min=min(vertices_coordinates(:,3));

vertices_coordinates(:,1) = vertices_coordinates(:,1) - x_min;
vertices_coordinates(:,2) = vertices_coordinates(:,2) - y_min;
vertices_coordinates(:,3) = vertices_coordinates(:,3) - z_min;

% Converting the units from mm(e-3) to user desired
factor = 1/pixel_spacing;

%Here 1 must be added because the shifting to the positive quadrant makes
%the volume to start in (0,0,0), but matlab only works with positive
%indeces
vertices_coordinates(:,1) = vertices_coordinates(:,1)*factor + 1;
vertices_coordinates(:,2) = vertices_coordinates(:,2)*factor + 1;
vertices_coordinates(:,3) = vertices_coordinates(:,3)*factor + 1;

% Finding the edges of the volume
x_max=max(vertices_coordinates(:,1));
y_max=max(vertices_coordinates(:,2));
z_max=max(vertices_coordinates(:,3));

x_size = ceil(x_max);
y_size = ceil(y_max);
z_size = ceil(z_max);

vertices_coordinates = round(vertices_coordinates);
Volume = zeros(x_size,y_size,z_size);


for actual_triangle_number = 1 : number_of_triangles
    
    Pointer_point1 = vertices_list(actual_triangle_number,1);
    Pointer_point2 = vertices_list(actual_triangle_number,2);
    Pointer_point3 = vertices_list(actual_triangle_number,3);
    Point1 = vertices_coordinates(Pointer_point1,:);
    Point2 = vertices_coordinates(Pointer_point2,:);
    Point3 = vertices_coordinates(Pointer_point3,:);
    Volume = fillVolumeWithTriangleSurface(Volume,Point1,Point2,Point3, FillValue,planeThreshold,triangleThreshold);
    
end

%trimesh(test);


