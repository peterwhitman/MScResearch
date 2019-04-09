T = readtable('F:\\RGBI_18cm_Orthomosaic\\CameraPosition2008.txt');
vars = {'x_Label', 'X_est', 'Y_est', 'Yaw_est'}; %Will be CameraID, X, Y, Kappa
T2 = T(:,vars);
T2.Properties.VariableNames = {'CameraID', 'X', 'Y', 'Yaw'};

px_side = 19501; %length of one side of each cropped photo in pixels (standard for all years)
mm_side = 206.55; %length of one side of each cropped photo in mm (standard for all years)
AGL_ft = 6000; %Altitude abouve ground level in feet (given on the margins of each photo)
AGL_m = AGL_ft * 0.3048; %Altitude above ground level converted to meters 
focal_length = 152.82; %Focal length of each photo in mm (given on the margins of each photo)
scale = (focal_length/1000)/AGL_m; %Photo scale
iscale = AGL_m/(focal_length/1000); %Inverse of photo scale

photo_area = mm_side^2; %area of photo in mm^2
ground_area = ((mm_side * iscale)^2)/1000000; %area that the photo covers in km^2
ground_areaKM = ground_area/1000000; %area that the photo covers in km^2

px_dim = ((mm_side * iscale)/1000)/ px_side; %Real world length of the side of a pixel in meters
shift = (px_dim * ((19501-1)/2));

Directory = ('F:\\AP2008\\'); %Should be same location as cropped images

%Reference ESRI world file notation
for i = 1:length(table2array(T2(:,'CameraID')))

k = 0;
t = table2array(T2(i,'Yaw'));
worldfile = double.empty(0,3);

worldfile(1,1) = cos((pi/ 180) * t) * px_dim; %px_dim * cos(t); %A
worldfile(2,1) = sin((pi/ 180) * t) * -1 * px_dim; %px_dim * sin(t); %D
worldfile(1,2) = sin((pi/ 180) * t) * -1 * px_dim; %px_dim * (k * cos(t) - sin(t)); %B
worldfile(2,2) = cos((pi/ 180) * t) * -1 * px_dim; %-1 * px_dim * (k * sin(t) + cos(t)); %E
worldfile(1,3) = table2array(T2(i,'X')); % + shift; %upper x cooridnate (m), C in ESRI notation
worldfile(2,3) = table2array(T2(i,'Y')); %+ shift; %upper y coordinate (m) , F in ESRI notation

label = char(table2array(T2(i,'CameraID')));
extension = label(length(label)-3:length(label));

if extension == ".tif"
cameraName = extractBefore(table2array(T2(i,'CameraID')), '.tif');
Save = char(strcat(Directory, cameraName, '.tfw'));
refmat = worldFileMatrixToRefmat(worldfile);
worldfilewrite(refmat, Save);

else 
cameraName = extractBefore(table2array(T2(i,'CameraID')), '.jpg');
Save = char(strcat(Directory, cameraName, '.jpgw'));
refmat = worldFileMatrixToRefmat(worldfile);
worldfilewrite(refmat, Save);

end
end
