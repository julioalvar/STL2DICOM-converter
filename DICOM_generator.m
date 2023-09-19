% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

clc;
clear;

%% User input fields %%

%Coin information in mm
diameter_mm = 25.75;
thickness_mm = 2.25;

%DICOM Information
width = 256; % Y-axis, DICOM cols
height = 256; % X-axis, DICOM rows
numLayers = 256;

pixelSpacingXY = 0.125;
sliceThickness = 0.125;

x_center = 128;
y_center = 128;
z_center = 128;

solid_value = 32700;

%DICOM folder path
DICOM_PATH = 'C:\Users\alvarez\Desktop\coin3_edit_DICOM\';
DICOM_OUT_PATH = 'C:\Users\alvarez\Desktop\perfect_coin_DICOM\';

%% Staring of the code. No more user data from this point on.
DICOM = zeros(height,width,numLayers);

%conversion between mm and pixel
diameterXY_px = diameter_mm/pixelSpacingXY;
diameterZ_px = diameter_mm/sliceThickness;
thickness_px = thickness_mm/pixelSpacingXY;

%in the matrix coin, it will be created a circle. This will be taken row by
%row in the Y-axis. Each row will be duplicated towards the X-axis. The
%growth process is done in the Z-axis direction, creating the coin with the
%face perpendicular to X-axis and coplanar to YZ plane.
coin = circle_creation(diameterXY_px)*solid_value;

% The number of layers depends on the diameter of the coin
for i=1:diameterZ_px
    
    % Duplicating each row of the circle in X-axis (making it thicker)
    current_view =[];
    for j=1:thickness_px
        current_view = [current_view; coin(i,:)];     
    end
    
    % Calculating the range within the DICOM matrix, where the coin will be
    % inserted. The coin center is supposed to be center in the DICOM
    min_x_position = x_center - floor(thickness_px/2);
    max_x_position = x_center + round(thickness_px/2)-1;
    
    min_y_position = y_center - floor(diameterXY_px/2);
    max_y_position = y_center + round(diameterXY_px/2)-1;
    
    z_position = z_center+i-round(diameterXY_px/2);
    
    %Inserting the current view (plane) of the coin in a layer of the DICOM
    DICOM(min_x_position:max_x_position, min_y_position:max_y_position,z_position) = current_view;    

end

 listing = dir (DICOM_PATH);
 numImages = size(listing);
 numImages = numImages(1);
 
 info = dicominfo([DICOM_PATH listing(3).name]); 
 initial_position = info.SliceLocation; 


%starts on 3 because 1 and 2 are the instances "." and ".." of the directory
 for i = 3 :  numImages
    CurrentImageFullName = [DICOM_PATH listing(i).name] ;
    
    % Editing the DICOM Tags for fullind the requiring resolution
    info = dicominfo(CurrentImageFullName);    
    info.PixelSpacing(1) = pixelSpacingXY;
    info.PixelSpacing(2) = pixelSpacingXY;
    info.SliceThickness = sliceThickness;
    info.ImagePositionPatient(3) = initial_position - i*sliceThickness;
    info.SliceLocation = initial_position - i*sliceThickness;
    
    Image_to_copy = DICOM(:,:,i-2);
    file_name = char("CT_Coin_"+ (997+ i));
    full_path = strcat(DICOM_OUT_PATH,file_name);
    dicomwrite(Image_to_copy, full_path, info);  

    
end



