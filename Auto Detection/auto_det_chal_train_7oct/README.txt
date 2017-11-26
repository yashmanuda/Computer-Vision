This is a sample dataset for the Autorickshaw detection challenge. The full dataset will be released shortly (see the Timeline in the website: http://cvit.iiit.ac.in/autorickshaw_detection ). 


### images
The images folder contains 800 images of autorickshaws. Each images file has a number in its filename.


### bbs
The bbs folder contains bbs.json file, which contain the ground truth bounding boxes. It is an array of lenth 800. The bounding box information corresponding to the image i.jpg can be found at the ith location in bbs array. 

The bounding box information is again an array. The length of the array the the number of autorickshaws in the that image. At each index the four vertices of the bounding box is provided. See the view.py script for an example.


### scripts

The scripts folder contains a file view.py, which opens the image and overlays the bounding boxes (closing the window, will show the next image). It serves as an example on how to view as well load the data format in bbs.json.


