%% Read the Image then convert it to grayscale
I = imread('Pieces.png');
I = imrotate(I,2*90);
Ig = rgb2gray(I);
imshow(I)
%% preprocessing on the image
% Threshold image - manual threshold
BW = Ig > 233;

% Invert mask
BW = imcomplement(BW);

% Open mask with square
width = 3;
se = strel('square', width);
BW = imopen(BW, se);

%% Connected component analysis
cc = bwconncomp(bw, 4);
cc.NumObjects

%% Region Properties
tetrisdata = regionprops(cc, 'all');

%% Loading variables with required information
tetris_areas = [tetrisdata.Area];
tetris_eccentricity = [tetrisdata.Eccentricity];
Ma = [tetrisdata.MajorAxisLength];

%% Show Eccentricity information 
figure(1);
I1 = Ig;
for n = 1:7
    
rgb = insertShape(I1,'rectangle',tetrisdata(n).BoundingBox);
rgb = insertObjectAnnotation(rgb, 'rectangle', tetrisdata(n).BoundingBox, cellstr(num2str(tetris_eccentricity(n))), 'Color', 'cy');
imshow(rgb)
title('Eccentricity')
pause(0.5)
I1 = rgb;
hold on
end

hold off

%% Show the detected pieces
I2 = I;
figure(2);

for n = 1:7
E = tetris_eccentricity(n);
M = Ma(n);
if E<0.2
    shape = 'Square';
elseif E>0.2 && E< 0.75
        shape = 'T-piece';
elseif M>137 && M< 139
        shape = 'L-piece';
elseif M>129 && M< 131
    shape = 'Z-piece';
elseif E>0.9665
    shape = 'Rectangle';
end
rgb = insertObjectAnnotation(I2, 'rectangle', tetrisdata(n).BoundingBox, shape, 'Color', 'cy');
imshow(rgb)
title('Detected Pieces')
pause(0.5)
hold on
I2 = rgb;
end
hold off