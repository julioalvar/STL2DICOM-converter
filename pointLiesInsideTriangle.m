% A Point is inside a triangle, if the area of the triangles (3 all in all) 
% formed by the testing point combined with the other points, It is the
% same as the original triangle area.
% A good value for the difference Threshold is around 11
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	    AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function yesOrNo = pointLiesInsideTriangle(Point1, Point2, Point3, PTest, differenceThreshold)

area_main_triangle = areaTriangle(Point1, Point2, Point3);

area1 = areaTriangle(PTest, Point2, Point3);
area2 = areaTriangle(Point1, PTest, Point3);
area3 = areaTriangle(Point1, Point2, PTest);

total_area = area1 + area2 + area3;

% This difference will be zero only when the point lays inside the
% triangle. Otherwise, the difference is greater than 0.
% 
difference = total_area - area_main_triangle;

yesOrNo = logical( difference < differenceThreshold );
