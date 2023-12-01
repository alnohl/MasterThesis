# Load required libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(readxl)


# Set the file path for your values of interest for one-way ANOVA
file_path <- "/path/to/your/data/for/one-way/ANOVA/data.txt."

# Read data from TXT files for beta values
table <- read.table(file_path, header = TRUE) 


# One-way ANOVA
anova <- table %>% anova_test(value_of_interest ~ group) # Perform one-way ANOVA for value_of_interest (e.g., reading ability, beta value, etc.) between group (at least 2 groups; e.g., typical readers and poor readers, etc.)

# Pairwise comparisons (Tukey post-hoc test)
pwc <- table %>% tukey_hsd(value_of_interest ~ group)

# Save the combined summaries to a CSV file
write.csv(anova, file = "/path/to/output/folder/ANOVA_file_name.csv", row.names = FALSE)
write.csv(pwc, file = "/path/to/output/folder/tukey_file_name.csv", row.names = FALSE)

