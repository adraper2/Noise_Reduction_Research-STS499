# Aidan Draper
# STS 499 - Reading and Processing TIFF files

rm(list=ls())

require(raster)

setwd('~/../../Volumes/Draper_HD/STS499_dataset')

raster.img <- raster("IMG_0662.CR2")

plot(raster.img)

mat.img <- as.matrix(raster.img)

plot(raster(mat.img), col=grey(1:255/255))

hist(raster.img)$counts


# applying kernel filters as 3 x 3 grids and estimating the center value
new.img <- as.matrix(rep(0,length(mat.img)), nrow=length(mat.img[1,]))

for(x in 1:length(mat.img[1,])){
  cat(mat.img[1,x],"\n")
}
