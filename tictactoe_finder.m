%% Read the Image then convert it to grayscale
I = imread('tictactoe.jpg');
I = imresize(I,0.5);
Ig = rgb2gray(I);
imshow(I)
%%
% Threshold image - manual threshold
BW = Ig > 175;

% Invert mask
BW = imcomplement(BW);

% Open mask with octagon
radius = 3;
se = strel('octagon', radius);
BW = imopen(BW, se);
imshow(BW);
%%
%% Connected component analysis
cc = bwconncomp(BW, 4);
cc.NumObjects

%% Region Properties
tictac_data = regionprops(cc, 'all');
%%
t_en = [tictac_data.EulerNumber];
t_area = [tictac_data.Area];
%%
%% Show EulerNumber information 
% figure(1);
% I1 = Ig;
% for n = 1:cc.NumObjects   
% rgb = insertShape(I1,'rectangle',tictac_data(n).BoundingBox);
% rgb = insertObjectAnnotation(rgb, 'rectangle', tictac_data(n).BoundingBox, cellstr(num2str(t_en(n))), 'Color', 'blue');
% imshow(rgb)
% title('EulerNumber')
% pause(0.5)
% I1 = rgb;
% hold on
% end
% 
% hold off

%%
% Filter image based on image properties.
% BW_out = bwpropfilt(BW_out, 'Area', [0, 29036]);
% BW_out = bwpropfilt(BW_out, 'EulerNumber', [0, 0.95]);
I2 = I;
figure(2);

for n = 1:cc.NumObjects
    
t_a = t_area(n);
t_e = t_en(n);
    
%% Conditions
if t_a < 29036
    if t_e == 1
        Shape = 'X';
    else
        Shape = 'O';
    end

rgb = insertObjectAnnotation(I2, 'rectangle', tictac_data(n).BoundingBox, Shape, 'Color', 'blue');
imshow(rgb)
title('Detected Xs and Os')
pause(0.5)
hold on
I2 = rgb;
end
end
hold off
