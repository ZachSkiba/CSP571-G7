# =========================================================
# File: kmeans_analysis.R
# Task: K-Means clustering + interpretation
# Includes:
#   - Elbow method
#   - k = 2 and k = 3
#   - Adjusted Rand Index
#   - Cluster mean profiles
#   - Lifestyle interpretation
# =========================================================

library(caret)
library(cluster)
library(factoextra)
library(mclust)
library(dplyr)
library(ggplot2)

# -----------------------------
# Load preprocessing functions
# -----------------------------
source("src/data_preprocessing.R")

# -----------------------------
# Create output folder
# -----------------------------
cat("Current working directory:", getwd(), "\n")
if (!dir.exists("reports")) {
  dir.create("reports", recursive = TRUE)
  cat("reports folder created\n")
  }else {
    cat("reports folder already exists\n")
    }

if (!dir.exists("reports")) {
  dir.create("reports")
  }

# -----------------------------
# Load dataset
# -----------------------------
data <- read.csv("data/processed/binary_train.csv", stringsAsFactors = FALSE)

target_col <- "Diabetes_binary"

# -----------------------------
# Use only continuous / ordinal features
# -----------------------------
kmeans_features <- c(
  "BMI",
  "MentHlth",
  "PhysHlth",
  "GenHlth"
)

kmeans_features <- intersect(kmeans_features, names(data))

cat("\nFeatures used for K-Means:\n")
print(kmeans_features)

# -----------------------------
# Apply preprocessing
# scaler is fit on train data only
# -----------------------------
processed <- prepare_data(
  train_data = data,
  test_data = data,
  target_col = target_col
)

processed_data <- processed$train

# -----------------------------
# Select only K-Means features
# -----------------------------
features <- processed_data[, kmeans_features, drop = FALSE]

# Ensure numeric
features[] <- lapply(features, as.numeric)

# -----------------------------
# Elbow Method
# -----------------------------
set.seed(123)

elbow_plot <- fviz_nbclust(
  features,
  kmeans,
  method = "wss",
  k.max = 10
) +
  ggtitle("Elbow Method for K-Means Clustering") +
  xlab("Number of Clusters (k)") +
  ylab("Within-Cluster Sum of Squares")

print(elbow_plot)

ggsave(
  filename = "reports/elbow_plot.png",
  plot = elbow_plot,
  width = 8,
  height = 6
)

# -----------------------------
# K-Means with k = 2
# -----------------------------
set.seed(123)

k2_model <- kmeans(
  features,
  centers = 2,
  nstart = 25
)

# -----------------------------
# K-Means with k = 3
# -----------------------------
set.seed(123)

k3_model <- kmeans(
  features,
  centers = 3,
  nstart = 25
)

# -----------------------------
# Adjusted Rand Index
# -----------------------------
true_labels <- data[[target_col]]

ari_k2 <- adjustedRandIndex(true_labels, k2_model$cluster)
ari_k3 <- adjustedRandIndex(true_labels, k3_model$cluster)

cat("\n================ Adjusted Rand Index ================\n")
cat("ARI for k = 2:", round(ari_k2, 4), "\n")
cat("ARI for k = 3:", round(ari_k3, 4), "\n")
cat("=====================================================\n")

# -----------------------------
# Cluster Mean Profiles
# -----------------------------
data_k2 <- data %>%
  mutate(cluster = k2_model$cluster)

data_k3 <- data %>%
  mutate(cluster = k3_model$cluster)

cluster_profile_k2 <- data_k2 %>%
  group_by(cluster) %>%
  summarise(
    Count = n(),
    Diabetes_Rate = mean(.data[[target_col]], na.rm = TRUE),
    across(all_of(kmeans_features), mean, na.rm = TRUE),
    .groups = "drop"
  )

cluster_profile_k3 <- data_k3 %>%
  group_by(cluster) %>%
  summarise(
    Count = n(),
    Diabetes_Rate = mean(.data[[target_col]], na.rm = TRUE),
    across(all_of(kmeans_features), mean, na.rm = TRUE),
    .groups = "drop"
  )

cat("\n================ Cluster Profile: k = 2 ================\n")
print(cluster_profile_k2)

