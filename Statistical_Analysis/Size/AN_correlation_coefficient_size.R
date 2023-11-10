library("ggpubr")
library(ggplot2)
library(tidyverse)
library(rstatix)


# Set the file path for the sizes
path_size_VWFA_left <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction WFU Pickatlas/VoxelExtraction_VWFA_mask_OTC_left.txt"
path_size_FFA_left <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction WFU Pickatlas/VoxelExtraction_FFA_mask_OTC_left.txt"
path_size_VWFA_right <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction WFU Pickatlas/VoxelExtraction_VWFA_mask_OTC_right.txt"
path_size_FFA_right <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction WFU Pickatlas/VoxelExtraction_FFA_mask_OTC_right.txt"

#path_size_VWFA_left <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction visfAtlas/VoxelExtraction_VWFA_left.txt"
#path_size_FFA_left <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction visfAtlas/VoxelExtraction_FFA_left.txt"
#path_size_VWFA_right <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction visfAtlas/VoxelExtraction_VWFA_right.txt"
#path_size_FFA_right <- "/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction visfAtlas/VoxelExtraction_FFA_right.txt"


# Read data from TXT files
size_VWFA_left <- read.table(path_size_VWFA_left, header = TRUE)
size_FFA_left <- read.table(path_size_FFA_left, header = TRUE)

size_VWFA_right <- read.table(path_size_VWFA_right, header = TRUE)
size_FFA_right <- read.table(path_size_FFA_right, header = TRUE)


# Add "Baseline" column to identify each row's origin
size_FFA_left_edited <- size_FFA_left[, 2:ncol(size_FFA_left)]
size_FFA_right_edited <- size_FFA_right[, 2:ncol(size_FFA_right)]

combined_ll <- cbind(size_VWFA_left, size_FFA_left_edited) # Combine the two tables and stack rows on top of each other
combined_lr <- cbind(size_VWFA_left, size_FFA_right_edited) # Combine the two tables and stack rows on top of each other
combined_rr <- cbind(size_VWFA_right, size_FFA_right_edited) # Combine the two tables and stack rows on top of each other
#combined_FFA <- cbind(size_FFA_left, size_FFA_right_edited) # Combine the two tables and stack rows on top of each other


