# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)


# Set the file path for the beta values
beta_values_WordsVsBaseline <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Activity/beta Activity visfAtlas/beta_Values_visfAtlas_WordsVsBaseline.txt"
beta_values_WordsVsFaces <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Activity/beta Activity visfAtlas/beta_Values_visfAtlas_WordsVsFaces.txt"
beta_values_FacesVsBaseline <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Activity/beta Activity visfAtlas/beta_Values_visfAtlas_FacesVsBaseline.txt"
beta_values_FacesVsWords <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Activity/beta Activity visfAtlas/beta_Values_visfAtlas_FacesVsWords.txt"



# Read data from TXT files for beta values
beta_WB <- read.table(beta_values_WordsVsBaseline, header = TRUE)
beta_WF <- read.table(beta_values_WordsVsFaces, header = TRUE)
beta_FB <- read.table(beta_values_FacesVsBaseline, header = TRUE)
beta_FW <- read.table(beta_values_FacesVsWords, header = TRUE)


# compute differences between the two groups
beta_WB <- beta_WB %>% mutate(differences = WordsVsBaseline_LH - WordsVsBaseline_RH)
beta_WF <- beta_WF %>% mutate(differences = WordsVsFaces_LH - WordsVsFaces_RH)
beta_FB <- beta_FB %>% mutate(differences = FacesVsBaseline_LH - FacesVsBaseline_RH)
beta_FW <- beta_FW %>% mutate(differences = FacesVsWords_LH - FacesVsWords_RH)




## Assumptions and preliminary tests
# test for outliers
# –> the resulting column 'is.extreme' should be FALSE for all participants shown
beta_WB %>% identify_outliers(differences)
beta_WF %>% identify_outliers(differences)
beta_FB %>% identify_outliers(differences)
beta_FW %>% identify_outliers(differences)


## exclude outliers

beta_WB_nooutliers <- beta_WB[!(row.names(beta_WB) %in% c("90")),]
beta_WF_nooutliers <- beta_WF[!(row.names(beta_WF) %in% c("27","41","48","90")),]
beta_FB_nooutliers <- beta_FB[!(row.names(beta_FB) %in% c("32","44","48","83","90")),]
beta_FW_nooutliers <- beta_FW[!(row.names(beta_FW) %in% c("27","41","48")),]


## Transform into long data (gather the LH and RH values in the same column)
beta_WB_nooutliers.long <- beta_WB_nooutliers %>%
  gather(key = "group", value = "WordsVsBaseline", WordsVsBaseline_LH, WordsVsBaseline_RH)
head(beta_WB_nooutliers.long, 3)

beta_WF_nooutliers.long <- beta_WF_nooutliers %>%
  gather(key = "group", value = "WordsVsFaces", WordsVsFaces_LH, WordsVsFaces_RH)
head(beta_WF_nooutliers.long, 3)

beta_FB_nooutliers.long <- beta_FB_nooutliers %>%
  gather(key = "group", value = "FacesVsBaseline", FacesVsBaseline_LH, FacesVsBaseline_RH)
head(beta_FB_nooutliers.long, 3)

beta_FW_nooutliers.long <- beta_FW_nooutliers %>%
  gather(key = "group", value = "FacesVsWords", FacesVsWords_LH, FacesVsWords_RH)
head(beta_FW_nooutliers.long, 3)


# Shapiro-Wilk normality test for the differences
beta_WB_nooutliers %>% shapiro_test(differences) # p-value = 0.587
beta_WF_nooutliers %>% shapiro_test(differences) # p-value = 0.659
beta_FB_nooutliers %>% shapiro_test(differences) # p-value = 0.00953
beta_FW_nooutliers %>% shapiro_test(differences) # p-value = 0.136


# QQ plot for the difference
ggqqplot(beta_WB_nooutliers, "differences")
ggqqplot(beta_WF_nooutliers, "differences")
ggqqplot(beta_FB_nooutliers, "differences")
ggqqplot(beta_FW_nooutliers, "differences")




## Paired Samples Wilcoxon Test
stat.testFB_nooutliers <- wilcox.test(FacesVsBaseline ~ group, data = beta_FB_nooutliers.long, paired = TRUE, alternative = "less")
stat.testFB_nooutliers # p-value = 1.822e-06
pstat.testFB_nooutliers <- stat.testFB_nooutliers$p.value


## one sided t-test
stat.testWB_nooutliers <- beta_WB_nooutliers.long  %>% 
  t_test(WordsVsBaseline ~ group, paired = TRUE, alternative = "greater") %>%
  add_significance()
