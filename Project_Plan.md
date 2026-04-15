# CSP 571 Project Layout

## Purpose of Datasets
The primary goal is to better understand the relationship between lifestyle and diabetes in the US.  
The project involves comparing two datasets: one with 3 classes (0, 1, 2) and another with 2 classes (0, 1).

### Dataset 1: `diabetes_012_health_indicators_BRFSS2015.csv`
- A clean dataset containing 253,680 survey responses to the CDC's BRFSS2015.
- Target variable `Diabetes_012` has 3 classes:
  - 0: No diabetes or only during pregnancy
  - 1: Prediabetes
  - 2: Diabetes
- Contains 21 feature variables.
- Suffers from class imbalance.

### Dataset 2: `diabetes_binary_health_indicators_BRFSS2015.csv`
- A clean dataset containing 253,680 survey responses to the CDC's BRFSS2015.
- Target variable `Diabetes_binary` has 2 classes:
  - 0: No diabetes
  - 1: Prediabetes or diabetes
- Contains 21 feature variables.
- Dataset is not balanced.

## Required Presentation
The final presentation must include the following sections:
1. **Executive summary**: Key research issues, findings, and recommendations for future work.
2. **Project overview**: Team, methodology, timeline, tasks, including any changes to the plan.
3. **Data processing pipeline**: Exploratory Data Analysis (EDA), pre-processing, transformation, unsupervised methods, and any discoveries/issues.
4. **Modeling process**: Features/metrics, model selection, results, key prediction visuals, benchmark/baseline improvements.

## Process & Team Roles

### Shared Pipeline (Whole Team)
- Responsible for EDA, data cleaning, SMOTE/class weights, and PCA feature importance.
- Shared evaluation and comparison duties: accuracy, precision, recall, F1, ROC-AUC, confusion matrices, and bias checks.

### Individual Roles
| Team Member | Dataset A: Binary (0/1) | Dataset B: Multiclass (0/1/2) | Other Responsibilities |
| :--- | :--- | :--- | :--- |
| Person 1 | Logistic Regression (Baseline, L1/L2, odds ratios) | Multinomial Logistic Regression (OvR strategy, interpretable baseline) | Draft project plan (Wk 1); Executive summary (Wk 4) |
| Person 2 | Decision Tree / Random Forest (Feature importance, Gini/entropy) | Random Forest (class_weight='balanced', macro F1) | Data pipeline walkthrough slides (Wk 4) |
| Person 3 | Gradient Boosting (XGBoost, top performer, scale_pos_weight) | XGBoost / LightGBM (softmax objective, SHAP values) | Modeling & results slides (Wk 4) |
| Person 4 | Support Vector Machine (SVM, RBF kernel, ROC-AUC evaluation) | SVM (OvR, compare linear vs RBF kernels) | Rehearsal & final polish (Wk 4) |
| Person 5 | Naive Bayes + KNN (Probabilistic vs distance-based contrast) | Naive Bayes (Natural 3-class fit, fast, interpretable) | Lead unsupervised methods (K-Means, PCA for EDA); Rehearsal & final polish (Wk 4) |

## Timeline Overview & Weekly Deliverables

### Week 1: Apr 7 - Apr 13 (Research, EDA & Data Pipeline)
**All Members:** Dataset research, project setup, reading BRFSS documentation, setting up repo, dividing roles, EDA (distribution plots, class imbalance checks, correlation heatmaps, missing value audits).  
**Person 1:** Draft project plan and timeline slide (methodology, task ownership, schedule).  
**Deliverables:** Git/repo setup, role assignment, data cleaning, literature review, EDA notebook + summary.

---

### Week 2: Apr 14 – Apr 20 (Preprocessing, Transformation & Unsupervised Learning)

## 🎯 Goal
- Finalize shared dataset split (train/test only)
- Define preprocessing standards and reusable pipeline tools
- Perform PCA + K-Means for insight discovery
- Establish logistic regression baseline

---

## ⚠️ Shared Rules (VERY IMPORTANT)
- Katana provides ONLY ONE stratified 80/20 split (binary + multiclass)
- All teams use the SAME train/test split
- The test set is NEVER touched until final evaluation
- SMOTE is NOT applied globally. It is only used inside training pipelines (and, when applicable, inside cross-validation folds). All imbalance handling must occur only on training data.
- Scaling is fit on training data only and applied to test data using the same transformation
- All preprocessing, SMOTE, and scaling must be fit ONLY on training data and never on test data.

---

## 👤 Katana — Data Split
- Perform stratified 80/20 split (binary + multiclass)
- Export:
  - train set
  - test set
- Verify class imbalance in training data
- Do NOT apply SMOTE

**Deliverables:**
- train/test datasets (clean, untouched)
- class imbalance report

---

