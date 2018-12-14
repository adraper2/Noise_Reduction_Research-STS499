# Aidan Draper
# STS 499 - Calculating image PSNR, R-squared, MSE and SSIM

rm(list=ls())

require(raster)

getwd()

#setwd('~/../../Volumes/Draper_HD/STS499_dataset')
setwd('~/Documents/Senior_Year/STS 499/499_Pres')

# SELECT CURRENT IMAGE HERE:
filter.img <- as.matrix(raster("street_noise.jpg"))
#noise.img <- as.matrix(raster("IMG_0692.CR2"))
true.img <- as.matrix(raster("street_true.jpg"))

MSE.filter <- sum(abs(filter.img - true.img)^2)/length(true.img)
MSE.noise <- sum(abs(noise.img - true.img)^2)/length(true.img)

psnr.filter <- 20*log10(255^2/MSE.filter)
psnr.noise <- 20*log10(255^2/MSE.noise)

rsq.filter <- 1 - (sum((true.img-filter.img)^2)/sum((true.img-mean(true.img))^2))
rsq.noise <- 1 - (sum((true.img-noise.img)^2)/sum((true.img-mean(true.img))^2))
