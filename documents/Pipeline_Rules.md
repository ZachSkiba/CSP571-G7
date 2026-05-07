## Final Model Training Rules

This document defines the shared training and evaluation rules for the project so that all models are developed under a consistent and fair workflow.

### Core Rule

All models must address class imbalance using at least one appropriate method:

- SMOTE, when appropriate and only inside training pipelines
- class weights, especially for tree-based models such as Random Forest and XGBoost

No model should ignore class imbalance.

Optional comparison experiments between SMOTE and class weighting are allowed when they help explain model behavior.

---

### 1. Data Split

Katana creates one stratified 80/20 split:

- `train_binary` and `train_012` are used for training and model development
- `test_binary` and `test_012` are reserved for final evaluation only

The test sets should never be used during training or tuning.

---

### 2. Model Training Strategy

We use two training approaches depending on the model family.

#### A. Models Using Cross-Validation

Examples:

- logistic regression
- SVM
- KNN
- Naive Bayes

Rules:

- use only the training set
- use k-fold cross-validation for hyperparameter tuning
- apply SMOTE only inside each training fold
- do not apply SMOTE before cross-validation
- do not create a separate validation set unless there is a specific reason

Cross-validation serves as the validation strategy by estimating performance across repeated training subsets.

#### B. Models Not Using Cross-Validation

Examples:

- Random Forest
- XGBoost

Rules:

- use only the training set
- handle class imbalance with class weights where possible
- use SMOTE only if class weighting is not suitable or if it is part of a documented comparison
- train directly without cross-validation

---

### 3. Hyperparameter Tuning

- CV-based models should be tuned through cross-validation
- non-CV models can be tuned through simpler training-based comparisons or carefully chosen defaults

---

### 4. Final Model Training

After selecting the best settings:

- retrain the final model on the full training set
- do not use folds at the final training stage

This allows the final model to learn from all available training data before evaluation.

---

### 5. Final Evaluation

Final evaluation is performed once on the held-out test sets:

- `test_binary.csv`
- `test_012.csv`

The test sets should remain untouched until this step.

---

### Why This Workflow Matters

This workflow keeps model comparisons fair by:

- preventing test leakage
- keeping imbalance handling consistent
- matching the training strategy to the model type
- ensuring that final performance is measured on truly unseen data
