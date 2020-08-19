# Data Analysis

The data analysis was conducted using the R project v4 and PyCharm.

Each script was renamed after its research question. 
The script `rq4.R` refers to RQ4.1.
The script `rq1.R` contains the data analysis for RQ1.1, RQ1.2 and RQ1.3.

Each RQx script contains the folloing flow:

1. Praparation phase
    * Import required R libraries;
    * Import utility sources;
    * Read data;
1. Data exploration phase
    * Generate summary per treatment and subject
    * Generate plots: boxplot, violin plot and frequency plot
1. Normality and data transformation phase
    * Generate QQ-plot
    * Run shapiro wilks
    * Transfor data 
    * Run shapiro wilks to each transformation
1. Hypothesis test
    * Run hypothesis test: ANOVA | Kruskal Wallis | T-test | Mann Whitney
    * Run effect size
    
Some scripts mkight have an additiona exploration due to unique charactistics of the data

The output directory is organized per script
