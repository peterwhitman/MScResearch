imageDir = 'F:\\GrainSamples2008';
filePattern = fullfile(imageDir);
ImageFiles = dir(filePattern);

f = struct2table(ImageFiles(4:13,1));
f = table2array(f(:,1));
stats = double.empty(0,4);

for i = 1:length(f)
baseFileName = cell2mat(f(2,1));
fullFileName = fullfile(imageDir, baseFileName);
I2 = imread(fullFileName);
I2 = I2(:,:,1);
stats(((i*100) - 99):(i*100),1) = bootstrp(100,@skewness,I(:));
stats(((i*100) - 99):(i*100), 2) = bootstrp(100,@kurtosis,I(:));
stats(((i*100) - 99):(i*100), 3) = bootstrp(100,@mean,I(:));
stats(((i*100) - 99):(i*100), 4) = bootstrp(100,@std,double(I(:)));
end

%data = horzcat(f, stats);
scatter(stats(:,1), stats(:,2))

BigD = double.empty(0,1);
BigD2 = double.empty(0,1);
PLength = double.empty(0,1);
PLength(1,1) = 0;

for i = 1:length(f)
baseFileName = cell2mat(f(i,1));
fullFileName = fullfile(imageDir, baseFileName);
I = imread(fullFileName);
I = I(:,:,1);
ImgVector = I(:);
PLength(i,1) = length(ImgVector);
if i == 1
BigD2(1:length(ImgVector),1) = ImgVector;
else
BigD2((PLength(i-1,1)+1:length(ImgVector)+PLength(i-1,1)),1) = ImgVector;
end
end

metrics = double.empty(0,4);
func = ["kurtosis", "skewness", "mean", "std"];
for i = 1:4
metrics(1:500,i) = bootstrp(500, func(1,i), double(BigD2));
end

scatter(metrics(:,1), metrics(:,2))

func = {@kurtosis, @skewness, @mean, @std, @rms};
lengthB = double.empty(0,4);
blockMetrics = double.empty(0,4);
for i = 1:length(f)
baseFileName = cell2mat(f(i,1));
fullFileName = fullfile(imageDir, baseFileName);
I = imread(fullFileName);
I = double(I(:,:,1));

for k = 1:length(func)
if k == 5
    fun = @(block_struct) mean(func{k}(block_struct.data));
    B = blockproc(I, [50, 50], fun);
else
    fun = @(block_struct) func{k}(block_struct.data);
    B = blockproc(I, [50, 50], fun);
end
lengthB(i,k) = length(B(:));
if i == 1
    blockMetrics(1:lengthB(i,k), k) = B(:);
else
    blockMetrics(lengthB(i-1, k)+1:lengthB(i,k)+lengthB(i-1, k),k) = B(:); 
end
end
end

blockMetrics(:,5) = blockMetrics(:,5)./blockMetrics(:,3);
densityplot(blockMetrics(:,1), blockMetrics(:,5), [100, 100])

mean(blockMetrics(:,5))
mean(blockMetrics(:,1))
mean(blockMetrics(:,2))
