# Aidan Draper
# STS 499 - Reading and Processing TIFF files

rm(list=ls())

require(raster)

setwd('~/../../Volumes/Draper_HD/STS499_dataset')

raster.img <- raster("IMG_0662.CR2")

plot(raster.img)

mat.img <- as.matrix(raster.img, byrow=TRUE)

plot(raster(mat.img), col=grey(1:255/255))

hist(raster.img)$counts


# applying kernel filters as 3 x 3 grids and estimating the center value
new.img <- matrix(rep(0,length(mat.img)), ncol=length(mat.img[1,]),nrow=length(mat.img[,1]), byrow=TRUE)

for(x in 2:length(mat.img[1,])-1){
  for(y in 2:length(mat.img[,1])-1){
    #cat(mat.img[y,x],"\n")
    new.img[y,x] <- mean(c(mat.img[y-1,x-1],mat.img[y-1,x],mat.img[y-1,x+1],
                      mat.img[y,x-1],mat.img[y,x],mat.img[y,x+1],
                      mat.img[y+1,x-1],mat.img[y+1,x],mat.img[y+1,x+1]))
  }
}


# compare them visually
plot(raster(mat.img), col=grey(1:255/255), main="Origional")
plot(raster(new.img), col=grey(1:255/255), main="Homemade Mean Filter")


# calculate PSNR, MSE and R-squared
true.img <- as.matrix(raster("IMG_0660.CR2"), byrow=TRUE)

# we want a higher score
MSE.noise <- sum(abs(mat.img - true.img)^2)/length(true.img)
MSE.mean <- sum(abs(new.img - true.img)^2)/length(true.img)

# we want a higher score
psnr.noise <- 20*log10(255^2/MSE.noise)
psnr.mean <- 20*log10(255^2/MSE.mean)

# correlation between the image and the original
rsq.noise <- 1 - (sum((true.img-mat.img)^2)/sum((true.img-mean(true.img))^2))
rsq.mean <- 1 - (sum((true.img-new.img)^2)/sum((true.img-mean(true.img))^2))
