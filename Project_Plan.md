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



# Week 3: Apr 21 – Apr 27 (Modeling & Evaluation)

## 🎯 Goal
- Train, tune, and evaluate all remaining models on both datasets
- Handle class imbalance correctly in every model pipeline
- Produce final metrics, confusion matrices, and key visuals
- Flag any blockers by **Apr 24** to protect Week 4

---

## ⚠️ Shared Pipeline Rules (VERY IMPORTANT)

- Use **only** `train_binary` and `train_012` — the test sets are **never touched** until final evaluation; final evaluation happens **this week (Week 3)** after retraining on the full training set, not in Week 4
- **CV models** (Logistic Regression, SVM, KNN, Naive Bayes): use k-fold cross-validation for tuning; apply SMOTE **only inside each training fold**, never before CV
- **Non-CV models** (Random Forest, XGBoost): use `class_weight='balanced'` (preferred); SMOTE is allowed as an optional comparison experiment only
- Scaling must be fit on training data only; apply the same fitted scaler to test data at evaluation time
- After tuning, **retrain the final model on the full training set**, then evaluate **once** on the test set
- No model may ignore class imbalance

---

## 👤 Person 1 — Logistic Regression Review, Analysis & Week 4 Prep

> **Modeling is likely complete**, but do a final review pass before moving on. Verify: binary and multiclass both have a final model retrained on the full training set, the test set was evaluated exactly once per task, CV estimates and test results are close (no overfitting), and all plots (ROC curves, odds ratio, confusion matrix heatmap) render cleanly. If anything looks off, fix it now — this is the benchmark every other model will be compared against.

**This week's focus shifts to analysis, writing, and setting up Week 4.**

**Cross-model benchmark table (for the team):**
- Build the shared master comparison table that all other members will populate as they finish their models this week
- Columns: Model, Dataset, Imbalance Method, CV F1, Test F1, Test ROC-AUC, Test Recall, Test Precision
- Pre-fill with logistic regression rows as the baseline; leave rows for RF, XGBoost, SVM, NB, KNN
- Commit to repo so teammates can add their numbers directly

**Deeper interpretation of logistic regression findings:**
- Write up the prediabetes failure formally — why X1 F1 = 0.056 is a feature-set problem, not a modeling problem; what biomarkers are missing (HbA1c, fasting glucose) that would likely resolve it
- Expand the HvyAlcoholConsump paradox (OR = 0.48) — survivorship bias, healthy user effect, BRFSS underreporting; cite at least one source
- Interpret the CholCheck OR = 3.65 more carefully — likely a proxy for healthcare engagement / known comorbidities rather than a causal risk factor; flag this for the presentation
- **SMOTE vs class weights interpretation:** Two separate findings. Binary: both tied (F1 = 0.44, ROC-AUC = 0.82) — explain why (large dataset, stable boundary) and why class weights won on simplicity. Multiclass: SMOTE was selected because prediabetes at 1.82% is severe enough that class weights alone can't generate sufficient learning signal — SMOTE creates synthetic X1 samples, though X1 F1 still only reached 0.056. The failure is structural (missing biomarkers), not a resampling problem. Use as baseline: if SVM or KNN show a gap between methods, that reveals something about how those models use training data differently

**Executive summary draft (early start on Week 4):**
- Draft the key findings section: what the logistic regression baseline tells us about the lifestyle-diabetes relationship, what the prediabetes finding implies for future data collection, and what the feature ceiling suggests about where tree-based models might improve things
- This doesn't need to be final — just a working draft the team can react to before Week 4 starts

**Deliverables:**
- Shared master benchmark table (repo, pre-filled with LR rows)
- Written interpretation of prediabetes failure and alcohol paradox (1–2 paragraphs each, can live in the Rmd or a separate doc)
- Executive summary draft (key findings section only)

---

## 👤 Person 2 — Random Forest

> **Non-CV model — use class weights, no cross-validation. Scaling is NOT required for Random Forest — do not apply it.**

**Binary dataset:**
- Train with `class_weight='balanced'`
- Tune `max_depth` and `n_estimators` via simple training-based tuning
- Plot feature importance (Gini/entropy)
- Report accuracy, precision, recall, macro F1, ROC-AUC, confusion matrix

**Multiclass dataset (0/1/2):**
- Same setup with `class_weight='balanced'`
- Report macro F1 and per-class metrics
- Compare feature importance rankings across both datasets

**Deliverables:**
- Trained Random Forest models (binary + multiclass)
- Feature importance plots (both datasets)
- Metric comparison table vs logistic regression baseline

---

## 👤 Person 3 — XGBoost / LightGBM

