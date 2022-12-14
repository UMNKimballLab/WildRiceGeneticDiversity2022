# this script is to make a genome-wide LD plot
library(data.table)
library(sommer) # the `sommer` package probably isn't necessary because we've already used the `LD.decay()` function-but might as well load it for consistency

# Load results from previous analysis (from the `LD_decay_separate_classes.R` script_)
load("220401_LD_decay_separate_classes.Rdata")

# Convert results to data.table foramt
cm_data <- as.data.table(cultivated_results_linked$all.LG)
ns_data <-as.data.table(natural_stands_results_linked$all.LG)

# Filter for significant data (p < 0.001)
cm_sig <- cm_data[p < 0.001]
ns_sig <- ns_data[p < 0.001]

# Apply loess function--takes a few minutes, so be patient :)
# Also a first initial note: the loess curve is just a straight vertical line at x = 0
# The predicted values are less than 1 (which makes sense given that we are working with R^2..but how to get it to go the length of the x-axis?)
cm_loess_values <- loess(cm_sig$r2 ~ cm_sig$d)
cm_xvals <- seq(min(cm_sig$d), max(cm_sig$d), (max(cm_sig$d) - min(cm_sig$d))/1e6)

ns_loess_values <- loess(ns_sig$r2 ~ ns_sig$d)
ns_xvals <- seq(min(ns_sig$d), max(ns_sig$d), (max(ns_sig$d) - min(ns_sig$d))/1e6)

# other good green color: "#00a54c"

# Side by side plots
pdf("genome-wide_LD_separate_classes_side_by_side.pdf", height = 10, width = 20)
layout(matrix(c(1,2), nrow = 1), widths = c(5,5))
par(oma = c(1,1,1,1))
par(mar = c(5,5,2,1))
cm_sig[, plot(x = d, y = r2, xlab = "Distance (bp)",
			     ylab = expression("R"^"2"),
			     main = "Cultivated",
			     xaxt = "n",
			     pch = 16,
			     col = "#a3aaad",
			     cex.lab = 1.5,
			     las = 1)]
cm_sig[, lines(cm_xvals, predict(cm_loess_values, cm_xvals), col = "#235e39", lwd = 2)]
axis(side = 1,
	 at = c(0, 2e7, 4e7, 6e7, 8e7, 1e8),
	 labels = c(0, expression("2×10"^"7"), expression("4×10"^"7"), expression("6×10"^"7"), expression("8×10"^"7"), expression("1×10"^"8")))
ns_sig[, plot(x = d, y = r2, xlab = "Distance (bp)",
			     ylab = expression("R"^"2"),
			     main = "Natural Stands",
			     xaxt = "n",
			     pch = 16,
			     col = "#a3aaad",
			     cex.lab = 1.5,
			     las = 1)]
ns_sig[, lines(ns_xvals, predict(ns_loess_values, ns_xvals), col = "#235e39", lwd = 2)]
axis(side = 1,
	 at = c(0, 2e7, 4e7, 6e7, 8e7, 1e8),
	 labels = c(0, expression("2×10"^"7"), expression("4×10"^"7"), expression("6×10"^"7"), expression("8×10"^"7"), expression("1×10"^"8")))
dev.off()

# Single plot
pdf("genome-wide_LD_separate_classes_single_plot.pdf")
par(mar = c(6, 6, 2, 10))
par(oma = c(0, 0, 0, 0))
cm_sig[, plot(x = d, y = r2, xlab = "Distance (bp)",
			     ylab = expression("R"^"2"),
			     ylim = c(0,1.0),
	      		     xaxt = "n",
			     pch = 1,
			     col = "#a3aaad",
			     cex.lab = 1.5,
			     las = 1)]
ns_sig[, points(x = d, y = r2, xlab = "Distance (bp)",
			       ylab = expression("R"^"2"),
			       pch = 2,
			       col = "#a3aaad",
			       cex.lab = 1.5,
			       las = 1)]
cm_sig[, lines(cm_xvals, predict(cm_loess_values, cm_xvals), col = "#00a54c", lwd = 2)]
ns_sig[, lines(ns_xvals, predict(ns_loess_values, ns_xvals), col = "#235e39", lwd = 2)]
axis(side = 1,
     at = c(0, 2e7, 4e7, 6e7, 8e7, 1e8),
     labels = c(0, expression("2×10"^"7"), expression("4×10"^"7"), expression("6×10"^"7"), expression("8×10"^"7"), expression("1×10"^"8")))
legend("topright", inset = c(-0.45, 0.3), xpd = TRUE, legend = c("Cultivated", "Natural Stand"), col = c("#00a54c", "#235e39"), lwd = 2, bty = "n") # legend for loess curve lines
legend("topright", inset = c(-0.45, 0.4), xpd = TRUE, legend = c("Cultivated", "Natural Stand"), col = c("#a3aaad", "#a3aaad"), pch = c(1,2), bty = "n") # legend for points
dev.off()

# Save data (note: only saving "new" data since the original `LD.decay()` resuts are found in the file "220401_LD_decay_separate_classes.Rdata" which can also be re-loaded if necessary)
save(cm_data, cm_sig, cm_loess_values, cm_xvals, ns_data, ns_sig, ns_loess_values, ns_xvals, file = "220405_LD_decay_separate_classes_plot_data.Rdata")
