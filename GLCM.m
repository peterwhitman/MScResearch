FolderDir = fullfile('C:\\Users\\Peter\\Documents\\MScResearch\\CroppedPhotos');
FolderOI = dir(FolderDir);

FolderDir2 = fullfile('C:\\Users\\Peter\\Documents\\MScResearch\\CroppedPhotos', FolderOI(17).name);
FolderPattern = fullfile(FolderDir2, '*.jpg');
ImageFiles = dir(FolderPattern);
a = struct('Contrast', {}, 'Correlation', {}, 'Energy', {},'Homogeneity', {}, 'Entropy', {},'Name', {}, 'Red', {}, 'Green', {}, 'Blue', {}, 'Std', {}, 'Day', {});

for k = 3:length(ImageFiles)
baseFileName = ImageFiles(k).name;
fullFileName = fullfile(ImageFiles(k).folder, baseFileName);
I = imread(fullFileName);
new = rgb2gray(I);
glcm = graycomatrix(new);
stats = graycoprops(glcm);
stats.Name = baseFileName(1:end-4);
position = k - 2;
E = entropy(new);
[rows, cols, ~] = size(I);
band_means = sum(sum(I,2),1)/(rows*cols);

a(position).Name = stats.Name;
a(position).Contrast = stats.Contrast;
a(position).Correlation = stats.Correlation;
a(position).Energy = stats.Energy;
a(position).Homogeneity = stats.Homogeneity;
a(position).Entropy = E;
a(position).Red = band_means(1);
a(position).Blue = band_means(2);
a(position).Green = band_means(3);
a(position).Std = std2(new);
a(position).Day = baseFileName(1:2);

TablePath = fullfile('C:\\Users\\Peter\\Documents\\MScResearch\\CroppedPhotos\\GLCM_Stats\\', FolderOI(17).name);
TableExt = '.csv';
TableName = strcat(TablePath, TableExt);
writetable(struct2table(a), TableName);

end

