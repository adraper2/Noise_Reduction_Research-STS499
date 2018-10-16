# Aidan Draper
# STS 499 - Playing with basic 3 x 3 kernel filters and calculating PSNR, R-squared and MSE

rm(list=ls())

require(raster)

setwd('~/../../Volumes/Draper_HD/STS499_dataset')

raster.img <- raster("IMG_0662.CR2")

plot(raster.img)

mat.img <- as.matrix(raster.img, byrow=TRUE)

plot(raster(mat.img), col=grey(1:255/255))

hist(raster.img)$counts


# applying kernel filters as 3 x 3 grids and estimating the center value
mean.img <- matrix(rep(0,length(mat.img)), ncol=length(mat.img[1,]),nrow=length(mat.img[,1]), byrow=TRUE)
median.img <- matrix(rep(0,length(mat.img)), ncol=length(mat.img[1,]),nrow=length(mat.img[,1]), byrow=TRUE)

for(x in 2:length(mat.img[1,])-1){
  for(y in 2:length(mat.img[,1])-1){
    #cat(mat.img[y,x],"\n")
    mean.img[y,x] <- mean(c(mat.img[y-1,x-1],mat.img[y-1,x],mat.img[y-1,x+1],
                      mat.img[y,x-1],mat.img[y,x],mat.img[y,x+1],
                      mat.img[y+1,x-1],mat.img[y+1,x],mat.img[y+1,x+1]))
  }
}

for(x in 2:length(mat.img[1,])-1){
  for(y in 2:length(mat.img[,1])-1){
    #cat(mat.img[y,x],"\n")
    median.img[y,x] <- median(c(mat.img[y-1,x-1],mat.img[y-1,x],mat.img[y-1,x+1],
                            mat.img[y,x-1],mat.img[y,x],mat.img[y,x+1],
                            mat.img[y+1,x-1],mat.img[y+1,x],mat.img[y+1,x+1]))
  }
}

# compare them visually
plot(raster(mat.img), col=grey(1:255/255), main="Original", asp=NA)
plot(raster(mean.img), col=grey(1:255/255), main="Homemade Mean Filter", asp=NA)
plot(raster(median.img), col=grey(1:255/255), main="Homemade Median Filter", asp=NA)

# calculate PSNR, MSE and R-squared
true.img <- as.matrix(raster("IMG_0660.CR2"), byrow=TRUE)
plot(raster(true.img), col=grey(1:255/255), main="Noiseless Image", asp=NA)

# we want a higher score
MSE.noise <- sum(abs(mat.img - true.img)^2)/length(true.img)
MSE.mean <- sum(abs(mean.img - true.img)^2)/length(true.img)
MSE.median <- sum(abs(median.img - true.img)^2)/length(true.img)

# we want a higher score
psnr.noise <- 20*log10(255^2/MSE.noise)
psnr.mean <- 20*log10(255^2/MSE.mean)
psnr.median <- 20*log10(255^2/MSE.median)

# correlation between the image and the original
rsq.noise <- 1 - (sum((true.img-mat.img)^2)/sum((true.img-mean(true.img))^2))
rsq.mean <- 1 - (sum((true.img-mean.img)^2)/sum((true.img-mean(true.img))^2))
rsq.median <- 1 - (sum((true.img-median.img)^2)/sum((true.img-mean(true.img))^2))

# save your data if you wish
#setwd("~/Documents/Senior_Year/STS\ 499/filtered_images")
#save(median.img,mean.img, file="kernel_imgs.rdata")

# compare ADOBE denoiser
adobe.img <- as.matrix(raster("~/Desktop/STS\ 499\ Presentation/IMG_0692_lr.CR2"), byrow=TRUE)
true.img <- as.matrix(raster("________.CR2"), byrow=TRUE)

MSE.adobe <- sum(abs(adobe.img - true.img)^2)/length(true.img)
psnr.adobe <- 20*log10(255^2/MSE.adobe)
rsq.adobe <- 1 - (sum((true.img-adobe.img)^2)/sum((true.img-mean(true.img))^2))

