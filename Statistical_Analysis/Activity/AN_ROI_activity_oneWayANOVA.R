# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(readxl)
#library(dplyr)

# Set the file path for the beta values
file_path_beta_values <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Statistical_analysis/ROI/Activity/Activity_visfAtlas/beta_Values_visfAtlas.txt"

# Read data from TXT files for beta values
beta <- read.table(file_path_beta_values, header = TRUE) 


# One-way ANOVA
anova_WordsVsBaseline <- beta %>% anova_test(WordsVsBaseline ~ group) # Perform one-way ANOVA for max_beta coordinate (WordsVsBaseline)
anova_WordsVsFaces <- beta %>% anova_test(WordsVsFaces ~ group) # Perform one-way ANOVA for max_beta coordinate (WordsVsBaseline)
anova_FacesVsBaseline <- beta %>% anova_test(FacesVsBaseline ~ group) # Perform one-way ANOVA for max_beta coordinate (WordsVsBaseline)
anova_FacesVsWords <- beta %>% anova_test(FacesVsWords ~ group) # Perform one-way ANOVA for max_beta coordinate (WordsVsBaseline)


# Pairwise comparisons (Tukey post-hoc test)
pwc_WordsVsBaseline <- beta %>% tukey_hsd(WordsVsBaseline ~ group)
pwc_WordsVsFaces <- beta %>% tukey_hsd(WordsVsFaces ~ group)
pwc_FacesVsBaseline <- beta %>% tukey_hsd(FacesVsBaseline ~ group)
pwc_FacesVsWords <- beta %>% tukey_hsd(FacesVsWords ~ group)



# Combine summaries into a single data frame row-wise
combined_summaries <- rbind(
  data.frame(ANOVA = "WordsVsBaseline", anova_WordsVsBaseline, pwc_WordsVsBaseline, row.names = NULL),
  data.frame(ANOVA = "WordsVsFaces", anova_WordsVsFaces, pwc_WordsVsFaces, row.names = NULL),
  data.frame(ANOVA = "FacesVsBaseline", anova_FacesVsBaseline, pwc_FacesVsBaseline, row.names = NULL),
  data.frame(ANOVA = "FacesVsWords", anova_FacesVsWords, pwc_FacesVsWords, row.names = NULL)
)

# Save the combined summaries to a CSV file
write.csv(combined_summaries, file = "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Statistical_analysis/ROI/Activity/Activity_visfAtlas/ANOVA_visfAtlas.csv", row.names = FALSE)

