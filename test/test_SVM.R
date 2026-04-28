library(testthat)
library(e1071)
library(pROC)
library(caret)

source("./../src/data_preprocessing.R")

# File paths
binary_train_file <- "data/processed/binary_train.csv"
binary_test_file  <- "data/processed/binary_test.csv"

multi_train_file <- "data/processed/multiclass_train.csv"
multi_test_file  <- "data/processed/multiclass_test.csv"
setwd("C:/Asif/Master_IITChicago/CSP571(DPA)/Project/new/CSP571-G7")


# Helper function: load data
load_dataset <- function(train_file, test_file) {
  expect_true(file.exists(train_file))
  expect_true(file.exists(test_file))
  
  train_data <- read.csv(train_file, stringsAsFactors = FALSE)
  test_data  <- read.csv(test_file, stringsAsFactors = FALSE)
  
  return(list(train = train_data, test = test_data))
}


# Helper function: prepare SVM data
prepare_svm_data <- function(train_data, test_data, target_col) {
  
  processed <- prepare_data(train_data, test_data, target_col)
  
  train_processed <- processed$train
  test_processed  <- processed$test
  
  x_train <- train_processed[, !(names(train_processed) %in% target_col), drop = FALSE]
  y_train <- as.factor(train_processed[[target_col]])
  
  x_test <- test_processed[, !(names(test_processed) %in% target_col), drop = FALSE]
  y_test <- as.factor(test_processed[[target_col]])
  
  return(list(
    x_train = x_train,
    y_train = y_train,
    x_test = x_test,
    y_test = y_test,
    scaler = processed$scaler,
    feature_types = processed$feature_types
  ))
}


# Helper function: train SVM RBF
train_svm_rbf <- function(x_train, y_train) {
  svm(
    x = x_train,
    y = y_train,
    kernel = "radial",
    probability = TRUE
  )
}

# Helper function: multiclass OvR AUC
calculate_ovr_auc <- function(y_test, prob_matrix) {
  classes <- levels(y_test)
  auc_values <- c()
  
  for (cls in classes) {
    y_binary <- ifelse(y_test == cls, 1, 0)
    
    roc_obj <- roc(
      response = y_binary,
      predictor = prob_matrix[, cls],
      quiet = TRUE
    )
    
    auc_values[cls] <- as.numeric(auc(roc_obj))
  }
  
  return(auc_values)
}


test_that("Continuous features are identified correctly", {
  cat("\nTestCase: Continuous feature identification\n")
  
  data <- load_dataset(binary_train_file, binary_test_file)
  
  feature_types <- identify_feature_types(data$train)
  
  expect_true(length(feature_types$continuous) > 0)
  
  cat("Continuous Features:", paste(feature_types$continuous, collapse = ", "), "\n")
})

test_that("Scaler is created for continuous features", {
  cat("\nTestCase: Scaler is created for continuous features\n")
  data <- load_dataset(binary_train_file, binary_test_file)
  
  feature_types <- identify_feature_types(
    data$train[, !names(data$train) %in% "Diabetes_binary"]
  )
  
  scaler <- fit_scaler(data$train, feature_types$continuous)
  
  expect_s3_class(scaler, "preProcess")
})


test_that("Only continuous columns are transformed", {
  cat("\nTestCase: Only continuous columns are transformed\n")
  data <- load_dataset(binary_train_file, binary_test_file)
  
  feature_types <- identify_feature_types(
    data$train[, !names(data$train) %in% "Diabetes_binary"]
  )
  
  scaler <- fit_scaler(data$train, feature_types$continuous)
  
  transformed <- transform_data(data$train, scaler, feature_types$continuous)
  
  for (col in feature_types$continuous) {
    expect_false(identical(transformed[[col]], data$train[[col]]))
  }
  
  for (col in feature_types$binary) {
    expect_equal(transformed[[col]], data$train[[col]])
  }
})


test_that("Continuous columns have mean approx 0", {
  cat("\nTestCase: Continuous columns have mean approx 0\n")
  
  data <- load_dataset(binary_train_file, binary_test_file)
  
  svm_data <- prepare_svm_data(
    train_data = data$train,
    test_data = data$test,
    target_col = "Diabetes_binary"
  )
  
  for (col in svm_data$feature_types$continuous) {
    
    cat("\nChecking column:", col, "\n")
    cat("Column class:", class(svm_data$x_train[[col]]), "\n")
    
    col_values <- as.numeric(svm_data$x_train[[col]])
    
    expect_equal(
      mean(col_values, na.rm = TRUE),
      0,
      tolerance = 1e-6
    )
  }
})

test_that("Continuous columns have sd approx 1", {
  cat("\nTestCase: Continuous columns have sd approx 1\n")
  
  data <- load_dataset(binary_train_file, binary_test_file)
  
  svm_data <- prepare_svm_data(
    train_data = data$train,
    test_data = data$test,
    target_col = "Diabetes_binary"
  )
  
  for (col in svm_data$feature_types$continuous) {
    
    col_values <- as.numeric(svm_data$x_train[[col]])
    
    expect_equal(
      sd(col_values, na.rm = TRUE),
      1,
      tolerance = 1e-6
    )
  }
})

test_that("Scaling uses only training data statistics", {
  cat("\nTestCase: Scaling uses only training data statistics\n")
  
  data <- load_dataset(binary_train_file, binary_test_file)
  
  processed <- prepare_data(
    train_data = data$train,
    test_data = data$test,
    target_col = "Diabetes_binary"
  )
  
  col <- processed$feature_types$continuous[1]
  
  train_values <- as.numeric(processed$train[[col]])
  test_values  <- as.numeric(processed$test[[col]])
  
  train_mean <- mean(train_values, na.rm = TRUE)
  test_mean  <- mean(test_values, na.rm = TRUE)
  
  cat("Column checked:", col, "\n")
  cat("Train mean:", train_mean, "\n")
  cat("Test mean :", test_mean, "\n")
  
  # Train mean should be near 0 because scaler was fit on training data
  expect_equal(train_mean, 0, tolerance = 1e-6)
  
  # Test mean does NOT need to be 0 because scaler was NOT fit on test data
  expect_false(is.na(test_mean))
})