stat.testWB_nooutliers # p-value = 0.0000000569

stat.testWF_nooutliers <- beta_WF_nooutliers.long  %>% 
  t_test(WordsVsFaces ~ group, paired = TRUE, alternative = "greater") %>%
  add_significance()
stat.testWF_nooutliers # p-value = 3.89e-25

stat.testFW_nooutliers <- beta_FW_nooutliers.long  %>% 
  t_test(FacesVsWords ~ group, paired = TRUE, alternative = "less") %>%
  add_significance()
stat.testFW_nooutliers # p-value = 1.75e-21



# Combine summaries into a single data frame row-wise
combined_summaries_nooutliers <- rbind(
  data.frame(ANOVA = "WordsVsBaseline", stat.testWB_nooutliers, row.names = NULL),
  data.frame(ANOVA = "WordsVsFaces", stat.testWF_nooutliers, row.names = NULL),
  data.frame(ANOVA = "FacesVsBaseline", pstat.testFB_nooutliers, row.names = NULL),
  data.frame(ANOVA = "FacesVsWords", stat.testFW_nooutliers, row.names = NULL)
)


# effect size (calculated with Cohen's)
effectWB_nooutliers <- beta_WB_nooutliers.long  %>% cohens_d(WordsVsBaseline ~ group, paired = TRUE)
effectWF_nooutliers <- beta_WF_nooutliers.long  %>% cohens_d(WordsVsFaces ~ group, paired = TRUE)
effectFB_nooutliers <- beta_FB_nooutliers.long  %>% cohens_d(FacesVsBaseline ~ group, paired = TRUE)
effectFW_nooutliers <- beta_FW_nooutliers.long  %>% cohens_d(FacesVsWords ~ group, paired = TRUE)


# Combine summaries into a single data frame row-wise
combined_effectsize_nooutliers <- rbind(
  data.frame(ANOVA = "WordsVsBaseline", effectWB_nooutliers, row.names = NULL),
  data.frame(ANOVA = "WordsVsFaces", effectWF_nooutliers, row.names = NULL),
  data.frame(ANOVA = "FacesVsBaseline", effectFB_nooutliers, row.names = NULL),
  data.frame(ANOVA = "FacesVsWords", effectFW_nooutliers, row.names = NULL)
)



## Visualization (rename columns and create boxplot)
# WordsVsBaseline

beta_WB_nooutliers.long[beta_WB_nooutliers.long == "WordsVsBaseline_LH"] <- "LH"
beta_WB_nooutliers.long[beta_WB_nooutliers.long == "WordsVsBaseline_RH"] <- "RH"

ggboxplot(beta_WB_nooutliers.long, x = "group", y = "WordsVsBaseline",
                ylab = "beta values", xlab = "Words>Baseline", add = "jitter")
ggsave("boxplot_WordsVsBaseline_betaValues.png")


# WordsVsFaces

beta_WF_nooutliers.long[beta_WF_nooutliers.long == "WordsVsFaces_LH"] <- "LH"
beta_WF_nooutliers.long[beta_WF_nooutliers.long == "WordsVsFaces_RH"] <- "RH"

ggboxplot(beta_WF_nooutliers.long, x = "group", y = "WordsVsFaces",
          ylab = "beta values", xlab = "Words>Faces", add = "jitter")
ggsave("boxplot_WordsVsFaces_betaValues.png")


# FacesVsBaseline

beta_FB_nooutliers.long[beta_FB_nooutliers.long == "FacesVsBaseline_LH"] <- "LH"
beta_FB_nooutliers.long[beta_FB_nooutliers.long == "FacesVsBaseline_RH"] <- "RH"

ggboxplot(beta_FB_nooutliers.long, x = "group", y = "FacesVsBaseline",
          ylab = "beta values", xlab = "Faces>Baseline", add = "jitter")
ggsave("boxplot_FacesVsBaseline_betaValues.png")


# FacesVsWords

beta_FW_nooutliers.long[beta_FW_nooutliers.long == "FacesVsWords_LH"] <- "LH"
beta_FW_nooutliers.long[beta_FW_nooutliers.long == "FacesVsWords_RH"] <- "RH"

ggboxplot(beta_FW_nooutliers.long, x = "group", y = "FacesVsWords",
          ylab = "beta values", xlab = "Faces>Words", add = "jitter")
ggsave("boxplot_FacesVsWords_betaValues.png")



