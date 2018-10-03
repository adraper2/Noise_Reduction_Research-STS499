# Aidan Draper
# Darmstadt dataset initial import

setwd('~/../../Volumes/Draper_HD/darmstadt')

library(h5) # package to read HDF files into matrices
library(R.matlab)
library(rhdf5)

matrix <- load("0001.mat")

readMat('0001.mat')