cat("\n================ Cluster Profile: k = 3 ================\n")
print(cluster_profile_k3)

# Save profiles
write.csv(
  cluster_profile_k2,
  "reports/kmeans_cluster_profile_k2.csv",
  row.names = FALSE
)

write.csv(
  cluster_profile_k3,
  "reports/kmeans_cluster_profile_k3.csv",
  row.names = FALSE
)

# -----------------------------
# PCA plot for visualization
# -----------------------------
pca_result <- prcomp(features, center = FALSE, scale. = FALSE)

pca_df_k2 <- data.frame(
  PC1 = pca_result$x[, 1],
  PC2 = pca_result$x[, 2],
  Cluster = as.factor(k2_model$cluster),
  Diabetes = as.factor(true_labels)
)

pca_df_k3 <- data.frame(
  PC1 = pca_result$x[, 1],
  PC2 = pca_result$x[, 2],
  Cluster = as.factor(k3_model$cluster),
  Diabetes = as.factor(true_labels)
)

plot_k2 <- ggplot(pca_df_k2, aes(x = PC1, y = PC2, color = Cluster)) +
  geom_point(alpha = 0.6) +
  ggtitle("K-Means Clustering Visualization: k = 2") +
  theme_minimal()

plot_k3 <- ggplot(pca_df_k3, aes(x = PC1, y = PC2, color = Cluster)) +
  geom_point(alpha = 0.6) +
  ggtitle("K-Means Clustering Visualization: k = 3") +
  theme_minimal()

print(plot_k2)
print(plot_k3)

ggsave(
  filename = "reports/kmeans_k2_pca_plot.png",
  plot = plot_k2,
  width = 8,
  height = 6
)

ggsave(
  filename = "reports/kmeans_k3_pca_plot.png",
  plot = plot_k3,
  width = 8,
  height = 6
)

# -----------------------------
# Lifestyle interpretation helper
# -----------------------------
interpret_clusters <- function(profile_table, k_value) {
  
  cat("\n================ Lifestyle Interpretation: k =", k_value, "================\n")
  
  for (i in seq_len(nrow(profile_table))) {
    
    row <- profile_table[i, ]
    
    cat("\nCluster", row$cluster, "\n")
    cat("Count:", row$Count, "\n")
    cat("Diabetes Rate:", round(row$Diabetes_Rate, 4), "\n")
    cat("Average BMI:", round(row$BMI, 2), "\n")
    cat("Average Mental Health Days:", round(row$MentHlth, 2), "\n")
    cat("Average Physical Health Days:", round(row$PhysHlth, 2), "\n")
    cat("Average General Health Score:", round(row$GenHlth, 2), "\n")
    
    if (row$BMI < mean(profile_table$BMI)) {
      bmi_desc <- "lower BMI"
    } else {
      bmi_desc <- "higher BMI"
    }
    
    if (row$PhysHlth < mean(profile_table$PhysHlth)) {
      health_desc <- "better physical health"
    } else {
      health_desc <- "poorer physical health"
    }
    
    if (row$GenHlth < mean(profile_table$GenHlth)) {
      general_desc <- "better general health"
    } else {
      general_desc <- "poorer general health"
    }
    
    cat("Interpretation: This cluster represents individuals with",
        bmi_desc, ",", health_desc, ", and", general_desc, ".\n")
  }
}

interpret_clusters(cluster_profile_k2, 2)
interpret_clusters(cluster_profile_k3, 3)

# -----------------------------
# Final summary
# -----------------------------
cat("\n================ Final K-Means Summary ================\n")
cat("Elbow plot saved at: reports/elbow_plot.png\n")
cat("k=2 PCA plot saved at: reports/kmeans_k2_pca_plot.png\n")
cat("k=3 PCA plot saved at: reports/kmeans_k3_pca_plot.png\n")
cat("Cluster profile k=2 saved at: reports/kmeans_cluster_profile_k2.csv\n")
cat("Cluster profile k=3 saved at: reports/kmeans_cluster_profile_k3.csv\n")
cat("ARI k=2:", round(ari_k2, 4), "\n")
cat("ARI k=3:", round(ari_k3, 4), "\n")
cat("=======================================================\n")