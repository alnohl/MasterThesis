The scripts in the folders "Size_Voxel_Extraction" and "beta_Value_Extraction" require MATLAB and the toolbox SPM12. "Size_Voxel_Extraction" results in the size of activation of the ROI (counting each voxel above a certain threshold).


The scripts "AN_Bayes_Factor.R", "AN_correlation_coefficient.R", "AN_onewayANOVA.R" and "AN_t-test.R" are codes for statistical analyses in R. "AN_Bayes_Factor.R" was only used after the script "AN_onewayANOVA.R" revealed no significant differences between the groups. "AN_correlation_coefficient.R" can be used for correlation analysis, calculating either the Pearson or Kendall correlation coefficient (depending if the data is distributed normally or not). "AN_t-test.R" can perform a t-test or a Wilcoxon test (also depending if the data is distributed normally or not).



List of which scripts were used for which hypothesis of my master thesis:

Aim 1
- H1.1: "AN_onewayANOVA.R", "AN_Bayes_Factor.R"

Aim 2
- H2.1: "Size_Voxel_Extraction", "AN_correlation_coefficient.R"
- H2.2: "AN_t-test.R"
- H2.3: "AN_2ndLevel_regression.m" (in folder fMRI_Data_Analysis > 2nd_Level_Analysis), "AN_correlation_coefficient.R"

Aim 3
- H3.1: "Size_Voxel_Extraction", "AN_correlation_coefficient.R"
- H3.2: "AN_2ndLevel_regression.m" (in folder fMRI_Data_Analysis > 2nd_Level_Analysis)

Aim 4
- H4.1: "AN_2ndLevel_regression.m" (in folder fMRI_Data_Analysis > 2nd_Level_Analysis), "Size_Voxel_Extraction", "AN_correlation_coefficient.R"
- H4.2: "AN_2ndLevel_regression.m" (in folder fMRI_Data_Analysis > 2nd_Level_Analysis), "Size_Voxel_Extraction", "AN_correlation_coefficient.R"
