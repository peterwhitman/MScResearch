imageDir = 'C:\\Users\\Peter\\Documents\\MScResearch\\RenamedPhotos\\Day 6 Photos\\team b';
TestDir = 'C:\\Users\\Peter\\Documents\\MScResearch\\CroppedPhotos\\Day 6b Photos';
filePattern = fullfile(imageDir, '*.JPG');
ImageFiles = dir(filePattern);

for k = 1:length(ImageFiles)
baseFileName = ImageFiles(k).name;
fullFileName = fullfile(imageDir, baseFileName);
TestSave = fullfile(TestDir, baseFileName);
I = imread(fullFileName);
BW = rgb2gray(I);
contrast = adapthisteq(BW);
se = strel('square', 10);
erodedI = imerode(contrast, se);
level = graythresh(erodedI);
BW2 = imbinarize(erodedI, level);
bw = bwareafilt(BW2, 1);
invert = imcomplement(bw);
J_area = bwareafilt(invert, 1);
bw_convex = regionprops(J_area, 'ConvexHull');
convex = cell2mat(struct2cell(bw_convex));
[~, ix,] = min(sum(convex, 2));
xmin_ymin = convex(ix, 1:2);
xmin = xmin_ymin(:,1);
ymin = xmin_ymin(:,2);
[CM, ~] = max(convex(:,1));
[RM, ~] = max(convex(:,2));
width = CM - xmin;
height = RM - ymin;
rect = [xmin, ymin, width, height];
cropedI = imcrop(I, rect);
imwrite(cropedI, TestSave);
end



