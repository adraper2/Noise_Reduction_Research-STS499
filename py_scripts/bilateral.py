# Copyright © 2007 Free Software Foundation, Inc. <https://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.

# Written by Aidan Draper

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 21 15:12:17 2018

@author: Draper
"""

#import numpy as np
import cv2
import os
import time
#import math

#img_dest = '~/../../Volumes/Draper_HD/STS499_dataset/IMG_0692.CR2'
img_dest = '499_Pres/street_noise.jpg'

os.chdir('/Users/Draper/Documents/Senior_Year/STS 499/')

def main():
    img = cv2.imread(img_dest, 0)
    print(img)
    start_time = time.time()
    bilateral_img = cv2.bilateralFilter(img,9,100.0,100.0)
    #nonlocal_img = cv2.fastNlMeansDenoising(img, None, 20, 25,25)
    elapsed_time = time.time() - start_time
    #cv2.imwrite("shoes-bilateral.jpg", bilateral_img)
    #cv2.imwrite("shoes-nonlocal.jpg", nonlocal_img)
    print('DONE!', elapsed_time)
    
main()
    