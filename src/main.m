
imgLeft = imread("images/im1_L.png");
imgRight = imread("images/im1_R.png");
%%size(imgLeft) size(imgRight)

[paddedImage1,paddedImage2] = makePadding(imgLeft,imgRight);
depthMap = findDepthMap(paddedImage1,paddedImage2);
imshow(depthMap)
%%pout_imadjust = imadjust(depthMap);
%%montage({imgLeft,imgRight,depthMap},"Size",[1 3])


function depthMap = findDepthMap(imgRight,imgLeft)
    [rows1, columns1, ~] = size(imgLeft);
    depthMap = zeros(rows1-3,columns1-3);
    for c=2:columns1-2
        for r=2:rows1-2
            depthMap(r,c) = findOnePixelDepth(r,c,imgRight,imgLeft);
        end
    end
end

function [paddedImage1, paddedImage2] = makePadding(img1, img2)
    [rows1, columns1, ~] = size(img1);
    [rows2, columns2, ~] = size(img2);

    paddedImage1(2:rows1+1,2:columns1+1,1) = img1(:,:,1);
    paddedImage1(2:rows1+1,2:columns1+1,2) = img1(:,:,2);
    paddedImage1(2:rows1+1,2:columns1+1,3) = img1(:,:,3);

    paddedImage1(rows1+2,:,:) = zeros(1,columns1+1,3);
    paddedImage1(:,columns1+2,:) = zeros(rows1+2,1,3);

    paddedImage2(2:rows2+1,2:columns2+1,1) = img2(:,:,1);
    paddedImage2(2:rows2+1,2:columns2+1,2) = img2(:,:,2);
    paddedImage2(2:rows2+1,2:columns2+1,3) = img2(:,:,3);

    paddedImage2(rows2+2,:,:) = zeros(1,columns2+1,3);
    paddedImage2(:,columns2+2,:) = zeros(rows2+2,1,3);

    %%size(paddedImage1)
    %%size(paddedImage2)

end

function patch = findPatch(row,column,img)

    patch(1,1,1) = img(row-1,column-1,1);
    patch(1,2,1) = img(row,column-1,1);
    patch(1,3,1) = img(row+1,column-1,1);
    patch(2,1,1) = img(row-1,column,1);
    patch(2,2,1) = img(row,column,1);
    patch(2,3,1) = img(row+1,column,1);
    patch(3,1,1) = img(row-1,column+1,1);
    patch(3,2,1) = img(row,column+1,1);
    patch(3,3,1) = img(row+1,column+1,1);

    patch(1,1,2) = img(row-1,column-1,2);
    patch(1,2,2) = img(row,column-1,2);
    patch(1,3,2) = img(row+1,column-1,2);
    patch(2,1,2) = img(row-1,column,2);
    patch(2,2,2) = img(row,column,2);
    patch(2,3,2) = img(row+1,column,2);
    patch(3,1,2) = img(row-1,column+1,2);
    patch(3,2,2) = img(row,column+1,2);
    patch(3,3,2) = img(row+1,column+1,2);

    patch(1,1,3) = img(row-1,column-1,3);
    patch(1,2,3) = img(row,column-1,3);
    patch(1,3,3) = img(row+1,column-1,3);
    patch(2,1,3) = img(row-1,column,3);
    patch(2,2,3) = img(row,column,3);
    patch(2,3,3) = img(row+1,column,3);
    patch(3,1,3) = img(row-1,column+1,3);
    patch(3,2,3) = img(row,column+1,3);
    patch(3,3,3) = img(row+1,column+1,3);

end

function SSD = findSSD (patchLeft, patchRight)
sum = 0;
    for c = 1:3
        for r = 1:3
            RED = (patchLeft(c,r,1) - patchRight(c,r,1))^2;
            GREEN =  (patchLeft(c,r,2) - patchRight(c,r,1))^2;
            BLUE = (patchLeft(c,r,3) - patchRight(c,r,1))^2;
            sum = sum + RED + GREEN + BLUE;
        end
    end
    SSD = sum;
end

function RightLocation = findRightLocation(yl,patch,imgRight)
    [~, columns, ~] = size(imgRight);
    sections = round(linspace(2,columns-1,958));
    minSSD = Inf; 
    RightLocation = Inf;
    for c = sections
        rightPatch = findPatch(yl,c,imgRight);
        SSD = findSSD(patch,rightPatch);
        if SSD == 0
            RightLocation = c;
            break;
        end

        if minSSD > SSD
            minSSD = SSD;
            RightLocation = c;
        end
    end
    %%RightLocation
end

function onePixelDepth = findOnePixelDepth(rowLeft,columnLeft,imgRight,imgLeft)
    patch = findPatch(rowLeft,columnLeft,imgLeft);
    columnRight = findRightLocation(rowLeft,patch,imgRight);
    focalLength = 10;
    T = 1;
    onePixelDepth = abs((focalLength)*T/(columnLeft-columnRight));
end


















