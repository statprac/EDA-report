# Exploratory Data Analysis — Presidential Polling and Results

A starting place for your EDA Report, focusing on data cleaning.


## Project structure

```
eda_project/
├── README.md                     <- this file
├── explore-poll-clean-data.qmd   <- data cleaning/eda exploration
├── clean-poll-data.R             <- fully reproducible record of final data cleaning process
└── data/
    ├── raw/                  <- PUT DATA HERE: read-only, never edited
    │   ├── state_polls_2012.csv
    │   ├── state_polls_2016.csv
    |   ├── 1976-2024-president.csv
    │   └── ...
    └── clean/                <- YOUR cleaned data is written here by code
```

**The golden rule:** `data/raw/` is immutable. Never edit those files by
hand and never write over those files. Every cleaning, recoding, or reshaping decision is **coded**,
so that anyone can reproduce `data/clean/` from `data/raw/` by re-running the `clean-poll-data.R`
code. If you find yourself opening a CSV in Excel to "fix" something, stop and write it as code instead.

## Getting started

**One** student should:

1. Click 'Use this template', in the top right-hand corner of this page on GitHub.
2. Select 'Create a new repository'.
3. Create a new private repository under the Team Organisation (not under your personal account).

**Each** student should:

1. Open the project in RStudio by cloning your team's new repository locally.
2. Install any required packages.

Each team member may want to have their own copy of the `explore-poll-clean-data.qmd` to use.
If so, make new copies of this file for each team member.
Otherwise, each student can edit the existing file locally but only one member should commit and push to GitHub at a time (and other students should update their local copy with most recent versions).

## Reproducibility check

You can check reproducibility by restart R (fresh session) and running the whole script/quarto document from
top to bottom, starting from the raw data. If it completes without error, then it's reproducible. Don't forget to 
document the steps you take also!

