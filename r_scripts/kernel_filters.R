# Aidan Draper
# STS 499 - Playing with basic 3 x 3 kernel filters and calculating PSNR, R-squared and MSE

rm(list=ls())

require(raster)
require(png)
require(magick)

#setwd('~/../../Volumes/Draper_HD/STS499_dataset')
setwd('~/Desktop/499_Pres')

# SELECT CURRENT IMAGE HERE:
raster.img <- raster("street_noise.jpg")
true.img <- raster("street_true.jpg")

crop.layer <- extent(true.img, 2000,3000,1000,2000)

true.crop <- crop(true.img,crop.layer)
noisy.crop <- crop(raster.img, crop.layer)

plot(true.crop,col=grey(1:255/255))
plot(noisy.crop,col=grey(1:255/255))

noise.raw <- matrix(as.matrix(noisy.crop) - as.matrix(true.crop),nrow=1001, ncol=1001)

# this is alright
rbPal <- colorRampPalette(c('white','black'))
noise.col <- rbPal(10)[as.numeric(cut(0:255,breaks = 20))]
plot(raster(abs(noise.raw)), col=(noise.col))

# I am not too fond of this plot (I also discovered that camera shake is definitely a cause of variability)
plot(raster(noise.raw), col=((((-255:255)/255)+1)/2))

plot(matrix(as.matrix(noisy.crop) - as.matrix(true.crop),byrow=TRUE), 
     type="b",
     main="Signal Variability (Estimated Noise)",
     xlab="Photo Pixel Indices",
     ylab="Pixel Difference Score (-255:255)")

hist(as.matrix(noisy.crop) - as.matrix(true.crop), 
     main="Distribution of Difference in Images",
     xlab="Score difference")

true.img <- as.matrix(true.img, byrow=TRUE)
mat.img <- as.matrix(raster.img, byrow=TRUE)

#plot(raster(mat.img), col=grey(1:255/255))

hist(noisy.crop, breaks=20,main="Noisy Signal Distribution")
hist(true.crop, breaks=20, main = "True State Distribution")


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
adobe50.img <- as.matrix(raster("IMG_0692_lr50.jpg"), byrow=TRUE)
adobe100.img <- as.matrix(raster("IMG_0692_lr100.jpg"), byrow=TRUE)
#true.img <- as.matrix(raster("IMG_0695.CR2"), byrow=TRUE)

MSE.adobe50 <- sum(abs(adobe50.img - true.img)^2)/length(true.img)
MSE.adobe100 <- sum(abs(adobe100.img - true.img)^2)/length(true.img)

psnr.adobe50 <- 20*log10(255^2/MSE.adobe50)
psnr.adobe100 <- 20*log10(255^2/MSE.adobe100)

rsq.adobe50 <- 1 - (sum((true.img-adobe50.img)^2)/sum((true.img-mean(true.img))^2))
rsq.adobe100 <- 1 - (sum((true.img-adobe100.img)^2)/sum((true.img-mean(true.img))^2))


# SAVE MEAN FILTER
visual <- writePNG(mean.img)

image_read(visual)

#png('street-mean.png')
#plot(visual)
#dev.off()

