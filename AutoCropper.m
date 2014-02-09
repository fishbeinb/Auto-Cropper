RGB = imread('hack.png');
%RGB = imread('sand.png');
%RGB = imread('people.png');
%RGB = imread('cars.png');

figure, imshow(RGB), title('Original');
I = rgb2gray(RGB);
threshold = graythresh(I);
bw = im2bw(I,threshold);

%if true click on important point and press return to continue
select_point = false;

if select_point
        [point_x, point_y] = ginput;
end

pause;

[x, y] = size(bw);
q = round(y/80);
if x>y
    q = round(x/80);
end

%bwboundaries: white are objects, black is background
%assumes background is bigger than object
[x,y,z]=size(bw);
if nnz(bw) > (x*y/2)
        bw = imcomplement(bw);
end

se = strel('disk',q);
bw = imclose(bw,se);
bw = imfill(bw,'holes');
%closes out holes
bw = bwperim(bw,8);
bw = imfill(bw,'holes');

object_size = round(x*y/25);  
bw = bwareaopen(bw,object_size);

%figure, imshow(bw), title('Pre-Cropped');

if select_point 
        bw = bwselect(bw,[point_x],[point_y],8);
end

vertical = any(bw, 2);
horizontal = any(bw, 1);
row1 = find(vertical, 1, 'first'); % Y1
row2 = find(vertical, 1, 'last'); % Y2
column1 = find(horizontal, 1, 'first'); % X1
column2 = find(horizontal, 1, 'last'); % X2

%More percise
if (column2-column1 > x-10) && (row2-row1 > y-10)
    bw = bwareaopen(bw,object_size);
    vertical = any(bw, 2);
    horizontal = any(bw, 1);
    row1 = find(vertical, 1, 'first'); % Y1
    row2 = find(vertical, 1, 'last'); % Y2
    column1 = find(horizontal, 1, 'first'); % X1
    column2 = find(horizontal, 1, 'last'); % X2
end

RGBCropped = imcrop(RGB, [column1 row1 (column2-column1) (row2-row1)]);
figure, imshow(RGBCropped), title('Auto-Cropped');
imwrite(RGBCropped, 'Auto-Cropped.png');