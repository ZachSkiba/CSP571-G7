library(caret)


# Identify the feature type from the data setidentify_feature_types

identify_feature_types <- function(data) {
  
  numeric_cols <- names(data)[sapply(data, is.numeric)]
  
  binary_cols <- c()
  continuous_cols <- c()
  
  for (col in numeric_cols) {
    unique_vals <- unique(data[[col]])
    unique_vals <- unique_vals[!is.na(unique_vals)]
    
    if (length(unique_vals) == 2) {
      binary_cols <- c(binary_cols, col)
    } else {
      continuous_cols <- c(continuous_cols, col)
    }
  }
  
  
  return(list(
    binary = binary_cols,
    continuous = continuous_cols
  ))
}

# -----------------------------
# Fit scaler for Training data
# -----------------------------
fit_scaler <- function(train_data, continuous_cols) {
  
  scaler <- preProcess(
    train_data[, continuous_cols],
    method = c("center", "scale")
  )
  
  return(scaler)
}

# -----------------------------
# Transformation the data
# -----------------------------
transform_data <- function(data, scaler, continuous_cols) {
  
  data_scaled <- data
  
  data_scaled[, continuous_cols] <- predict(
    scaler,
    data[, continuous_cols]
  )
  
  return(data_scaled)
}

# -----------------------------
# Data pipeline 
# -----------------------------
  prepare_data <- function(train_data, test_data) {
  
  # Step 1: Identify feature types
  feature_types <- identify_feature_types(train_data)
  
  feature_types$binary
  feature_types$continuous
  print("Binary Features    : ",feature_types)
  print("Continuous Features: ",feature_types)
  
  continuous_cols <- feature_types$continuous
  
  # Step 2: Fit scaler ONLY on training
  scaler <- fit_scaler(train_data, continuous_cols)
  
  # Step 3: Transform both datasets
  train_processed <- transform_data(train_data, scaler, continuous_cols)
  test_processed  <- transform_data(test_data, scaler, continuous_cols)
  
  return(list(
    train = train_processed,
    test = test_processed,
    scaler = scaler,
    feature_types = feature_types
  ))
}