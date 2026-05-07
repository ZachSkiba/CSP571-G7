# CSP 571 Group 7: Diabetes Classification Analysis

This repository contains our CSP 571 group project on diabetes classification using 2015 CDC BRFSS health-indicator data. The project compares binary and multiclass prediction tasks, documents the full modeling workflow, and keeps both the working materials and the final report available for review.

## Project Overview

We study the relationship between health and lifestyle indicators and diabetes outcomes using two related datasets:

- `data/raw/diabetes_binary.csv`: binary classification task
- `data/raw/diabetes_multiclass.csv`: multiclass classification task

The project includes exploratory analysis, preprocessing, unsupervised learning, supervised modeling, evaluation, and a final written report.

## Methods Covered

The repository includes work for:

- exploratory data analysis
- data preprocessing and train/test preparation
- PCA
- K-means clustering
- logistic regression
- KNN and Naive Bayes
- random forest
- SVM
- XGBoost

## Main Report

The full written analysis and final project report are in:

- [documents/reports/final_report.pdf](documents/reports/final_report.pdf)

Supporting planning and process documents are also included:

- [documents/Project_Plan.md](documents/Project_Plan.md)
- [documents/Pipeline_Rules.md](documents/Pipeline_Rules.md)

## Repository Structure

```text
.
|-- data/
|   |-- raw/                  # original diabetes datasets
|   `-- processed/            # shared train/test splits
|-- documents/
|   |-- Project_Plan.md       # project planning and roles
|   |-- Pipeline_Rules.md     # shared modeling and validation rules
|   `-- reports/              # final report and exported analysis PDFs
|-- notebooks/                # source notebooks and R Markdown analyses
|-- results/                  # result tables and exported metrics
|-- src/                      # reusable R scripts
|-- test/                     # test and validation scripts
`-- install_dependencies.R    # package installation script
```

## Notebooks And Analyses

The `notebooks/` folder contains the working analyses used throughout the project, including:

- `01_eda_binary.ipynb`
- `02_eda_multiclass.ipynb`
- `03_data_preparation_and_analysis.ipynb`
- `k_means.Rmd`
- `knn_vs_naive_bayes.Rmd`
- `logistic_regression.Rmd`
- `pca.Rmd`
- `random_forest.Rmd`
- `svm.ipynb`
- `xgboost.Rmd`

Additional exported PDFs for several of these analyses are collected in `documents/reports/`.

## Results

The complete narrative discussion of methods and findings is in the final report. Structured result tables used in the project are saved in:

- `results/` for additional model metric files

## Setup

This project uses R-based analysis scripts and notebooks. To install the main package dependencies, run:

```r
source("install_dependencies.R")
```

After installing packages, you can open the notebooks or R Markdown files and run the analyses from the repository root.

## Notes

- This repository keeps planning and workflow documents visible because they are part of the full course project record.
- The `documents/reports/` folder is the best place to start if you want the final written deliverables before reviewing the working notebooks.
