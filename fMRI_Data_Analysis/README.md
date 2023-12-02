## fMRI Data Analysis

In this MRI study, structural and functional MRI data was acquired, B0 files about the magnetic field of the scanner, and logfiles of each session were saved. The data was saved in the following files:
- epis: functional data
- t1w: structural data
- b0: magnetic field data
- logfiles: includes the logfiles of all participants

In all three folders is a separate folder for each participant (named sub-..., with ... being the participant number)
\

### fMRI is analysed in the following sequence:
1. Preprocessing
2. Quality Check
3. 1st level analysis
4. 2nd level analysis (includes whole-brain t-test and regression)


MATLAB and the toolbox SPM12 are needed for all fMRI data analyses.
