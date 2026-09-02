# STATX290 Exploratory Data Analysis

This repository contains the group exploratory data analysis of U.S. presidential polling and election results for STATX290.

The project uses state-level polling data from the 2012 and 2016 U.S. presidential elections together with certified presidential election results from 1976–2024. The main focus is on polling accuracy and how it relates to factors such as election timing, pollster, survey mode and undecided voter share.

## Data

The project uses three raw datasets:

- State-Level Pre-Election Polls (2012)
- State-Level Pre-Election Polls (2016)
- Certified Presidential Returns 1976–2024

The raw datasets are stored in `data/raw/` and are kept unchanged.

Cleaned polling datasets are generated from the raw data and stored in `data/clean/`.

## Repository Structure

- `EDA-report.qmd`: main exploratory data analysis report
- `data/raw/`: original datasets
- `data/clean/`: cleaned datasets generated for analysis
- `clean-poll-data.R`: data cleaning and preparation script
- `README.md`: project overview and reproducibility instructions

## Data Cleaning

The polling data were cleaned before analysis. The main steps included:

- standardising variable names and formats
- converting dates and calculating days before Election Day
- handling missing and structurally unavailable values
- standardising state names
- checking duplicate observations and unusual values
- combining the 2012 and 2016 polling datasets
- creating consistent candidate and polling variables for analysis

Raw files were not manually edited. Cleaned datasets can be reproduced from the raw data using `clean-poll-data.R` in this repository.

## Exploratory Data Analysis

The report explores:

- historical presidential vote shares
- undecided voter distributions in 2012 and 2016
- polling activity before Election Day
- polling error and election timing
- differences in polling accuracy across pollsters
- differences in polling accuracy across survey modes

These findings are then used to develop research questions for further analysis.

## Reproducing the Analysis

1. Clone or download this repository.
2. Open the R project in RStudio.
3. Run the data cleaning script to generate the files in `data/clean/`.
4. Open `EDA-report.qmd`.
5. Render the Quarto document.

The report is designed to run from a fresh R session using files contained in this repository.

## Team Workflow

The project was completed collaboratively using GitHub. Team members worked on separate branches and used commits and pull requests to combine changes into the main report.

Commit messages were used to describe changes, and GitHub was used to review and manage contributions throughout the project.

## Authors
- Linh Chi Nguyen
- Isobel Cusack
- Caitlin Knowles
- Manjun Xu
