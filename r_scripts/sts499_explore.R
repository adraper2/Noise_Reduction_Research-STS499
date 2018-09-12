# STS 499 ~ Attempting noise reduction methods using open-sourced R packages
# 09/06/2018
# Aidan Draper

#image upload packages
library('jpeg')
library(raster)
library(imager)

# noise filter packages
library(wvtool) #grayscale only: gaussian, median, and mean filters
library(NoiseFiltersR) #NEED TO USE
library(magick) #NEED TO USE

# Kalman Filter packages
library('dse') # oldest Kalman filter package in R
library('dlm') # emphasis is on Bayesian analysis and "Dynamic Linear Models", but it also contains Kalman filters
library('FKF') #fast kalman filter
library('KFAS') # using BLAS and LAPACK linear algrebra functions to speed up process (most recent KF methods)

#library('sspir') not available under my version of R

setwd("~/Documents/Senior_Year/STS\ 499")

#image upload formats; sourced from: https://cdn.photographylife.com/wp-content/uploads/2010/07/Flying-Duck-Crop.jpg
imager.jpg <- load.image("images/duck.jpg") #imager package
read.jpg <- readJPEG("images/duck.jpg") #'jpeg' package
raster.jpg <- raster('images/duck.jpg') #raster package

#distributions of image values
hist(imager.jpg)
hist(read.jpg)
hist(raster.jpg)

#inital plots of images
#plot(read.jpg)
plot(raster.jpg)
plot(imager.jpg)

############## EXAMPLE: from online using mvtool (a wood vision tool?) ##############
data(camphora)
#camphora <- crop(camphora,200,200)

par(mfrow=c(1,1))
image(rot90c(camphora),col=gray(c(0:255)/255), main="Cinnamomum camphora")

par(mfrow=c(1,1))
image(rot90c(noise.filter(camphora,3,"gaussian")),col=gray(c(0:255)/255), 
      main="gaussian filter example", useRaster=TRUE)

######################################################################



############## EXAMPLE 1: mvtool package - Gaussian Filter  ##############
par(mfrow=c(1,1))
image(raster.jpg, col=gray(c(0:255)/255), main = "Gaussian Distribution Noise")

gaussian <- noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"gaussian")
par(mfrow=c(1,1))
image(gaussian, col=gray(c(0:255)/255), main = "Noise Removed (Gaussian)")

#comparing the distribution of origional and gaussian filter (are they removing a gaussian distribution?)
hist(raster.jpg)
hist(gaussian)

par(mfrow=c(1,1))
image(noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"mean"), col=gray(c(0:255)/255), main = "Noise Removed (Mean)")

par(mfrow=c(1,1))
image(noise.filter(rotate.matrix(as.matrix(raster.jpg), 90),3,"median"), col=gray(c(0:255)/255), main = "Noise Removed (Median)")

#look into why gaussian and mean methods worked the best

######################################################################



############## EXAMPLE 2: magick package -   ##############

