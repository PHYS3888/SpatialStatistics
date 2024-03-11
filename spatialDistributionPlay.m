% A = imread('Golem.png');
% doFlip = false;
% maxThreshold = 0.6;

% A = imread('NewtonCradle.png');
% doFlip = true;
% maxThreshold = 0.9;

% A = imread('wheat.png');
% doFlip = false;
% maxThreshold = 0.85;

A = imread('BakedBeans.png');
doFlip = false;
maxThreshold = 0.55;
minBins = 10;

%-------------------------------------------------------------------------------

Abw = rgb2gray(A);
percImage = double(Abw);
if doFlip
    percImage = max(percImage) - percImage;
end
percImage = percImage/max(percImage(:));
BW = (percImage > maxThreshold);


CC = bwconncomp(BW);
L = labelmatrix(CC);
RGB = label2rgb(L,'jet','k','shuffle');

f = figure('color','w');
subplot(2,2,1)
imshow(BW)
colormap('gray')
subplot(2,2,2)
imshow(RGB)

SS = regionprops(CC,'Area');
clusterAreas = [SS.Area];
subplot(2,2,3)
histogram(clusterAreas)
xlabel('Cluster area')
ylabel('Frequency')
subplot(2,2,4)
numBins = max(min(minBins,length(unique(clusterAreas))),2);
[binCenters,N,Nnorm] = binLogLog(numBins,clusterAreas);
loglog(binCenters,N,'o-k')
axis('square')
xlim([0.1,2.5e5])
xlabel('Cluster area')
ylabel('Frequency')
title(sprintf('Cluster sizes %u-%u',min(clusterAreas),max(clusterAreas)))