## Assumptions and preliminary tests
# Visualize data using a scatter plot (see if they are linear)
ggscatter(combined_ll, x = "WordsVsBaseline_left", y = "FacesVsBaseline_left", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Words>Baseline LH", ylab = "Faces>Baseline LH")

ggscatter(combined_ll, x = "WordsVsFaces_left", y = "FacesVsWords_left", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Words>Faces LH", ylab = "Faces>Words LH")


# test for outliers
# –> the resulting column 'is.extreme' should be FALSE for all participants shown

combined_ll %>% identify_outliers(WordsVsBaseline_left)
combined_ll %>% identify_outliers(WordsVsFaces_left)
combined_ll %>% identify_outliers(FacesVsBaseline_left)
combined_ll %>% identify_outliers(FacesVsWords_left)

combined_lr %>% identify_outliers(WordsVsBaseline_left)
combined_lr %>% identify_outliers(WordsVsFaces_left)
combined_lr %>% identify_outliers(FacesVsBaseline_right)
combined_lr %>% identify_outliers(FacesVsWords_right)

combined_rr %>% identify_outliers(WordsVsBaseline_right)
combined_rr %>% identify_outliers(WordsVsFaces_right)
combined_rr %>% identify_outliers(FacesVsBaseline_right)
combined_rr %>% identify_outliers(FacesVsWords_right)

combined_FFA %>% identify_outliers(FacesVsBaseline_left)
combined_FFA %>% identify_outliers(FacesVsWords_left)
combined_FFA %>% identify_outliers(FacesVsBaseline_right)
combined_FFA %>% identify_outliers(FacesVsWords_right)



## EXCLUDE OUTLIERS AND CALCULATE CORRELATION COEFFICIENT

# no outliers VWFA_left and FFA_left

nooutliers_ll_Baseline <- combined_ll[!(row.names(combined_ll) %in% c("27")),] # OTC
#nooutliers_ll_Baseline <- combined_ll # visfAtlas

shapiro.test(nooutliers_ll_Baseline$WordsVsBaseline_left) # Shapiro-Wilk normality test for WordsVsBaseline, OTC: p-value = 0.03373
shapiro.test(nooutliers_ll_Baseline$FacesVsBaseline_left) # Shapiro-Wilk normality test for FacesVsBaseline, OTC: p-value = 0.8875

ggscatter(nooutliers_ll_Baseline, x = "WordsVsBaseline_left", y = "FacesVsBaseline_left", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          title = NULL, xlab = "Size of activation Words>Baseline LH", ylab = "Size of activation Faces>Baseline LH",
          xlim=c(0,1000), ylim=c(0,1000))
ggsave("Rplot_WordsVsBaseline_LH_FacesVsBaseline_LH_OTC.png")

cor.test(nooutliers_ll_Baseline$WordsVsBaseline_left, nooutliers_ll_Baseline$FacesVsBaseline_left, method = "kendall") # OTC: p-value = 7.649e-11, tau = 0.4466449
cor.test(nooutliers_ll_Baseline$WordsVsBaseline_left, nooutliers_ll_Baseline$FacesVsBaseline_left, method = "kendall") # visfAtlas: p-value = 7.469e-07, tau = 0.3407647 



nooutliers_ll_WF <- combined_ll[!(row.names(combined_ll) %in% c("6","9","29","33","36","54","63","73","79","84","85","88")),] # OTC
#nooutliers_ll_WF <- combined_ll[!(row.names(combined_ll) %in% c("6","9","27","29","33","50","54","58","59","66","80","85","88")),] # visfAtlas

ggscatter(nooutliers_ll_WF, x = "WordsVsFaces_left", y = "FacesVsWords_left",
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Size of activation Words>Faces LH", ylab = "Size of activation Faces>Words LH")
ggsave("Rplot_WordsVsFaces_LH_FacesVsWords_LH_OTC.png")

shapiro.test(nooutliers_ll_WF$WordsVsFaces_left) # Shapiro-Wilk normality test for WordsVsFaces, OTC: p-value = 1.115e-06
shapiro.test(nooutliers_ll_WF$FacesVsWords_left) # Shapiro-Wilk normality test for FacesVsWords, OTC: p-value = 3.851e-05

cor.test(nooutliers_ll_WF$WordsVsFaces_left, nooutliers_ll_WF$FacesVsWords_left, method = "kendall") # OTC: p-value = 1.637e-05, tau = -0.3156924
cor.test(nooutliers_ll_WF$WordsVsFaces_left, nooutliers_ll_WF$FacesVsWords_left, method = "kendall") # visfAtlas: p-value = 0.000126, tau = -0.3048612



# no outliers VWFA_right and FFA_right

nooutliers_rr_Baseline <- combined_rr[!(row.names(combined_rr) %in% c("27","33","44","53")),] # OTC
#nooutliers_rr_Baseline <- combined_rr[!(row.names(combined_rr) %in% c("2","9","18","21","33","50","57","63","69","70","80","90")),] # visfAtlas

ggscatter(nooutliers_rr_Baseline, x = "WordsVsBaseline_right", y = "FacesVsBaseline_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Size of activation Words>Baseline RH", ylab = "Size of activation Faces>Baseline RH")
ggsave("Rplot_WordsVsBaseline_RH_FacesVsBaseline_RH_OTC.png")

shapiro.test(nooutliers_rr_Baseline$WordsVsBaseline_right) # Shapiro-Wilk normality test for WordsVsBaseline, OTC: p-value = 0.002427
shapiro.test(nooutliers_rr_Baseline$FacesVsBaseline_right) # Shapiro-Wilk normality test for FacesBaseline, OTC: p-value = 0.9553

cor.test(nooutliers_rr_Baseline$WordsVsBaseline_right, nooutliers_rr_Baseline$FacesVsBaseline_right, method = "kendall") # OTC: p-value = 6.371e-09, tau = 0.4048874
cor.test(nooutliers_rr_Baseline$WordsVsBaseline_right, nooutliers_rr_Baseline$FacesVsBaseline_right, method = "kendall") # visfAtlas: p-value = 0.0001945, tau = 0.2763463



nooutliers_rr_WF <- combined_rr[!(row.names(combined_rr) %in% c("1","6","9","17","32","48","65","73","77","85","90")),] # OTC
#nooutliers_rr_WF <- combined_rr[!(row.names(combined_rr) %in% c("4","9","21","23","24","28","30","32","33","41","48","52","54","58","65","66","67","69","75","77","85","86","90","97")),] # visfAtlas –> alle values nur noch 0

ggscatter(nooutliers_rr_WF, x = "WordsVsFaces_right", y = "FacesVsWords_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Size of activation Words>Faces RH", ylab = "Size of activation Faces>Words RH")
ggsave("Rplot_WordsVsFaces_RH_FacesVsWords_RH_OTC.png")

shapiro.test(nooutliers_rr_WF$WordsVsFaces_right) # Shapiro-Wilk normality test for WordsVsFaces, OTC: p-value = 1.348e-10
shapiro.test(nooutliers_rr_WF$FacesVsWords_right) # Shapiro-Wilk normality test for FacesVsWords, OTC: p-value = 0.0003376

cor.test(nooutliers_rr_WF$WordsVsFaces_right, nooutliers_rr_WF$FacesVsWords_right, method = "kendall") # OTC: p-value = 1.746e-07, tau = -0.3882155



# no outliers VWFA_left and FFA_right

nooutliers_lr_Baseline <- combined_lr[!(row.names(combined_lr) %in% c("27","44","53")),] # OTC
#nooutliers_lr_Baseline <- combined_lr[!(row.names(combined_lr) %in% c("2","9","21","50","57","63","70")),] #???? visfAtlas

ggscatter(nooutliers_lr_Baseline, x = "WordsVsBaseline_left", y = "FacesVsBaseline_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "spearman",
          xlab = "Size of activation Words>Baseline LH", ylab = "Size of activation Faces>Baseline RH",
          ylim=c(0,1000))
ggsave("Rplot_WordsVsBaseline_LH_FacesVsBaseline_RH_OTC.png")

shapiro.test(nooutliers_lr_Baseline$WordsVsBaseline_left) # Shapiro-Wilk normality test for WordsVsBaseline, OTC: p-value = 0.03061
shapiro.test(nooutliers_lr_Baseline$FacesVsBaseline_right) # Shapiro-Wilk normality test for FacesBaseline, OTC: p-value = 0.8247

cor.test(nooutliers_lr_Baseline$WordsVsBaseline_left, nooutliers_lr_Baseline$FacesVsBaseline_right, method = "kendall") # OTC: p-value = 1.622e-06, tau = 0.3325651
cor.test(nooutliers_lr_Baseline$WordsVsBaseline_left, nooutliers_lr_Baseline$FacesVsBaseline_right, method = "kendall") # visfAtlas: p-value = 0.0002425, tau = 0.2635914 



nooutliers_lr_WF <- combined_lr[!(row.names(combined_lr) %in% c("6","9","29","33","36","54","73","84","85","88")),] # OTC
#nooutliers_lr_WF <- combined_lr[!(row.names(combined_lr) %in% c("6","9","27","29","33","50","54","58","59","66","80","85","88")),] # visfAtlas

ggscatter(nooutliers_lr_WF, x = "WordsVsFaces_left", y = "FacesVsWords_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "kendall",
          xlab = "Size of activation Words>Faces LH", ylab = "Size of activation Faces>Words RH")
ggsave("Rplot_WordsVsFaces_LH_FacesVsWords_RH_OTC.png")

shapiro.test(nooutliers_lr_WF$WordsVsFaces_left) # Shapiro-Wilk normality test for WordsVsFaces, OTC: p-value = 5.483e-07
shapiro.test(nooutliers_lr_WF$FacesVsWords_right) # Shapiro-Wilk normality test for FacesVsWords, OTC: p-value = 0.0001428

cor.test(nooutliers_lr_WF$WordsVsFaces_left, nooutliers_lr_WF$FacesVsWords_right, method = "kendall") # OTC: p-value = 0.0006546, tau = -0.2470157
cor.test(nooutliers_lr_WF$WordsVsFaces_left, nooutliers_lr_WF$FacesVsWords_right, method = "kendall") # visfAtlas: p-value = 0.1538, tau = -0.1125762



# no outliers FFA_left and FFA_right

nooutliers_FFA_Baseline <- combined_FFA[!(row.names(combined_FFA) %in% c("27","44","53")),] # OTC
#nooutliers_FFA_Baseline <- combined_FFA[!(row.names(combined_FFA) %in% c("2","9","21","50","57","63","70")),] # visfAtlas

ggscatter(nooutliers_FFA_Baseline, x = "FacesVsBaseline_left", y = "FacesVsBaseline_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "spearman",
          xlab = "Size of activation Faces>Baseline LH", ylab = "Size of activation Faces>Baseline RH")

shapiro.test(nooutliers_FFA_Baseline$FacesVsBaseline_left) # Shapiro-Wilk normality test for FacesVsBaseline, OTC: p-value = 0.9075
shapiro.test(nooutliers_FFA_Baseline$FacesVsBaseline_right) # Shapiro-Wilk normality test for FacesBaseline, OTC: p-value = 0.8247

cor.test(nooutliers_FFA_Baseline$FacesVsBaseline_left, nooutliers_FFA_Baseline$FacesVsBaseline_right, method = "pearson") # OTC: p-value < 2.2e-16, cor = 0.8032497
cor.test(nooutliers_FFA_Baseline$FacesVsBaseline_left, nooutliers_FFA_Baseline$FacesVsBaseline_right, method = "kendall") # visfAtlas: p-value = 3.031e-05, tau = 0.3009295


#nooutliers_FFA_WF <- combined_FFA[!(row.names(combined_FFA) %in% c("63","73","79")),] # OTC
nooutliers_FFA_WF <- combined_FFA # visfAtlas
nooutliers_FFA_WF %>% identify_outliers(FacesVsWords_left)
nooutliers_FFA_WF %>% identify_outliers(FacesVsWords_right)

ggscatter(nooutliers_FFA_WF, x = "FacesVsWords_left", y = "FacesVsWords_right", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "spearman",
          xlab = "Size of activation Faces>Words LH", ylab = "Size of activation Faces>Words RH")

shapiro.test(nooutliers_FFA_WF$FacesVsWords_left) # Shapiro-Wilk normality test for FacesVsWords, OTC: p-value = 2.589e-05
shapiro.test(nooutliers_FFA_WF$FacesVsWords_right) # Shapiro-Wilk normality test for FacesVsWords, OTC: p-value = 0.0001214

cor.test(nooutliers_FFA_WF$FacesVsWords_left, nooutliers_FFA_WF$FacesVsWords_right, method = "kendall") # OTC: p-value = 1.136e-12, tau = 0.4936834
cor.test(nooutliers_FFA_WF$FacesVsWords_left, nooutliers_FFA_WF$FacesVsWords_right, method = "kendall") # p-value = 8.504e-07, tau = 0.3438366


