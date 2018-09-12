# Application of various Kalman filters
# Aidan Draper
# September 11, 2018

library(raster)

# Kalman Filter packages
library('dse') # oldest Kalman filter package in R
library('dlm') # emphasis is on Bayesian analysis and "Dynamic Linear Models", but it also contains Kalman filters
library('FKF') #fast kalman filter
library('KFAS') # using BLAS and LAPACK linear algrebra functions to speed up process (most recent KF methods)

setwd("~/Documents/Senior_Year/STS\ 499")

### STEP 1: Image import and processing
rast.duck <- raster('images/duck.jpg')

rast.real <- raster('images/IMG0722Clean.bmp')
rast.noisy <- raster('images/IMG0722Noisy.bmp')

### STEP 2: Kalman filtering
start.time <- Sys.time() #start of approach








end.time <- Sys.time() #end of approach

### STEP 3: Benchmarking
r.squared <- 255 #default for grayscale (I think?)

mse <- 0
psnr <- 10*log10(r.squared/mse)
ssim <- 0 #need to lookup
run.time <- end.time - start.time

cat("Kalman filter MSE was:", mse)
cat("Kalman filter PSNR was:", psnr)
cat("Kalman filter SSIM was:", ssim)
cat("Kalman filter running time was:", run.time)

