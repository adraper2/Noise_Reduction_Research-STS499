# An explorative analysis into statistical methods for image denoising

## Introduction
In this research endeavor, Aidan Draper and his research advisor, Dr. Laura Taylor, investigate the presence of statistical concepts and methodology that underly many of the open-sourced, computer vision packages available. This ultimately involves sourcing statistical concepts in packages, benchmarking their performance against other common approaches to image denoising, and then, comparing memory use and time complexities of these various approaches. Some methods included in this study are Kalman Filters, Markov Random Fields, and Non-linear total variation. In addition, they attempt to debunk the idea that computer vision methodology is moving away from statistical approaches, and instead, towards unsupervised learning frameworks.

The file organization of this repo is laid out as:
* `images` - a folder containing all of the images used for benchmarking
* `r_scripts` - a folder containing all of the scripts written in R
* `main_denoise.R` - the main denoising script for running the other scripts in a more organized fashion (work in progress)
* `sts499_syllabus.pdf` - a copy of the syllabus used for grading this course at Elon University

Four benchmark parameters collected in this study are:
* PSNR (Peak Signal-to-Noise Ratio) = 20 * log10 ( R^2 / Mean Squared Error)
* MSE (Mean Square Error) = |true image - processed image|^2 / length of true image
* R-squared = 1 - (true image - processed image)^2 /(true image - mean(true image))^2
* SSIM (Structural SIMularity) = ______
* Time (in seconds) = the running time of the script