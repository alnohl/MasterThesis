# Master Thesis Alexandra Nohl
## Brain activation during word and face processing
1st of December 2023

All scripts and codes used for fMRI data analyses and statistical analyses for my Master Thesis "Brain activation during word and face processing".


In "fMRI_Data_Analysis" you can find the scripts used for preprocessing, quality check, and 1st and 2nd level analysis of the fMRI data.


In "Statistical_Analysis" you can find the codes used for statistical tests and further analysis of the fMRI data. The following analyses are included:

- Voxel Extraction (above a certain t-value threshold) to determine the size of activation
- beta value extraction to calculate the mean beta value in a region of interest
- t-test and Wilcoxon test to compare mean values between two groups
- one-way ANOVA to compare values of at least two groups
- Bayes factor (used to determine if there really is no difference between two groups after no significant difference was found with t-test or ANOVA)
- correlation analysis (Pearson and Kendall correlation)
