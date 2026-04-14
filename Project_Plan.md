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

### Week 2: Apr 14 – Apr 20 (Preprocessing, Transformation & Unsupervised)

## 🎯 Goal
- Finalize shared dataset
- Build preprocessing pipeline
- Generate unsupervised insights (PCA + K-Means)
- Establish baseline model (logistic regression)



## ⚠️ Shared Rules (Everyone)
- Use SAME train/test split (no exceptions)
- 80/20 split, stratified, random_state=42
- SMOTE ONLY on training data
- Scaling: fit on train, apply to test
- Use both datasets (binary + multiclass)



## 👤 Katana — Data Split + SMOTE
- Perform stratified 80/20 split (both datasets)
- Apply SMOTE to training set only
- Keep test set untouched
- Export:
  - X_train, X_test, y_train, y_test
- Verify class balance before vs after SMOTE

**Deliverables:**
- Shared dataset files
- Class balance summary



## 👤 Matthiias — Scaling + Preprocessing Pipeline
- Confirm all features are numeric
- Apply StandardScaler to:
  - BMI, MentHlth, PhysHlth
- Do NOT scale binary features
- Build reusable preprocessing pipeline
- Output scaled X_train, X_test

**Deliverables:**
- Preprocessing notebook
- Final scaled dataset



## 👤 Matthew — PCA (Dimensionality Reduction)
- Run PCA on scaled data
- Create scree plot (explained variance)
- Plot PC1 vs PC2:
  - Colored by binary labels
  - Colored by multiclass labels
- Extract top feature loadings

**Focus:**
- Which lifestyle features drive variation?
- Do classes separate naturally?

**Deliverables:**
- Scree plot
- PCA scatter plots
- Loadings + short insights



## 👤 Mohemmad — K-Means Clustering
- Run elbow method (determine k)
- Fit K-Means with:
  - k = 2 and k = 3
- Compute Adjusted Rand Index (vs labels)
- Analyze cluster averages:
  - BMI, smoking, activity, health

**Focus:**
- Describe clusters in plain terms:
  - “Healthy group”
  - “High-risk group”

**Deliverables:**
- Elbow plot
- Cluster summaries
- Interpretation



## 👤 Zach — Logistic Regression Baseline
- Train models on both datasets:
  - Binary (class_weight='balanced')
  - Multinomial logistic regression
- Evaluate:
  - Accuracy, Precision, Recall, F1
  - ROC-AUC (binary)
  - Confusion matrix
- Convert coefficients → odds ratios

**Focus:**
- Identify strongest lifestyle predictors of diabetes

**Deliverables:**
- Model performance (binary vs multiclass)
- Coefficient/odds ratio plot
- Key insights



## ✅ Deliverables (End of Week)
- Clean preprocessing pipeline
- Shared dataset (used by all)
- PCA + clustering results
- Logistic regression baseline

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
