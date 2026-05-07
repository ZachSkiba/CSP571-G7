# CSP 571 Project Plan

## Project Goal

The goal of this project is to better understand the relationship between lifestyle and diabetes outcomes in the United States. We compare two related prediction tasks using BRFSS 2015 health-indicator data:

- a multiclass task with labels `0`, `1`, and `2`
- a binary task with labels `0` and `1`

## Datasets

### Dataset 1: `diabetes_012_health_indicators_BRFSS2015.csv`

- Contains 253,680 survey responses from the CDC BRFSS 2015 data
- Target variable: `Diabetes_012`
- Classes:
  - `0`: no diabetes or only during pregnancy
  - `1`: prediabetes
  - `2`: diabetes
- Includes 21 feature variables
- Has meaningful class imbalance

### Dataset 2: `diabetes_binary_health_indicators_BRFSS2015.csv`

- Contains 253,680 survey responses from the CDC BRFSS 2015 data
- Target variable: `Diabetes_binary`
- Classes:
  - `0`: no diabetes
  - `1`: prediabetes or diabetes
- Includes 21 feature variables
- Also has class imbalance

## Final Presentation Requirements

The final presentation should include:

1. Executive summary: key research questions, findings, and recommendations for future work
2. Project overview: team structure, methodology, timeline, and any changes to the plan
3. Data processing pipeline: EDA, preprocessing, transformation, unsupervised methods, and major issues discovered
4. Modeling process: model selection, evaluation metrics, results, and benchmark comparisons

## Team Process And Roles

### Shared Pipeline Responsibilities

All team members contribute to:

- exploratory data analysis
- data cleaning
- class-imbalance handling with SMOTE or class weights where appropriate
- PCA feature interpretation
- shared evaluation and model comparison

Common evaluation topics include:

- accuracy
- precision
- recall
- F1 score
- ROC-AUC
- confusion matrices
- bias and fairness checks

### Individual Roles

| Team Member | Dataset A: Binary (0/1) | Dataset B: Multiclass (0/1/2) | Other Responsibilities |
| :--- | :--- | :--- | :--- |
| Person 1 | Logistic Regression (baseline, L1/L2, odds ratios) | Multinomial Logistic Regression (OvR strategy, interpretable baseline) | Draft project plan in Week 1; executive summary in Week 4 |
| Person 2 | Decision Tree / Random Forest (feature importance, Gini/entropy) | Random Forest (balanced class weighting, macro F1) | Data pipeline walkthrough slides in Week 4 |
| Person 3 | Gradient Boosting (XGBoost, top performer, `scale_pos_weight`) | XGBoost / LightGBM (`softmax` objective, SHAP values) | Modeling and results slides in Week 4 |
| Person 4 | Support Vector Machine (SVM, RBF kernel, ROC-AUC evaluation) | SVM (OvR, compare linear vs. RBF kernels) | Rehearsal and final presentation polish in Week 4 |
| Person 5 | Naive Bayes and KNN (probabilistic vs. distance-based comparison) | Naive Bayes (natural 3-class fit, fast, interpretable) | Lead unsupervised methods, including K-means and PCA; rehearsal and final polish |

## Timeline And Deliverables

### Week 1: Apr 7 - Apr 13

Focus: research, EDA, and project setup

All members:

- research the datasets and BRFSS documentation
- set up the repository
- assign roles
- complete initial EDA, including distribution checks, class imbalance review, correlation heatmaps, and missing-value audits

Person 1:

- draft the project plan and timeline slide

Deliverables:

- Git and repository setup
- role assignment
- initial data cleaning
- literature review
- EDA notebook and summary

---

### Week 2: Apr 14 - Apr 20

Focus: preprocessing, transformation, and unsupervised learning

#### Goal

- finalize the shared train/test split
- define preprocessing standards and reusable pipeline tools
- perform PCA and K-means for insight discovery
- establish the logistic regression baseline

#### Shared Rules

- Katana provides one stratified 80/20 split for both binary and multiclass tasks
- All team members use the same train/test split
- The test set is not touched until final evaluation
- SMOTE is not applied globally; it is only used inside training pipelines and, when applicable, inside cross-validation folds
- Scaling is fit on training data only and applied to test data using the same transformation
- All preprocessing, SMOTE, and scaling steps must be fit only on training data and never on the test data

