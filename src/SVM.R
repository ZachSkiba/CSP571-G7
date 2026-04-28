library(e1071)
library(pROC)
library(caret)

source("src/data_preprocessing.R")

#Get the target columns and replace
target_col <- "Diabetes_binary"

processed <- prepare_data(train_data, test_data)

train_processed <- processed$train
test_processed  <- processed$test


x_train <- train_processed[, !names(train_processed) %in% target_col,drop=FALSE]
y_train <- as.factor(train_processed[[target_col]])

x_test <- test_processed[, !names(test_processed) %in% target_col,drop=FALSE]
y_test <- as.factor(test_processed[[target_col]])


svm_model <- svm(
  x = x_train,
  y = y_train,
  kernel = "radial",
  probability = TRUE,
  scale = FALSE
)

svm_pred <- predict(svm_model, x_test, probability = TRUE)

# Extract probabilities
svm_prob <- attr(svm_pred, "probabilities")

classes <- levels(y_test)

auc_list <- list()

for (cls in classes) {
  
  # True labels: 1 vs 0
  y_true <- ifelse(y_test == cls, 1, 0)
  
  # Predicted probability for this class
  y_prob <- svm_prob[, cls]
  
  # ROC
  roc_obj <- roc(y_true, y_prob)
  
  # Store AUC
  auc_list[[cls]] <- auc(roc_obj)
  
  # Plot
  plot(roc_obj, main = paste("ROC - Class:", cls))
}

print(auc_list)

macro_auc <- mean(unlist(auc_list))
macro_auc
