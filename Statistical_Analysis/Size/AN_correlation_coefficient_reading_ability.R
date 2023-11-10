library("ggpubr")
library(ggplot2)
library(tidyverse)
library(rstatix)

# Set the file path for the sizes
path <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Hypotheses Analysis/H3.1 Size VWFA with Reading Ability/Size and Reading Ability data/reading_ability_data.txt"

# Read data from TXT files
table <- read.table(path, header = TRUE)



## Assumptions and preliminary tests

# test for outliers
# –> the resulting column 'is.extreme' should be FALSE for all participants shown
table %>% identify_outliers(size_WordsVsBaseline_pVWFA)
table %>% identify_outliers(size_WordsVsFaces_pVWFA)
table %>% identify_outliers(reading_skills_mean)



## CALCULATE CORRELATION COEFFICIENT

## WordsVsBaseline and reading ability
shapiro.test(table$size_WordsVsBaseline_pVWFA) # Shapiro-Wilk normality test for WordsVsBaseline, p-value = 0.002877
shapiro.test(table$reading_skills_mean) # Shapiro-Wilk normality test for reading skills mean, p-value = 0.000681

ggscatter(table, x = "size_WordsVsBaseline_pVWFA", y = "reading_skills_mean", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Words>Baseline", ylab = "mean reading skills",
          ylim=c(-5,120))
#P + yscale("log2", .format = TRUE)
ggsave("Rplot_size_WordsVsBaseline_pVWFA_reading_skills_mean.png")

cor.test(table$size_WordsVsBaseline_pVWFA, table$reading_skills_mean, method = "kendall") # p-value = 8.342e-07, tau = 0.3388953 



## WordsVsFaces and reading ability
# exclude outliers first

nooutliers <- table[!(row.names(table) %in% c("6","9","27","29","33","50","54","58","59","66","80","85","88")),]

ggscatter(nooutliers, x = "size_WordsVsFaces_pVWFA", y = "reading_skills_mean", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Words>Faces", ylab = "mean reading skills",
          ylim=c(-5,120))
ggsave("Rplot_size_WordsVsFaces_pVWFA_reading_skills_mean.png")


shapiro.test(nooutliers$size_WordsVsFaces_pVWFA) # Shapiro-Wilk normality test for WordsVsFaces
shapiro.test(nooutliers$reading_skills_mean) # Shapiro-Wilk normality test for reading skills mean

ggqqplot(nooutliers$size_WordsVsFaces_pVWFA, ylab = "WordsVsFaces")
ggqqplot(nooutliers$reading_skills_mean, ylab = "reading_skills_mean")

cor.test(nooutliers$size_WordsVsFaces_pVWFA, nooutliers$reading_skills_mean, method = "kendall")




## Further notes

#t is the t-test statistic value (eg. t = -9.559)
#df is the degrees of freedom (eg. df= 30)
#p-value is the significance level of the t-test (eg. p-value = 1.29410^{-10})
#conf.int is the confidence interval of the correlation coefficient at 95% (eg. conf.int = [-0.9338, -0.7441]);
#sample estimates is the correlation coefficient (eg. Cor.coeff = -0.87).

#if the p-value of the test is 1.29410^{-10}, which is less than the significance level alpha = 0.05
#We can conclude that wt and mpg are significantly correlated with a correlation coefficient of -0.87 and p-value of 1.29410^{-10}

#see: http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r#spearman-correlation-formula


# Extract the p.value: res$p.value
# Extract the correlation coefficient: res$estimate



#linear regression
lm <- lm(size_WordsVsBaseline ~ reading_skills_mean, data = table)
summary(lm)

plot(size_WordsVsBaseline ~ reading_skills_mean, data = table)
abline(lm)


