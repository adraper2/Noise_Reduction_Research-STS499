# STS 499 ~ Attempting noise reduction methods using open-sourced R packages
# 09/06/2018
# Aidan Draper

#image upload packages
library('jpeg')
library(rasterImage)
library(imager)

setwd("~/Desktop")

#image upload formats
imager.jpg <- load.image("duck.jpg") #imager package
read.jpg <- readJPEG("duck.jpg") #'jpeg' package
raster.jpg <- raster('duck.jpg') #rasterImage package

hist(imager.jpg)
hist(read.jpg)
hist(raster.jpg)

plot(raster.jpg)
plot(imager.jpg)




