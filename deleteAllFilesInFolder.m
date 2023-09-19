% call the function with the folder path you want to delete
% ***************************************************************************
% Created by:   Julio Alvarez
% Date: 	      AUG-2019 
% Contact:      julioalvar@gmail.com
% ***************************************************************************

function deleteAllFilesInFolder(dicom_output_path)

filesInFolder = dir(dicom_output_path);

for k = 3 : length(filesInFolder)
  baseFileName = filesInFolder(k).name;
  fullFileName = fullfile(dicom_output_path, baseFileName);  
  delete(fullFileName);
end
