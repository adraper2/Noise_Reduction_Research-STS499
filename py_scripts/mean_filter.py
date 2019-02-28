#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 27 20:29:14 2018

@author: Draper
"""

import cv2
import os
import time

img_dest = 'street_noise.jpg'
os.chdir('/Users/Draper/Documents/Senior_Year/STS 499/499_Pres/')

def main():
    img = cv2.imread(img_dest, 0)
    print(img)
    start_time = time.time()
    #print(img.shape[0], img.shape[1])
    for x in range(img.shape[0])[1:-1]:
        for y in range(img.shape[1])[1:-1]:
            img[x][y] = (int(img[x+1][y-1]) + int(img[x+1][y]) + int(img[x+1][y+1]) + 
                         int(img[x][y-1]) + int(img[x][y]) + int(img[x][y+1]) + 
                         int(img[x-1][y-1]) + int(img[x-1][y]) + int(img[x-1][y+1]))/9

    elapsed_time = time.time() - start_time


    #cv2.imwrite("street-mean_py.jpg", img)
    print('DONE!', elapsed_time)
    
main()
