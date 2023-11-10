# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)


# Set the file path for the beta values
file_path_beta_values <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/ROI/Activity/beta_Values_visfAtlas_hemispheres.txt"

# Read data from TXT files for beta values
beta <- read.table(file_path_beta_values, header = TRUE)



# summary stats
beta %>%
  group_by(Group) %>%
  get_summary_stats(WordsVsBaseline, type = "mean_sd")
beta %>%
  group_by(Group) %>%
  get_summary_stats(WordsVsFaces, type = "mean_sd")

beta %>%
  group_by(Group) %>%
  get_summary_stats(FacesVsBaseline, type = "mean_sd")
beta %>%
  group_by(Group) %>%
  get_summary_stats(FacesVsWords, type = "mean_sd")
  


## Assumptions and preliminary tests
# test for outliers
beta %>%
  group_by(Group) %>%
  identify_outliers(WordsVsBaseline)
beta %>%
  group_by(Group) %>%
  identify_outliers(WordsVsFaces)

beta %>%
  group_by(Group) %>%
  identify_outliers(FacesVsBaseline)
beta %>%
  group_by(Group) %>%
  identify_outliers(FacesVsWords)


# check normality assumption (compute Shapiro wilk test by goups)
beta %>%
  group_by(Group) %>%
  shapiro_test(WordsVsBaseline)
beta %>%
  group_by(Group) %>%
  shapiro_test(WordsVsFaces)

beta %>%
  group_by(Group) %>%
  shapiro_test(FacesVsBaseline)
beta %>%
  group_by(Group) %>%
  shapiro_test(FacesVsWords)

# Draw a qq plot by group
ggqqplot(beta, x = "WordsVsBaseline", facet.by = "Group")
ggqqplot(beta, x = "WordsVsFaces", facet.by = "Group")

ggqqplot(beta, x = "FacesVsBaseline", facet.by = "Group")
ggqqplot(beta, x = "FacesVsWords", facet.by = "Group")


# check the equality of variances
beta %>% levene_test(WordsVsBaseline ~ Group)
beta %>% levene_test(WordsVsFaces ~ Group)

beta %>% levene_test(FacesVsBaseline ~ Group)
beta %>% levene_test(FacesVsWords ~ Group)



## one sided t-test
ttest.WordsVsBaseline <- beta %>%
  t_test(WordsVsBaseline ~ Group, alternative = "greater")
ttest.WordsVsBaseline
ttest.WordsVsFaces <- beta %>% 
  t_test(WordsVsFaces ~ Group, alternative = "greater")
ttest.WordsVsFaces

ttest.FacesVsBaseline <- beta %>% 
  t_test(FacesVsBaseline ~ Group, alternative = "less")
ttest.FacesVsBaseline
ttest.FacesVsWords <- beta %>% 
  t_test(FacesVsWords ~ Group, alternative = "less")
ttest.FacesVsWords


# Combine summaries into a single data frame row-wise
combined_summaries <- rbind(
  data.frame(ANOVA = "WordsVsBaseline", ttest.WordsVsBaseline, row.names = NULL),
  data.frame(ANOVA = "WordsVsFaces", ttest.WordsVsFaces, row.names = NULL),
  data.frame(ANOVA = "FacesVsBaseline", ttest.FacesVsBaseline, row.names = NULL),
  data.frame(ANOVA = "FacesVsWords", ttest.FacesVsWords, row.names = NULL)
)

# Save the combined summaries to a CSV file
write.csv(combined_summaries, file = "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/ROI/Activity/t-test_summary.csv", row.names = FALSE)