#### Katana: Data Split

- perform the stratified 80/20 split
- export train and test sets
- verify class imbalance in training data
- do not apply SMOTE

Deliverables:

- clean train/test datasets
- class imbalance report

#### Mohemmad: Preprocessing Standards And Pipeline Tools

- define preprocessing rules for the full project
- confirm all features are numeric
- identify which features should be scaled, especially `BMI`, `MentHlth`, and `PhysHlth`
- specify that binary features should not be scaled
- ensure all preprocessing uses training data only

- build reusable preprocessing tools
- fit a shared scaler on training data only
- create reusable preprocessing functions or scripts
- provide a standard workflow template for train, transform, model, and test-time transform

- enforce consistency across all models
- keep preprocessing aligned for PCA, KNN, SVM, and logistic regression
- prevent inconsistent transformations between team members

Deliverables:

- preprocessing rules document
- reusable preprocessing script
- fitted scaler object based on training data
- example usage template for the team

#### Matthew: PCA Analysis

- perform PCA on scaled training data only
- generate scree plots
- create 2D PCA visualizations for both binary and multiclass labels
- interpret feature loadings

Focus:

- identify which lifestyle variables drive the most variance
- evaluate whether classes separate naturally in reduced-dimensional space

Deliverables:

- PCA plots
- variance explanation summary
- feature loading insights

#### Matthiias: K-Means Clustering

- run the elbow method to choose an appropriate `k`
- fit K-means for `k = 2` and `k = 3`
- compute Adjusted Rand Index against the true labels
- profile clusters using BMI, physical activity, smoking status, and general health indicators

Deliverables:

- elbow plot
- cluster visualizations
- cluster interpretation summary

#### Zach: Logistic Regression Baseline

- train logistic regression on the training set only
- apply one imbalance method:
  - `class_weight = "balanced"` as the preferred baseline, or
  - SMOTE on training data only when used for comparison
- evaluate accuracy, precision, recall, F1, and ROC-AUC for the binary task
- interpret coefficients as odds ratios

Focus:

- establish a benchmark for later models
- identify the strongest lifestyle predictors of diabetes

Deliverables:

- baseline model performance report
- odds-ratio or coefficient visualization
- benchmark metrics for Week 3 comparison

#### End Of Week 2 Deliverables

- finalized train/test split
- preprocessing standards and reusable tools
- PCA and clustering insights
- logistic regression baseline

#### Key Principle For Week 2

- the data split is fixed once
- preprocessing is standardized rather than duplicated
- SMOTE belongs inside model pipelines, not the global dataset
- all models should remain comparable under the same train/test structure

---

### Week 3: Apr 21 - Apr 27

Focus: modeling and evaluation

#### Goal

- train, tune, and evaluate the remaining models on both datasets
- handle class imbalance correctly in every model pipeline
- produce final metrics, confusion matrices, and key visuals
- identify blockers by Apr 24 to avoid delaying Week 4

#### Shared Pipeline Rules

- use only `train_binary` and `train_012` during training
- keep the test sets untouched until final evaluation
- for CV-based models such as logistic regression, SVM, KNN, and Naive Bayes, apply SMOTE only inside training folds
- for non-CV models such as Random Forest and XGBoost, prefer class weighting and use SMOTE only as an optional comparison
- fit scaling only on training data and reuse the same fitted transformation for the test set
- retrain the final model on the full training set after tuning
- evaluate once on the held-out test set
- no model should ignore class imbalance

#### Matthias: Logistic Regression Review, Analysis, And Week 4 Prep

Modeling is likely complete, so the focus shifts to review, interpretation, and preparing the team for final comparison work.

- verify that binary and multiclass final models were retrained on the full training set
- confirm that each test set was evaluated exactly once
- compare CV estimates to test results to check for overfitting
- ensure all plots render clearly

Cross-model benchmark table:

- build the shared comparison table for all team members
- include columns such as model, dataset, imbalance method, CV F1, test F1, test ROC-AUC, test recall, and test precision
- prefill the logistic regression baseline rows

