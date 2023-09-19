% **************************************************************************
% This script creates a DICOM file using the definitions found in a
% STL-file. Additionally, an image of a previous DICOM is required, so this
% file must be given as well.
% The output images will have a name and a sequence number, which starts in
% zero. The prefix can be stated in dicom_prefix, and the path where the
% images will be saved can be inserted in dicom_output_path.
% Some parameters of the DICOM as pixel_spacing and the filling value of
% the STL structure can also by modified in pixel_spacing and FillValue.
% Because the discrete nature of the problem, there are some tolerance
% errors that must be taken into account. These errors are partially solved
% by the use of the values planeThreshold and triangleThreshold.
%
% For more information about this threshold, please open the functions:
% - pointBelongsToPlane.m
% - pointLiesInsideTriangle.m
%
% As a rule of thumb, planeThreshold can be a value around 0.9, and
% triangleThreshold something about 11.
%
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

clc;
clear;

%% Input variables

STL_file = 'Disk1.stl';
dicom_example_name = 'DICOM_example';
dicom_prefix = 'disk';
dicom_output_path = ".\output\";


pixel_spacing = 0.2; % value in mm
FillValue = 8096;
planeThreshold = 0.7;
triangleThreshold = 17;

%% Execution of the convertion. Nothing to edit here.

[volume, origin]=stl2matrix(STL_file,FillValue,pixel_spacing, planeThreshold,triangleThreshold);
volume2DICOM(volume,origin, pixel_spacing, dicom_example_name, dicom_prefix, dicom_output_path);
