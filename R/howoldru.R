#' @title Estimate Age using the 'howoldru' Clock
#'
#' @aliases howoldru
#'
#' @description
#' This function takes an Illumina 450k/EPIC DNAm beta matrix and returns
#' the estimated age based on the 'howoldru' epigenetic clock.
#'
#' @param data.m DNAm beta value matrix (or data.frame that can be coerced to matrix)
#'   with rows labeling Illumina 450k/EPIC CpGs (rownames) and columns
#'   labeling samples (colnames). Beta values should be in the range [0, 1].
#' @param ... Other arguments (currently ignored).
#'
#' @details
#' The 'howoldru' clock is based on the coefficients and probes stored in the
#' package's internal `howoldru_data` object. [Add more specific details about your clock here].
#' The function requires the coefficient data `howoldru_data` stored within the package.
#' It calculates the score as: Intercept + sum(beta_value * coefficient) for overlapping CpGs.
#' The `howoldru_data` object is automatically available when the package is loaded.
#'
#' @return A numeric vector of 'howoldru' age estimates, one for each sample (column) in `data.m`.
#' The vector will have names corresponding to the sample names (colnames of `data.m`).
#'
#' @references
#' [Add your reference here if you have one, e.g., a paper or preprint]
#'
#' @examples
#' # --- Accessing package data for the example ---
#' # Load the required data object into the environment first
#' data(howoldru_data)
#' # Now 'howoldru_data' is available in this example's environment
#'
#' # Generate example data using the actual probe list from the package
#' required_probes <- howoldru_data$probe_list
#' n_probes_total <- length(required_probes)
#'
#' # Create a small fake data matrix (2 samples)
#' # Use only the first 50 probes from the clock + 20 extra dummy probes
#' example_probes <- c(required_probes[1:min(50, n_probes_total)],
#'                     paste0("cg_dummy", 1:20))
#' betas <- matrix(runif(length(example_probes) * 2),
#'                 nrow = length(example_probes),
#'                 ncol = 2,
#'                 dimnames = list(example_probes, c("Sample1", "Sample2")))
#'
#' # --- Running the actual function ---
#' # The howoldru() function itself accesses howoldru_data internally
#' age_estimates <- howoldru(betas)
#' print(age_estimates)
#'
#' @export
howoldru <- function(data.m, ...) {

  # Access the package data directly.
  # 'howoldru_data' is made available via lazy-loading when the package
  # is loaded (library(howoldru)). No need for utils::data() here.
  # We access it directly using its name.
  required_cpgs <- howoldru_data$probe_list     # Use probe_list from your str() output
  coefficients <- howoldru_data$coefficients   # Use coefficients from your str() output
  intercept_value <- howoldru_data$intercept   # Use intercept from your str() output

  # Ensure intercept is a single numeric value
  if (!is.numeric(intercept_value) || length(intercept_value) != 1) {
    stop("Intercept term in howoldru_data$intercept is not a single numeric value.")
  }

  # Basic Input Checks
  if (!is.matrix(data.m)) {
    if (is.data.frame(data.m)) {
      data.m <- as.matrix(data.m)
    } else {
      stop("Input 'data.m' must be a matrix or data.frame.")
    }
  }
  if (is.null(rownames(data.m))) {
    stop("Input 'data.m' must have rownames corresponding to CpG IDs.")
  }
  if (any(data.m < 0 | data.m > 1, na.rm = TRUE)) {
    warning("Input 'data.m' contains values outside the [0, 1] range. Ensure correct beta values are used.")
  }

  # Find overlapping CpGs
  common_cpgs <- intersect(rownames(data.m), required_cpgs)
  n_common <- length(common_cpgs)
  n_required <- length(required_cpgs)

  print(paste("Number of represented howoldru CpGs:", n_common, "out of", n_required))

  if (n_common < n_required * 0.8) { # Warn if less than 80% overlap
    warning(paste("Only", n_common, "out of", n_required,
                  "required CpGs were found in the data matrix.",
                  "Results may be less accurate."))
  }
  if (n_common == 0) {
    stop("No required CpGs found in the input data matrix.")
  }

  # Subset the data and coefficients to the common CpGs
  # Ensure names in coefficients vector match the common_cpgs for correct alignment
  if (!all(common_cpgs %in% names(coefficients))) {
    stop("Internal error: Some common CpGs are missing from the coefficient vector names.")
  }
  data_subset.m <- data.m[common_cpgs, , drop = FALSE] # Keep as matrix even if 1 row/col
  coeffs_subset.v <- coefficients[common_cpgs]         # Subset coeffs using common CpG names

  # Calculate the CpG-based score component
  # Ensure correct handling if only one sample is provided
  if (ncol(data_subset.m) == 1) {
    # Result should be a single value
    # Use %*% for matrix multiplication (1xN matrix * Nx1 vector)
    score_cpgs <- sum(data_subset.m * coeffs_subset.v, na.rm = TRUE) # Element-wise safer if NA handling needed
    # score_cpgs <- crossprod(coeffs_subset.v, data_subset.m) # Alternative using matrix algebra if no NAs
  } else {
    # Use colSums for multiple samples after element-wise multiplication
    score_cpgs <- colSums(data_subset.m * coeffs_subset.v, na.rm = TRUE)
    # score_cpgs <- crossprod(coeffs_subset.v, data_subset.m) # Alternative: Result is 1xM matrix, convert to vector
    # score_cpgs <- as.vector(score_cpgs)
  }


  # Calculate final score by adding the intercept
  final_score.v <- score_cpgs + intercept_value

  # Ensure names are preserved
  if (!is.null(colnames(data.m))) {
    names(final_score.v) <- colnames(data.m)
  }

  return(final_score.v)
}

# Add this line at the end of the file IF you want to make howoldru_data
# potentially available to the user via data(howoldru_data), although it's not
# strictly necessary if only the howoldru() function uses it internally.
# If you add this, run devtools::document() again.
# #' @details [Add this to the details block above if you include the line below]
# #' The underlying data object `howoldru_data` containing coefficients and probe lists
# #' can also be loaded into the user's environment via `data(howoldru_data)`.
# #' @docType data
# #' @keywords datasets
# #' @name howoldru_data
# #' @usage data(howoldru_data)
# #' @format A list containing the model intercept, coefficients, and probe list.
# "howoldru_data"