Interpretation tasks:

- document the weak prediabetes performance and explain why it may be a feature limitation rather than only a modeling limitation
- discuss the alcohol-consumption result and possible explanations such as reporting bias or proxy effects
- interpret `CholCheck` carefully as a likely healthcare-engagement proxy rather than a direct causal factor
- explain the binary and multiclass differences between SMOTE and class weighting

Executive summary preparation:

- draft the key findings section for Week 4
- frame what the logistic baseline suggests about the lifestyle-diabetes relationship
- note what the prediabetes results imply for future data collection and feature design

Deliverables:

- shared benchmark table
- interpretation writeup
- executive summary draft

#### Matthew: Random Forest

- train binary and multiclass Random Forest models
- use balanced class weighting
- tune tree settings through training-based tuning
- generate feature importance plots
- report accuracy, precision, recall, macro F1, ROC-AUC, and confusion matrices as appropriate

Deliverables:

- trained Random Forest models
- feature importance plots
- comparison table entries against the logistic regression baseline

#### Zach: XGBoost / LightGBM

- train binary and multiclass gradient-boosting models
- use `scale_pos_weight` for binary classification and class weighting for multiclass classification where appropriate
- tune key hyperparameters
- compute SHAP values for major predictors
- report the main evaluation metrics and confusion matrices

Deliverables:

- trained XGBoost or LightGBM models
- SHAP summary plots
- binary vs. multiclass SHAP comparison
- comparison table entries against the baseline

#### Mohemmad: SVM

- tune SVM with cross-validation
- apply SMOTE only inside folds
- use the shared fitted scaler from Week 2
- scale `BMI`, `MentHlth`, and `PhysHlth` while leaving binary and ordinal features unchanged
- evaluate both RBF and linear kernels where relevant

Deliverables:

- trained SVM models
- ROC-AUC curves
- linear vs. RBF comparison
- comparison table entries against the baseline

#### Katana: Naive Bayes And KNN

- use cross-validation for model tuning
- apply SMOTE only inside folds
- use the shared scaler where needed for KNN
- compare Naive Bayes and KNN across binary and multiclass settings
- run K-sensitivity checks for KNN

Deliverables:

- trained Naive Bayes and KNN models
- K-sensitivity plot
- Naive Bayes vs. KNN comparison summary
- comparison table entries against the baseline

Contingency:

- if KNN becomes too time-consuming, prioritize Naive Bayes as the core probabilistic baseline

#### All Members: Bias And Fairness Checks

Each team member should:

- evaluate model behavior across available demographic subgroups
- note any meaningful disparities in precision or recall
- document whether imbalance handling changes subgroup behavior
- contribute to the shared bias summary

#### End Of Week 3 Deliverables

Already completed by Person 1:

- binary logistic regression comparisons and final evaluation
- multiclass logistic regression comparisons and final evaluation
- odds-ratio plots, confusion-matrix heatmaps, per-class metrics, and ROC curves

Due by the end of the week:

- remaining models trained and evaluated on both datasets
- confusion matrices for every model
- ROC-AUC curves for binary models
- SHAP values or feature-importance plots for tree-based models
- KNN sensitivity analysis
- bias and fairness summary
- completed shared benchmark table
- executive summary draft
- all code committed to the shared repository

---

### Week 4: Apr 28 - May 4

Focus: results, write-up, and presentation

All members:

- compare models
- finalize results
- summarize benchmark improvements relative to the baseline

Specific responsibilities:

- Person 1: executive summary, key findings, recommendations, and future work
- Person 2: data-pipeline walkthrough slides
- Person 3: modeling and results slides
- Persons 4 and 5: rehearsal and final presentation polish

Deliverables:

- final presentation
- final code repository

## Execution Notes

- hold a short team sync at the end of each week to catch blockers early
- Week 3 is the heaviest workload, so issues should be flagged by Apr 24
- the preprocessing pipeline should be locked by the end of Week 2
- all members should use the same train/test split and the same preprocessing rules
- if someone falls behind in Week 3, KNN can be reduced in scope before higher-priority models are cut
- the presentation should clearly connect the baseline models, the stronger tree-based models, and the broader lifestyle-diabetes research question
