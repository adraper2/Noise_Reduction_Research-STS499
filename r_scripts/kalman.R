# Copyright © 2007 Free Software Foundation, Inc. <https://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.

# Written by Aidan Draper
# Application of various Kalman filters
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

m.duck <- as.matrix(rast.duck)

hist(m.duck[1,])
hist(m.duck[2,])

plot(m.duck[1],m.duck[2])
smooth <- loess(m.duck[2,]~m.duck[1,])
lines(predict(smooth),col="red")

plot(m.duck, type="b", col="red")


### STEP 2: Kalman filtering
start.time <- Sys.time() #start of approach

#algorithm: input requires different matrices based on prior distribution
#my_dlm <- dlm(FF=______,V=______,GG=______,W=______,V=______,m0=______,C0=______)





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



### HOMEMADE KALMAN FILTER based on Laaraiedh's python code


# function call
gauss.pred <- function(X.mat, M.mat, S.mat){
  if (dim(M.mat)[2] == 1){
    
    DX <- X - rep(M.mat, dim(X.mat)[2])
    E <- 0.5 * rowSums(DX * (dot(ginv(S.mat), DX))) 
    E <- E + 0.5 * dim(M.mat)[1] * log(2 * pi) + 0.5 * log(det(S.mat))
    P <- exp(-E)
    
  } else if (dim(X.mat)[2] == 1){
    
    DX <- rep(X, dim(M.mat)[2]) - M.mat
    E <- 0.5 * rowSums(DX * (dot(ginv(S.mat), DX)))
    E <- E + 0.5 * dim(M.mat)[1] * log(2 * pi) + 0.5 * log(det(S.mat))
    P <- exp(-E)
    
  } else{
    
    DX <- X.mat - M.mat
    E <- 0.5 * dot(t(DX), dot(ginv(S.mat), DX))
    E <- E + 0.5 * dim(M.mat)[1]  * log(2 * pi) + 0.5 * log(det(S.mat))
    P <- exp(-E) 
    
  }
  return(P[1], E[1])
}

kf.predict <- function(X.mat, P.mat, A.mat, Q.mat, B.mat, U.mat){
  X.mat <- dot(A.mat, X.mat) + dot(B.mat, U.mat)
  P <- dot(A.mat, dot(P, t(A.mat))) + Q.mat
  pred.results <- list(X.mat, P.mat)
  return(pred.results) 
}

kf.update <- function(X.mat, P.mat, Y.mat, H.mat, R.mat){
  predict.mean <- dot(H.mat, X.mat)
  predict.cov <- R.mat + dot(H.mat, dot(P, t(H.mat)))
  gain <- dot(P, dot(H, ginv(predict.cov)))
  X.mat <- X.mat + dot(gain, (Y.mat - predict.mean))
  P.mat <- P.mat - dot(gain, dot(predict.cov, t(gain)))
  predict.prob <- gauss.pred(Y.mat, predict.mean, predict.cov)

  upd.results <- list(X.mat, P.mat, gain, predict.prob, predict.mean, predict.cov)
  return(upd.results)
}
