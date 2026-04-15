## FINAL MODEL TRAINING RULES (IMPORTANT)

### ⚠️ Core Rule (VERY IMPORTANT)
All models must handle class imbalance using at least one appropriate method:
- SMOTE (only where appropriate and inside training pipelines)
- OR class weights (preferred for tree-based models like Random Forest and XGBoost)

No model is allowed to ignore class imbalance.

Optionally, a subset of models may compare SMOTE vs class_weight as an experiment for analysis.

---

### 1. Data Split (Katana only)
Katana will create ONE stratified 80/20 split:

- train_binary / train_012 → used for all training and model building  
- test_binary / test_012 → used ONLY for final evaluation (never touched during training)

---

### 2. Model Training Strategy (TWO TYPES OF MODELS)

We use two consistent training approaches depending on the model:

---

### 🟢 A) Models using Cross-Validation (e.g., Logistic Regression, SVM, KNN, Naive Bayes)
- Use ONLY the training set
- Perform k-fold cross-validation for hyperparameter tuning
- SMOTE is applied ONLY inside each training fold (never before CV)
- No separate validation set is used

Cross-validation replaces validation by repeatedly evaluating performance across subsets of the training data.

---

### 🟡 B) Models NOT using Cross-Validation (e.g., Random Forest, XGBoost)
- Use ONLY the training set
- Handle class imbalance using:
  - Class weights (preferred for tree-based models like Random Forest and XGBoost)
  - SMOTE (for models when class weighting is not suitable)
- Train the model directly (no CV)

---

### 3. Hyperparameter Tuning
- CV models → tuned using cross-validation
- Non-CV models → tuned using simple training-based tuning or default parameters

---

### 4. Final Model Training (IMPORTANT STEP)
After selecting best model settings:

- Retrain final model on the FULL training set (no folds)
- This ensures the model learns from all available training data

---

### 5. Final Evaluation (CRITICAL RULE)
- Final evaluation is done ONLY ONCE on:
  - test_binary.csv
  - test_012.csv
- This test set is never used during training or tuning

---

### Why we do it this way
We use cross-validation for models that require hyperparameter tuning to get stable estimates, and we use appropriate imbalance-handling methods (SMOTE or class weights) depending on the model type, while always keeping the test set untouched to ensure fair evaluation.