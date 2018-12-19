# Visual Perceptions about Gaussian Noise Filtering on Grayscale Low-light Photography

## Introduction
We employ several Spatial Domain linear filters on grayscale Gaussian noise disrupted images. In addition, we use Adobe's Lightroom denoise method in two forms (50% and 100%) on the same images. Then, benchmark scores are calculated by comparing noiseless photos to the filtered images produced. We were interested in what people thought about the resultant filtered images in comparison to the true noiseless images. Interest in this came from previous research questioning the ability for current benchmark scores to analyze filtering methods. Because image denoising is an NP-Hard problem, only hueristic methods have been produced. This has caused much competition in the field. Evaluating whether benchmark scores are accurately determining methods' abilities to produce improved image quality is important. A shiny app survey was built and 100 Elon University students from introductory mathematics and statistics courses were surveyed under IRB approval. After data collection, an ANOVA test was conducted and then, an ANCOVA test was run using training data from the survey.

The repository is defined as follows:
* `filtered_images` - a folder containing .rdata files of filtered image matrices
* `Image_Quality_Survey` - a folder containing the Shiny App survey produced
* `py_scripts` - a folder containing all of the OpenCV methods implemented (Non-local means, bilateral, and 3x3 mean filters)
* `r_scripts` - a folder containing scripts for benchmarks scoring, explorative analysis, ANOVA testing, and graph producing
* `investigating_image_quality-draper-taylor-RoughFinal.pdf` - the current version of the paper being submitted to NC Journal of Math and Stats
* `sts499_syllabus.pdf` - a copy of the syllabus used for grading this course at Elon University
* `sas_ancova.txt` - a SAS script to run the ANCOVA test
