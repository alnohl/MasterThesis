library("ggpubr")
library(ggplot2)
library(tidyverse)
library(rstatix)

# Set the file path for the sizes
path <- "/path/to/your/text/file/with/data/for/correlation/analysisdata.txt"

# Read data from TXT files
table <- read.table(path, header = TRUE)



## ASSUMPTIONS AND PRELIMINARY TESTS

## test for outliers
# –> the resulting column 'is.outlier' should be FALSE for all participants shown
table %>% identify_outliers(value_of_interest_1) # add the table column name of your value of interest
table %>% identify_outliers(value_of_interest_2) 
# calculate correlation between value1 and value2


## exclude outliers (if there are any)
# exclude outliers first
nooutliers <- table[!(row.names(table) %in% c("1","2","3")),] # enter the row number of all outliers (here 1, 2, and 3)


## check if data is distributed normally
# normal distribution if p > 0.05 (use pearson correlation), not normal distributed if p < 0.05 (use kendall correlation)
shapiro.test(nooutliers$value_of_interest_1)
shapiro.test(nooutliers$value_of_interest_2)



## CALCULATE CORRELATION COEFFICIENT

ggscatter(nooutliers, x = "value_of_interest_1", y = "value_of_interest_2", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Value 1", ylab = "Value 2")
ggsave("ggscatter_plot_value1_value2.png") # save correlation

cor.test(nooutliers$value_of_interest_1, nooutliers$value_of_interest_2, method = "kendall") 





## FURTHER NOTES

# t is the t-test statistic value (eg. t = -9.559)
# df is the degrees of freedom (eg. df= 30)
# p-value is the significance level of the t-test (eg. p-value = 1.29410^{-10})
# conf.int is the confidence interval of the correlation coefficient at 95% (eg. conf.int = [-0.9338, -0.7441]);
# sample estimates is the correlation coefficient (eg. Cor.coeff = -0.87).

# if the p-value of the test is 1.29410^{-10}, which is less than the significance level alpha = 0.05
# We can conclude that wt and mpg are significantly correlated with a correlation coefficient of -0.87 and p-value of 1.29410^{-10}

# see: http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r#spearman-correlation-formula

