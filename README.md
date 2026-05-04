# 2022 FIFA World Cup Player Performance Analysis

This repository analyzes player performance in the 2022 FIFA World Cup using FBref data, focusing on variables such as goals, assists, minutes played, and per-90 statistics. It uses visualizations and summary statistics to identify patterns and better understand what contributes to effective player performance.

## Overview

This project uses player level data from the 2022 FIFA World Cup to examine how different performance variables relate to overall effectiveness. In addition to analyzing raw statistics like goals, assists, and minutes played, we will also use per-90 metrics to allow for fair comparisons between players with different playing time. The project involves cleaning and organizing the dataset, generating visualizations to compare players and trends, and computing summary statistics to identify relationships between variables. 

### Interesting Insight

This is optional but highly recommended. You'll include one interesting insight from your project as part of the README. This insight is most effective when you include a visual. Keep in mind that this visual must be included as an image file (e.g., JPG, PNG, etc.). You can export plots created with `{ggplot2}` by using the function `ggsave`.

## Data Sources and Acknowledgements

The data used in this project comes from FBref, specifically the 2022 FIFA World Cup player statistics page, which can be found at this link: 

https://fbref.com/en/comps/1/2022/2022-World-Cup-Stats 

This dataset includes detailed player level variables such as goals, assists, minutes played, and per-90 statistics.
Data processing and analysis were done in R using packages from the tidyverse, including dplyr, tidyr, and ggplot2 for data wrangling and visualizations. We also relied on course materials and instructor guidance to help shape the structure and approach of this project.

## Current Plan

1. Make a plan – As a group, we will outline our goals, assign roles, and decide how we will divide responsibilities for the project.
2. Define key questions and variables – We will decide which variables to focus on and what specific questions we want to answer about player performance.
3. Import the dataset into R – This inludes loading the FBref dataset into R and ensuring it is accessible.
4. Clean and tidy the data – We will handle missing values, rename variables if needed, and restructure the dataset into a usable format.
5. Compute summary statistics – We will calculate averages, distributions, and other summary measures for key variables.
6. Create visualizations – We will create scatterplots, bar charts, and other visuals using ggplot2 to explore relationships between variables.
7. Interpret results – As a group, we will analyze the outputs, identify patterns, and discuss what contributes to effective player performance.
8. Finalize and organize the project – We will collect our findings, write explanations, and structure the final repository.

## Repo Structure

This repository is organized to clearly separate the different components of the project. The README.md file provides an overview of the project, including its goals and key insights. The data/ folder contains both the raw and cleaned datasets used throughout the analysis. The scripts/ folder includes all R code used for data cleaning, analysis, and visualization. The outputs/ folder stores the plots, figures, and other results generated from the analysis. Finally, the docs/ folder contains the project plan, final report, and any additional supporting documents.

## Authors

This project was completed by Riya Dsouza, Ryland Jones, and Chenjian Wei. For any questions or further information, please reach out to the repository contributors through GitHub, or at rad5963@psu.edu, rmj5670@psu.edu, or cpw5679@psu.edu.
