# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(readxl)
library(BayesFactor)
library(Matrix)
library(coda)
#library(dplyr)


# Set the file path for the beta values
file_path_beta_values <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Statistical_analysis/ROI/Activity/Activity_visfAtlas/beta_Values_visfAtlas.txt"


# Read data from TXT files for beta values
beta <- read.table(file_path_beta_values, header = TRUE)


## Bayes Factor (BF)

lmBF(WordsVsBaseline ~ group, data = beta, progress=FALSE)
lmBF(WordsVsFaces ~ group, data = beta, progress=FALSE)
lmBF(FacesVsBaseline ~ group, data = beta, progress=FALSE)
lmBF(FacesVsWords ~ group, data = beta, progress=FALSE)


