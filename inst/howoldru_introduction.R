## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  message = FALSE,
  warning = FALSE
)

## -----------------------------------------------------------------------------
# Ensure necessary packages for the vignette are loaded
library(howoldru)
library(GEOquery)
library(Biobase) # Needed for ExpressionSet objects
library(dplyr)   # Needed for data manipulation
library(ggplot2) # Needed for plotting

## -----------------------------------------------------------------------------
# This chunk downloads the data. Set eval=TRUE to run it.
gse_list <- GEOquery::getGEO("GSE110554", GSEMatrix = TRUE, getGPL = FALSE)
# also GSE110554 is an option
gse <- gse_list[[1]]
print(gse)

## -----------------------------------------------------------------------------
# Extract beta values (CpGs rows, Samples columns)
beta_matrix <- Biobase::exprs(gse)

# Extract phenotype data
pheno_data <- Biobase::pData(gse)

reported_ages_df <- pheno_data %>%
  dplyr::transmute( # transmute keeps only the new column and grouping vars if any
    SampleID = geo_accession, # Use geo_accession as sample ID
    ReportedAge = suppressWarnings(as.numeric(sub("age: ", "", characteristics_ch1.15)))
  ) %>%
  dplyr::filter(!is.na(ReportedAge)) # Keep only samples with valid numeric age
head(reported_ages_df)

# Ensure beta matrix only contains samples with valid age for comparison
beta_matrix <- beta_matrix[, reported_ages_df$SampleID]

# check if it works. 
head(reported_ages_df)

## -----------------------------------------------------------------------------
# Run the clock function
predicted_ages <- howoldru(beta_matrix)

# Show the first few results
head(predicted_ages)

## -----------------------------------------------------------------------------
# Combine results into a data frame for plotting
results_df <- data.frame(
  SampleID = names(predicted_ages),
  PredictedAge = predicted_ages
)
results_df <- dplyr::inner_join(reported_ages_df, results_df, by = "SampleID")

# Display first few results

# Calculate Pearson correlation
correlation <- cor(results_df$ReportedAge, results_df$PredictedAge)

# Calculate Mean Absolute Error (MAE)
mae <- mean(abs(results_df$ReportedAge - results_df$PredictedAge))


ggplot(results_df, aes(x = ReportedAge, y = PredictedAge)) +
  geom_point(alpha = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  # Set axis limits from 0 to 100
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 100)) +
  labs(
    title = "howoldru Predicted vs. Reported Age",
    # Include Correlation and MAE in the subtitle
    subtitle = paste("GSE112618 | Pearson Cor =", round(correlation, 3), "| MAE =", round(mae, 2)),
    x = "Reported Chronological Age",
    y = "Predicted Age (howoldru)"
  ) +
  theme_minimal() # Use a minimal theme

