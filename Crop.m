imageDir = 'F:\\AirPhotos2008';
TestDir = 'D:\\PeterWhitman_Data\\Projects\\ScannedAirPhotos\\AP1984';
filePattern = fullfile(imageDir);
ImageFiles = dir(filePattern);

for i = 3:length(ImageFiles)
baseFileName = ImageFiles(i).name;
fullFileName = fullfile(imageDir, baseFileName);
I = imread('G:\\SRS7843_39.jpg');

BW1 = imbinarize(I, 0.3);
BW2 = imcomplement(BW1);
BW3 = bwareafilt(BW2, 1);
BW4 = imcomplement(BW3);
BW5 = bwareafilt(BW4, 1);
BW5_stat = regionprops(BW5,'Centroid');

width = 19500;
height = 19500;
upper_x = abs((BW5_stat.Centroid(:,1) - (width/2)));
upper_y = abs((BW5_stat.Centroid(:,2) - (height/2)));

cropedI = imcrop(I, [upper_x, upper_y, 19500, 19500]);
TestSave = fullfile(TestDir, baseFileName);
imwrite(cropedI, TestSave);
end