## 👤 Mohemmad — Preprocessing Standards & Pipeline Tools

- Define preprocessing rules for the entire project:
  - Confirm all features are numeric  
  - Identify which features should be scaled (BMI, MentHlth, PhysHlth)  
  - Specify that binary features must NOT be scaled  
  - Ensure all preprocessing is done using training data only (no test leakage)

- Build reusable preprocessing tools:
  - StandardScaler fitted ONLY on training data  
  - Shared preprocessing functions / R script for the team  
  - Standard workflow template: train → transform → model → transform test

- Ensure consistency across all models:
  - PCA, KNN, SVM, Logistic Regression all follow the same scaling rules  
  - Prevent inconsistent preprocessing between team members  
  - Ensure all transformations are applied consistently across both binary and multiclass datasets  

**Deliverables:**
- Preprocessing rules document (1-page guide)
- Reusable preprocessing script (R code)
- Fitted scaler object (trained on training set only)
- Example usage template for other team members

---

## 👤 Matthew — PCA Analysis
- PCA must be performed on scaled training data only (no SMOTE applied before PCA)
- Scree plot (explained variance)
- 2D PCA visualization:
  - binary labels
  - multiclass labels
- Feature loadings interpretation

**Focus:**
- Identify which lifestyle variables drive variance
- Check whether classes separate naturally in reduced space

**Deliverables:**
- PCA plots
- variance explanation report
- feature loading insights

---

## 👤 Matthiias — K-Means Clustering
- Run elbow method to choose optimal k
- Fit K-Means with:
  - k = 2
  - k = 3
- Compute Adjusted Rand Index (vs true labels)
- Profile clusters using:
  - BMI
  - physical activity
  - smoking status
  - general health indicators

**Deliverables:**
- elbow plot
- cluster visualizations
- cluster interpretation summary

---

## 👤 Zach — Logistic Regression Baseline
- Train logistic regression on training set only
- Apply ONE imbalance method:
  - class_weight='balanced' (preferred baseline), OR
  - SMOTE applied only on training data (for comparison if needed)
- Evaluate:
  - Accuracy, Precision, Recall, F1
  - ROC-AUC (binary only)
- Interpret coefficients as odds ratios

**Focus:**
- Establish benchmark performance for all future models
- Identify strongest lifestyle predictors of diabetes

**Deliverables:**
- baseline model performance report
- odds ratio / coefficient plot
- benchmark metrics for Week 3 comparison

---

## ✅ End of Week 2 Deliverables
- Finalized train/test split
- Defined preprocessing standards + reusable tools
- PCA + clustering insights completed
- Logistic regression baseline established


## ⚠️ Key Principle for Week 2
- Data split is fixed once (Katana)
- Preprocessing is standardized, not duplicated
- SMOTE happens only inside model pipelines (Week 3+)
- All models must remain comparable using the same train/test structure

--- 

### Week 3: Apr 21 - Apr 27 (Modeling & Evaluation)
- **Person 2:** Random Forest on both datasets (tune depth/estimators, feature importance, macro F1).  
- **Person 3:** XGBoost / LightGBM on both datasets (handle imbalance, SHAP values, compare binary vs multiclass).  
- **Person 4:** SVM on both datasets (RBF kernel, OvR for multiclass, ROC-AUC curves).  
- **Person 5:** Naive Bayes + KNN on both datasets (probabilistic vs distance-based, sensitivity to K).  
- **All Members:** Bias and fairness checks.  
**Deliverables:** All models trained and evaluated, confusion matrices, metric comparison table.

### Week 4: Apr 28 - May 4 (Results, Writeup & Presentation)
- **All Members:** Model comparison, final results, benchmark vs baseline improvements.  
- **Person 1:** Executive summary (key findings, recommendations, future work).  
- **Person 2:** Data pipeline walkthrough slides.  
- **Person 3:** Modeling & results slides (model rationale, visuals, SHAP/feature importance).  
- **Persons 4 & 5:** Rehearsal and final polish.  
**Deliverables:** Final presentation and code repo due May 4.

## Important Tips & Execution Notes
- **Communication:** Hold 15-min sync at the end of each week to catch blockers.  
- **Pacing:** Week 3 is heaviest; flag issues by Apr 24 to avoid Week 4 scramble.  
- **Crucial Milestone:** End of Week 2 is critical; preprocessing pipeline must be locked by Apr 20.  
- **Consistency:** All members use same train/test split and scaled features before training.  
- **Contingency Plan:** If someone falls behind in Week 3, cut KNN model; Naive Bayes still covers probabilistic angle.  
- **Presentation Strategy:** Person 1 owns executive summary and baseline; Person 3 leads modeling results (XGBoost & SHAP provide strongest visuals for lifestyle-diabetes research).
