# STS 499 ~ Attempting noise reduction methods using open-sourced R packages
# 09/06/2018
# Aidan Draper

#image upload packages
library('jpeg')
library(raster)
library(imager)

# noise filter packages
library(wvtool) #grayscale only: gaussian, median, and mean filters
library(NoiseFiltersR)

setwd("~/Documents/Senior_Year/STS\ 499")

#image upload formats; sourced from: https://cdn.photographylife.com/wp-content/uploads/2010/07/Flying-Duck-Crop.jpg
imager.jpg <- load.image("duck.jpg") #imager package
read.jpg <- readJPEG("duck.jpg") #'jpeg' package
raster.jpg <- raster('duck.jpg') #raster package

#distributions of image values
hist(imager.jpg)
hist(read.jpg)
hist(raster.jpg)

#inital plots of images
plot(raster.jpg)
plot(imager.jpg)

############## EXAMPLE: from online using mvtool (a wood vision tool?) ##############
data(camphora)
camphora <- crop(camphora,200,200)

par(mfrow=c(1,1))
image(rot90c(camphora),col=gray(c(0:255)/255), main="Cinnamomum camphora")

par(mfrow=c(1,1))
image(rot90c(noise.filter(camphora,3,"gaussian")),col=gray(c(0:255)/255), 
      main="gaussian filter example", useRaster=TRUE)

######################################################################

# first working example!!!
par(mfrow=c(1,1))
image(raster.jpg, col=gray(c(0:255)/255), main = "Gaussian Distribution Noise")

par(mfrow=c(1,1))
image(noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"gaussian"), col=gray(c(0:255)/255), main = "Noise Removed (Gaussian)")

par(mfrow=c(1,1))
image(noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"mean"), col=gray(c(0:255)/255), main = "Noise Removed (Mean)")

par(mfrow=c(1,1))
image(noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"median"), col=gray(c(0:255)/255), main = "Noise Removed (Median)")

#look into why gaussian and mean methods worked the best


