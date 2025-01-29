#Some code from this section was contributed by ChatGPT
setwd("Genetic Diversity/BayesAss")
# File paths
input_file <- "Lim_EstimatedVal1_250114.txt" 
output_csv <- "Lim_EstimatedVal1_matrix_250117.csv"
mapping <- c(
  "0" = "Aquatica Species",
  "1" = "Barron",
  "2" = "Bass Lake",
  "3" = "Clearwater River",
  "4" = "Dahler Lake",
  "5" = "Decker Lake",
  "6" = "FY-C20",
  "7" = "Garfield Lake",
  "8" = "Itasca-C12",
  "9" = "K2",
  "10" = "Mud Hen Lake",
  "11" = "Necktie River",
  "12" = "Ottertail River",
  "13" = "Itasca-C20",
  "14" = "PM3E",
  "15" = "Phantom Lake",
  "16" = "Plantagenet",
  "17" = "Shell Lake",
  "18" = "Upper Rice Lake")
order<-c("0","2","3","4","5","7","10","11","12","15","16","17","18","1","6","8","13","9","14")
# Read the file into a character vector
lines <- readLines(input_file)

# Initialize an empty list to store migration rates
migration_rates <- list()

# Regular expression to match the migration rate format
pattern <- "m\\[(\\d+)\\]\\[(\\d+)\\]: ([0-9.]+)"

# Parse the lines
for (line in lines) {
  matches <- regmatches(line, gregexpr(pattern, line))
  for (match in matches[[1]]) {
    # Extract row, column, and value
    parts <- regmatches(match, regexec(pattern, match))[[1]]
    row <- as.integer(parts[2]) + 1  # R is 1-based, adjust indices
    col <- as.integer(parts[3]) + 1
    value <- as.numeric(parts[4])
    
    # Ensure the list is large enough to hold the row
    if (length(migration_rates) < row) {
      migration_rates[[row]] <- numeric()  # Initialize missing rows
    }
    
    # Ensure the row vector is large enough to hold the column
    if (length(migration_rates[[row]]) < col) {
      migration_rates[[row]][col] <- NA  # Fill with NAs if needed
    }
    
    # Store the migration rate value
    migration_rates[[row]][col] <- value
  }
}

# Convert the list to a matrix
n_rows <- length(migration_rates)
n_cols <- max(sapply(migration_rates, length))
migration_matrix <- matrix(NA, nrow = n_rows, ncol = n_cols)

for (i in seq_along(migration_rates)) {
  migration_matrix[i, seq_along(migration_rates[[i]])] <- migration_rates[[i]]
}

# Create original numeric row and column names
original_names <- as.character(seq_len(max(n_rows, n_cols)) - 1)
rownames(migration_matrix) <- original_names[seq_len(n_rows)]
colnames(migration_matrix) <- original_names[seq_len(n_cols)]

# Reorder rows and columns based on `order`
order_indices <- match(order, original_names)
migration_matrix <- migration_matrix[order_indices, order_indices, drop = FALSE]

# Map numeric IDs to descriptive names
mapped_names <- mapping[original_names]
rownames(migration_matrix) <- mapped_names[order_indices]
colnames(migration_matrix) <- mapped_names[order_indices]

# Write the reordered and mapped matrix to a CSV file
write.csv(migration_matrix, output_csv, row.names = TRUE)
