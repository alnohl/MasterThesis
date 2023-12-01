# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)


# Set the file path for your values of interest for t-test (or Wilxocon test)
file_path <- "/path/to/your/data/for/t-test/data.txt"


# Read data from TXT files for beta values
table <- read.table(file_path, header = TRUE)


# compute differences between the two groups
table <- table %>% mutate(differences = group1 - group2)


## ASSUMPTIONS AND PRELIMINARY TESTS

## test for outliers
# –> the resulting column 'is.extreme' should be FALSE for all participants shown
table %>% identify_outliers(differences)


## exclude outliers
nooutliers <- table[!(row.names(table) %in% c("1","2","3")),] # enter the row number of all outliers (of both group 1 and group 2; here 1, 2, and 3)


## Shapiro-Wilk normality test for the differences
# normal distribution if p > 0.05 (use t-test), not normal distributed if p < 0.05 (use Wilcoxon test)
nooutliers %>% shapiro_test(differences)

# QQ plot for the difference
ggqqplot(nooutliers, "differences")



## Transform into long data (gather the values of group 1 and group 2 in the same column)
nooutliers.long <- nooutliers %>%
  gather(key = "group", value = "value_of_interest", group1, group2)
head(nooutliers.long, 3)



## one sided grouped t-test
t_test_nooutliers <- nooutliers.long  %>% 
  t_test(value_of_interest ~ group, paired = TRUE, alternative = "greater") %>% # enter "greater" or "less"
  add_significance()
t_test_nooutliers


## Paired Samples Wilcoxon Test
wilcoxon_test_nooutliers <- wilcox.test(value_of_interest ~ group, data = nooutliers.long, paired = TRUE, alternative = "less") # enter "greater" or "less"
wilcoxon_test_nooutliers 
pwilcoxon_test_nooutliers <- wilcoxon_test_nooutliers$p.value



# effect size (calculated with Cohen's)
effect_nooutliers <- nooutliers.long  %>% cohens_d(value_of_interest ~ group, paired = TRUE)



## Visualization (rename columns and create boxplot)

ggboxplot(nooutliers.long, x = "group", y = "value_of_interest",
                ylab = "value_of_interest, xlab = "Groups", add = "jitter")
ggsave("boxplot_groups.png")



