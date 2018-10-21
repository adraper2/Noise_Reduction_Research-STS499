#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 21 15:12:17 2018

@author: Draper
"""

#import numpy as np
import cv2
import os
#import math

#img_dest = '~/../../Volumes/Draper_HD/STS499_dataset/IMG_0692.CR2'
img_dest = 'IMG_0692_ps.tif'

os.chdir('/Users/Draper/Desktop/')

def main():
    img = cv2.imread(img_dest, 0)
    print(img)
    bilateral_img = cv2.bilateralFilter(img,9,12.0,50.0)
    nonlocal_img = cv2.fastNlMeansDenoising(img, None, 7, 21,10)
    cv2.imwrite("filtered_cv2-bilateral.tif", bilateral_img)
    cv2.imwrite("filtered_cv2-nonlocal.tif", nonlocal_img)
    print('DONE!')
    
main()
    