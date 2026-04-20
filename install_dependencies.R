# =========================================================
# File: install_dependencies.R
# Purpose: Install all required libraries
# =========================================================

cat("=================================================\n")
cat("Starting dependency installation...\n")
cat("=================================================\n\n")


# Step 1: Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# -----------------------------
# Step 2: Required packages
# -----------------------------
required_packages <- c(
  "caret",
  "testthat",
  "dplyr",
  "ggplot2",
  "readr",
  "tidyr",
  "stringr"
)

# Step 3: Install function
install_if_missing <- function(pkg) {
  
  cat("\n---------------------------------------------\n")
  cat(sprintf("Checking package: %s\n", pkg))
  
  if (!requireNamespace(pkg, quietly = TRUE)) {
    
    cat(sprintf("Installing package: %s\n", pkg))
    
    tryCatch({
      
      install.packages(
        pkg,
        dependencies = TRUE,
        type = "binary" 
      )
      
      cat(sprintf("SUCCESS: %s installed\n", pkg))
      
    }, error = function(e) {
      
      cat(sprintf("ERROR installing %s\n", pkg))
      cat(sprintf("Reason: %s\n", e$message))
      
    })
    
  } else {
    cat(sprintf("Already installed: %s\n", pkg))
  }
}


for (pkg in required_packages) {
  install_if_missing(pkg)
}

cat("\n=================================================\n")
cat("Loading libraries in Progress......\n")
cat("=================================================\n")

for (pkg in required_packages) {
  
  tryCatch({
    
    suppressPackageStartupMessages(
      library(pkg, character.only = TRUE)
    )
    
    cat(sprintf("LOADED: %s\n", pkg))
    
  }, error = function(e) {
    
    cat(sprintf("FAILED to load: %s\n", pkg))
    
  })
}

cat("\n=================================================\n")
cat("Verify library installation\n")
cat("=================================================\n")

for (pkg in required_packages) {
  
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("[OK] %s\n", pkg))
  } else {
    cat(sprintf("[FAIL] %s\n", pkg))
  }
}

cat("\n=================================================\n")
cat("Dependency installated Successfully.\n")
cat("=================================================\n")

