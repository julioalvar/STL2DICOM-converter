% **************************************************************************
% This function receives a 3D volume (3D matrix) as input.
% Additionally, the explanation about the number of mm between pixel 
% must be sent in pixel_spacing.
% It is necessary for filling the DICOM header, an actual DICOM image. Its
% path must be included in the paramater dicom_example_name.
% The output images will have a name and a sequence number, which starts in
% zero. The prefix can be stated in dicom_prefix, and the path where the
% images will be saved can be inserted in dicom_output_path.
%
% ***************************************************************************
% Created by:   Julio Alvarez
% Date:         AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function volume2DICOM(volume, origin, pixel_spacing, dicom_example_name, dicom_prefix, dicom_output_path)

deleteAllFilesInFolder(dicom_output_path);
% the first slice will add pixel spacing then the first slice will be in 0
%initial_position_Z_In_DICOM = -pixel_spacing;% origin(3);
initial_position_Z_In_DICOM = -pixel_spacing/2;% origin(3);
numImages = size(volume,3);

%  listing = dir (dicom_example_path);
%  numImages = size(listing);
%  numImages = numImages(1);
 
sliceThickness = pixel_spacing;
info = dicominfo(dicom_example_name); 
info.PixelSpacing(1) = pixel_spacing;
info.PixelSpacing(2) = pixel_spacing;
info.SliceThickness = 0.01;
%info.ImagePositionPatient(1) = 0;%origin(1);
%info.ImagePositionPatient(2) = 0;%origin(2);
info.ImagePositionPatient(1) = pixel_spacing/2;%origin(1);
info.ImagePositionPatient(2) = pixel_spacing/2;%origin(2);
info.Rows = size(volume,1);
info.Width = size(volume,1);
info.Columns = size(volume,2);
info.Height = size(volume,2);


info = rmfield(info,'RescaleSlope');
info = rmfield(info,'RescaleIntercept');
info = rmfield(info,'RescaleType');
% info = rmfield(info,'Private_0029_10xx_Creator');
% info = rmfield(info,'Private_0029_11xx_Creator');
% info = rmfield(info,'Private_0029_1008');
% info = rmfield(info,'Private_0029_1009');
% info = rmfield(info,'Private_0029_1010');
% info = rmfield(info,'Private_0029_1140');
% info = rmfield(info,'RequestedProcedureDescription');
% info = rmfield(info,'PerformedProcedureStepID');
% info = rmfield(info,'IconImageSequence');
% info = rmfield(info,'Private_0095_10xx_Creator');
% info = rmfield(info,'Private_0095_100c');
% info = rmfield(info,'ExposureModulationType');
% info = rmfield(info,'EstimatedDoseSaving');
% info = rmfield(info,'CTDIvol');
% info = rmfield(info,'Unknown_0018_9346');
% info = rmfield(info,'Unknown_0018_9352');
% info = rmfield(info,'Private_0019_10xx_Creator');
% info = rmfield(info,'Private_0019_1090');
% info = rmfield(info,'Private_0019_1092');
% info = rmfield(info,'Private_0019_1093');
% info = rmfield(info,'Private_0019_1096');
% info = rmfield(info,'Private_0019_10b0');
% info = rmfield(info,'StudyInstanceUID');
% info = rmfield(info,'StudyID');
% info = rmfield(info,'SeriesNumber');
% info = rmfield(info,'AcquisitionNumber');
% info = rmfield(info,'InstanceNumber'); 
 

 for i = 1 :  numImages
 %for i = 1 :  1
    
    % Editing the DICOM Tags for filling the requiring resolution   
    
    info.ImagePositionPatient(3) = initial_position_Z_In_DICOM + i*sliceThickness;
    info.SliceLocation = initial_position_Z_In_DICOM + i*sliceThickness;
    
  
    Image_to_copy = volume(:,:,i);
    file_name = char(dicom_prefix + "_" + (999 + i));
    full_path = strcat(dicom_output_path,file_name);
    dicomwrite(Image_to_copy, full_path, info);  

    
end
