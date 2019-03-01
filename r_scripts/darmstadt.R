# Copyright © 2007 Free Software Foundation, Inc. <https://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.

# Written by Aidan Draper
# Darmstadt dataset initial import

setwd('~/../../Volumes/Draper_HD/darmstadt')

library(h5) # package to read HDF files into matrices
library(R.matlab)
library(rhdf5)

matrix <- load("0001.mat")

readMat('0001.mat')
