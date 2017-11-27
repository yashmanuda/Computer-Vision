Yash Ubale
2014CSB1040
Lab 4
==================================================================

Before running the code, kindly copy the 'auto_det_chal_train_7oct' folder inside the folder which contains 'Train_2014CSB1040.m', 'Test_2014CSB1040.m' and 'JSON.m' files. 

'Train_2014CSB1040.m' needs input as the path of the 'auto_det_chal_train_7oct' folder
Ex. 'E:\Academics\7th Semester\Computer Vision\Lab 4\auto_det_chal_train_7oct\'

'Test_2014CSB1040.m' needs two inputs, first being the same path above and second being the output of 'Train_2014CSB1040.m'

Make sure you run MATLAB in administrator mode, because at the end of running 'Test_2014CSB1040.m', it will create a fodler named 'results' inside 'auto_det_chal_train_7oct' folder which will store all the results.

Results contain images with green and red points along with red box and yellow boundary. Green points are points which are identified as points belonging to the 'auto' region. Red points are identified as points not belonging to the auto region. Red region is the original bounding box. Yellow boundary is the predicted boundary region of the auto. 

Output of 'Train_2014CSB1040.m' file is acutally the result of MLP training which needs to be fed to 'Test_2014CSB1040.m' as second input. I am including the results of training as 'res.mat' file, so that you don't need to run it for training. 

JSON.m file is just a JSON script parser. 
