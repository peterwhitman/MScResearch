%Tdir = dir('F:/LineSpread/Stack08/');
%Tdir = dir('F:/LineSpread/Stack99/');
Tdir = dir('F:/LineSpread/Stack84/');
DistVector = double.empty(0,1);
uniqueLength = double.empty(0,1);

for k = 3:length(Tdir)
k2 = k - 2;
T = readtable(strcat(Tdir(k).folder, '\', Tdir(k).name));
ID = unique(T(:,6));
num = height(ID);
uniqueLength(k2,:) = num;

for i = 1:num
pos = table2array(ID(i,:));
distance = T(T.LINE_ID==pos, 2);
intensity = T(T.LINE_ID==pos, 3);
distance = table2array(distance(:,1));
intensity = table2array(intensity(:,1));
microns = distance.* 25400;
microns(end,:) = [];
spread = diff(sort(intensity));

%x1 = find(spread >= 0.1*peakHeight, 1, 'first');
%x2 = find(spread >= 0.1*peakHeight, 1, 'last');

peakHeight = max(spread);
[minValue,closestIndex] = min(abs(spread(:)-mean(spread(:))));
closestValue = spread(closestIndex);

peak = find(spread == peakHeight);
x2 = find(spread == closestValue, 1, 'first');

dist1 = microns(peak,:);
dist2 = microns(x2,:);
theWidth = abs(dist2-dist1);
Diameter90 = theWidth *0.90; %measure aproximately 90% of the observable ISF diameter G.H. Thompson (1994)

if k2 == 1
DistVector(i,:) = Diameter90;
else
index = sum(uniqueLength(:)) - uniqueLength(k2,:);
DistVector(index+i,:) = Diameter90;  
end
end
end

mu = mean(DistVector(:));
SD = std(DistVector(:));
%spres = (mu * 12000)/1000000; %2008
%spres = (mu * 40000)/1000000; %1999
spres = (mu * 20000)/1000000; %1984
