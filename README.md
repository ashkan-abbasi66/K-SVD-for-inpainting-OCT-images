# K-SVD for inpainting OCT images

This is an OLD code that implements inpainting missed columns of an OCT image. I am not sure that everything is correct. However, I tested it at 10/08/2021 on a 64 bit Windows 10 with MATLAB 2020. 

The main file is `ksvdinpaint_global_oct_1.m`. At first, it loads a pretrained dictionary or learns an adaptive dictionary using the well-known K-SVD method with [this package](https://sites.google.com/site/rahelekafieh/research/state-of-the-art-method-for-oct-denoising). Then, it performs inpainting missing columns. 

All credit goes to the original authors of the mentioned papers in the code. Please cite them properly if you are using this code. My contribution which was closely related to this project is [NWSR](https://github.com/ashkan-abbasi66/NWSR). 
