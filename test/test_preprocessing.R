library(testthat)
library(caret)

# Load your preprocessing functions
source("./../src/data_preprocessing.R")

# -------------------------------------------------
# Read data from CSV files
# -------------------------------------------------
train_file <- "./../data/processed/multiclass_train.csv"
test_file  <- "./../data/processed/multiclass_test.csv"

if (!file.exists(train_file)) {
  stop(paste("Train file not found:", train_file))
}

if (!file.exists(test_file)) {
  stop(paste("Test file not found:", test_file))
}

train_data <- read.csv(train_file, stringsAsFactors = FALSE)
test_data  <- read.csv(test_file, stringsAsFactors = FALSE)

cat("Data loaded successfully\n")
cat("Train rows:", nrow(train_data), "\n")
cat("Test rows :", nrow(test_data), "\n")

# Unit tests to Identify Feature Types

test_that("identify_feature_types returns valid structure", {
  result <- identify_feature_types(train_data)
  
  cat("\n ********** Identify the Feature Types from the Test Data **********\n")
  cat("Binary Features :")
  cat(paste(result$binary, collapse = ", "), "\n\n")
  
  cat("Continuous Features :")
  cat(paste(result$continuous, collapse = ", "), "\n")


})

test_that("Identify feature types: ", {
  
  cat("\n ********** Get Feature count from the Test Data **********\n")
  result <- identify_feature_types(train_data)
  
  total_features <- length(result$binary) + length(result$continuous)
  
  cat("Total Features Detected :", total_features, "\n")
  cat("Binary Features Count   :", length(result$binary), "\n")
  cat("Continuous Features Count:", length(result$continuous), "\n\n")
  
  expect_true(total_features> 0)
})

# Unit tests for fit_scaler
test_that("Fit Scaler Returns A Valid Scaler", {
  cat("\n ********* Fit Scalar and REturn a Valid Scalar ********* \n")
  feature_types <- identify_feature_types(train_data)
  scaler <- fit_scaler(train_data, feature_types$continuous)
  expect_s3_class(scaler, "preProcess")
  
  # Check not NULL
  expect_false(is.null(scaler))
  # Check continuous columns exist
  expect_true(length(feature_types$continuous) > 0)
})


# Unit tests for transform_data
test_that("transform_data modifies only continuous columns", {
  feature_types <- identify_feature_types(train_data)
  scaler <- fit_scaler(train_data, feature_types$continuous)
  
  transformed <- transform_data(train_data, scaler, feature_types$continuous)
  
  # Continuous columns should change
  for (col in feature_types$continuous) {
    expect_false(identical(transformed[[col]], train_data[[col]]))
  }
  
  # Binary columns should remain same
  for (col in feature_types$binary) {
    expect_equal(transformed[[col]], train_data[[col]])
  }
})


# Unit tests for prepare_data()

test_that("prepare_data returns valid structure", {
  result <- prepare_data(train_data, test_data)
  
  expect_true("train" %in% names(result))
  expect_true("test" %in% names(result))
  expect_true("scaler" %in% names(result))
  expect_true("feature_types" %in% names(result))
})

test_that("row counts are preserved", {
  result <- prepare_data(train_data, test_data)
  
  expect_equal(nrow(result$train), nrow(train_data))
  expect_equal(nrow(result$test), nrow(test_data))
})

test_that("continuous features are scaled (mean approx 0)", {
  result <- prepare_data(train_data, test_data)
  
  for (col in result$feature_types$continuous) {
    expect_equal(mean(result$train[[col]], na.rm = TRUE), 0, tolerance = 1e-6)
  }
})

test_that("continuous features are scaled (sd approx 1)", {
  result <- prepare_data(train_data, test_data)
  
  for (col in result$feature_types$continuous) {
    expect_equal(sd(result$train[[col]], na.rm = TRUE), 1, tolerance = 1e-6)
  }
})