> **Non-CV model — use `scale_pos_weight` (binary) or `class_weight` (multiclass)**

**Binary dataset:**
- XGBoost with `scale_pos_weight` set to handle imbalance
- Tune `max_depth`, `learning_rate`, `n_estimators`
- Compute SHAP values for top predictors
- Report accuracy, precision, recall, F1, ROC-AUC, confusion matrix

**Multiclass dataset (0/1/2):**
- XGBoost or LightGBM with `softmax` objective
- Handle imbalance via class weights
- Compute SHAP values; compare top features vs binary model
- Report macro F1 and per-class metrics

**Deliverables:**
- Trained XGBoost/LightGBM models (binary + multiclass)
- SHAP summary plots (both datasets)
- Binary vs multiclass SHAP feature comparison
- Metric comparison table vs baseline

---

## 👤 Person 4 — SVM

> **CV model — tune via k-fold cross-validation; apply SMOTE inside folds only. Scaling IS required for SVM.**

**Scaling (do this before modeling):**
- Use the fitted scaler object from Person 2's Week 2 preprocessing script
- Confirm it was fit on training data only and apply the same object to the test set — do not re-fit on test data
- Only `BMI`, `MentHlth`, and `PhysHlth` should be scaled — leave all binary/ordinal features unchanged

**Binary dataset:**
- RBF kernel; tune `C` and `gamma` via CV
- Try **both** SMOTE inside folds and `class_weight='balanced'`; select the better performing approach based on CV F1 and note the comparison
- Report accuracy, precision, recall, F1, ROC-AUC, confusion matrix

**Multiclass dataset (0/1/2):**
- OvR strategy with RBF kernel
- Try **both** SMOTE inside folds and `class_weight='balanced'`; select the better approach based on CV macro F1 and note the comparison
- Also run linear kernel and compare performance
- Report macro F1, per-class metrics, confusion matrix

**Deliverables:**
- Trained SVM models (binary + multiclass)
- ROC-AUC curves
- Linear vs RBF kernel comparison
- Metric comparison table vs baseline

---

## 👤 Person 5 — Naive Bayes + KNN

> **CV model — tune via k-fold cross-validation; apply SMOTE inside folds only. Scaling IS required for KNN — apply it. Naive Bayes does not require scaling but applying it does no harm.**

**Scaling (do this before modeling):**
- Use the fitted scaler object from Person 2's Week 2 preprocessing script
- Confirm it was fit on training data only and apply the same object to the test set — do not re-fit on test data
- Only `BMI`, `MentHlth`, and `PhysHlth` should be scaled — leave all binary/ordinal features unchanged

**Binary dataset:**
- Naive Bayes (GaussianNB or BernoulliNB; justify choice)
- KNN with sensitivity analysis across multiple K values (e.g. 3, 5, 7, 11, 15)
- For both models, try **both** SMOTE inside folds and `class_weight='balanced'` where applicable; select the better approach based on CV F1 and note the comparison
- Report accuracy, precision, recall, F1, ROC-AUC, confusion matrix for both

**Multiclass dataset (0/1/2):**
- Naive Bayes: natural 3-class fit; try both SMOTE and class weights where applicable; report macro F1 and per-class metrics
- KNN: same K sensitivity analysis; try both SMOTE and class weights; note how distance-based performance shifts with 3 classes
- Compare probabilistic (NB) vs distance-based (KNN) approaches

**Deliverables:**
- Trained NB and KNN models (binary + multiclass)
- KNN K-sensitivity plot
- NB vs KNN comparison summary
- Metric comparison table vs baseline

---

## 👥 All Members — Bias & Fairness Checks

Each person runs bias checks on their own model(s):
- Check performance across demographic subgroups (age, BMI range, sex if available)
- Flag any significant disparity in precision/recall across groups
- Note whether imbalance handling improved or shifted any bias
- Contribute findings to the shared bias summary document

---

## ✅ End of Week 3 Deliverables

**Already done (Person 1):**
- Binary logistic regression: class weights, SMOTE, Ridge comparison; final model selected and test-evaluated
- Multiclass logistic regression: OvR vs Multinomial Ridge comparison; final model selected and test-evaluated
- Odds ratio plots, confusion matrix heatmaps, per-class metrics, ROC curves

**Due end of week:**
- All remaining models trained and evaluated on both datasets (Persons 2–5)
- Confusion matrices for every model
- ROC-AUC curves (binary models)
- SHAP values / feature importance plots (XGBoost, Random Forest)
- KNN K-sensitivity plot
- Bias and fairness check summary
- Shared master benchmark table with all model rows filled in
- Executive summary key findings draft (Person 1)
- All code committed and pushed to shared repo

--- 

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
