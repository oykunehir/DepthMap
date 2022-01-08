# Depth Map 
Left and right images taken from stereo cameras calibrated in parallel. This code creates a depth map using these images.

## Basics

### Algorithm
1. Identify a pixel (P) in the left image.
2. Take the 3x3 area around it with P being the center.
3. Find where this region corresponds in the right image. Cameras parallel to each other
Since P is the center of the 3x3 region in the right image, where this region coincides.
will have the same horizontal coordinate.
4. Sum to calculate similarity of regions in left and right images.
Use [Squared Distance (SSD)](https://en.wikipedia.org/wiki/Sum_of_squares) . The SSD superimposes both regions and it is calculated by the sum of the squares of the difference of pixels.
5. Calculate the depth according to section below.

### Calculate Depth Map

<p align="center">
  <img width="400" src="https://iili.io/Y4NHFt.png">
</p>
The above diagram contains equivalent triangles. Writing their equivalent equations will yield us following result:

	disparity=x−x′=Bf/Z 
x and x′ are the distance between points in image plane corresponding to the scene point 3D and their camera center. B is the distance between two cameras (which we know) and f is the focal length of camera (already known). So in short, the above equation says that the depth of a point in a scene is inversely proportional to the difference in distance of corresponding image points and their camera centers. So with this information, we can derive the depth of all pixels in an image.

## Results
Focal Length=10  | Focal Length=20 
:-------------------------:|:-------------------------:
![](https://iili.io/Y4OSEB.png)  |  ![](https://iili.io/Y4e3Q4.png)
Focal Length=30  | Focal Length=40 
![](https://iili.io/Y4exyu.png)  |  ![](https://iili.io/Y4e0yg.png)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


