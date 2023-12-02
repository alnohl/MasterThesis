# Master Thesis Alexandra Nohl
## Brain activation during word and face processing
*1st of December 2023*


All scripts and codes used for fMRI data analyses, ROI analyses and statistical analyses for my Master Thesis "Brain activation during word and face processing".

### fMRI Data Analysis
In "fMRI_Data_Analysis" you can find the scripts used for preprocessing, quality check, and 1st and 2nd level analysis of the fMRI data.

### ROI Analysis
In "ROI_Analysis" are the scripts used for further calculations from the files computed in 1st and 2nd level processing. The following analyses are included:
- Peak coordinates to find coordinates of voxel with highest beta activity
- Voxel Extraction (above a certain t-value threshold) to determine the size of activation
- beta value extraction to calculate the mean beta value in a region of interest

### Statistical Analysis
In "Statistical_Analysis" you can find the codes used for statistical tests and further analysis of the fMRI data. The following analyses are included:
- t-test and Wilcoxon test to compare mean values between two groups
- one-way ANOVA to compare values of at least two groups
- Bayes factor (used to determine if there really is no difference between two groups after no significant difference was found with t-test or ANOVA)
- correlation analysis (Pearson and Kendall correlation)


## List of which scripts were used for which hypothesis of my master thesis:
Only scripts besides preprocessing, quality check and 1st level analysis are listed

### Aim 1
H1.1:
- "Statistical_Analysis > AN_onewayANOVA.R"
- "Statistical_Analysis > AN_Bayes_Factor.R"

### Aim 2
H2.1:
- "ROI_Analysis > Size_Voxel_Extraction"
- "AN_correlation_coefficient.R"

H2.2:
- "Statistical_Analysis > AN_t-test.R"

H2.3:
- "fMRI_Data_Analysis > 2nd_Level_Analysis > AN_2ndLevel_regression.m"
- "Statistical_Analysis > AN_correlation_coefficient.R"

### Aim 3
H3.1:
- "ROI_Analysis > Size_Voxel_Extraction"
- "Statistical_Analysis > AN_correlation_coefficient.R"

H3.2:
- "fMRI_Data_Analysis > 2nd_Level_Analysis > AN_2ndLevel_regression.m"

### Aim 4
H4.1:
- "fMRI_Data_Analysis > 2nd_Level_Analysis > AN_2ndLevel_regression.m"
- "ROI_Analysis > Size_Voxel_Extraction"
- "Statistical_Analysis > AN_correlation_coefficient.R"

H4.2:
- "fMRI_Data_Analysis > 2nd_Level_Analysis > AN_2ndLevel_regression.m"
- "ROI_Analysis > Size_Voxel_Extraction"
- "Statistical_Analysis > AN_correlation_coefficient.R"
