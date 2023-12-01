# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(readxl)
library(BayesFactor)
library(Matrix)
library(coda)


# Set the file path for your values of interest to calculate bayes factor
file_path <- "/path/to/your/data/to/calculate/bayes/factor/data.txt"


# Read data from TXT files for beta values
table <- read.table(file_path, header = TRUE)


## Bayes Factor (BF)
lmBF(value_of_interest ~ group, data = table, progress=FALSE) # calculate bayes factor for value_of_interest (e.g., reading ability, beta value, etc.) between group (at least 2 groups; e.g., typical readers and poor readers, etc.)

