# Multi-start the authors' A- and B-series configurations.
#
# Motivation: the perturbed configurations built for this review reached
# optima hundreds of likelihood units apart depending only on where the
# optimiser started. A0 itself is robust (21 starts all return 1646.38),
# but that does not establish that the other 20 published configurations
# are. If any of them sits at a poor optimum, comparisons among them --
# and any ensemble built from them -- are affected.
#
# This is a check on the published sensitivities, not a criticism: it is
# exactly the question we are also putting to the authors.

source("review/03-jitter.R")

work_root <- Sys.getenv("MS_WORK2")
if (!nzchar(work_root)) work_root <- file.path(tempdir(), "multistart2")
dir.create(work_root, recursive = TRUE, showWarnings = FALSE)

source("ss3/99-model-names.R")  # provides `mods`

res <- list()
for (m in mods) {
  cat("\n==== ", m, " ====\n", sep = "")
  r <- try(multistart(model = m, work = file.path(work_root, m),
                      n = 10, frac = 0.10, seed = 7,
                      warm_par = NULL, cores = 8), silent = TRUE)
  if (inherits(r, "try-error")) { cat("FAILED\n"); next }
  cold <- r$obj[r$start == "start00"]
  res[[m]] <- data.frame(
    model = m,
    published_start = round(cold, 2),
    best_found = round(r$obj[1], 2),
    penalty = round(cold - r$obj[1], 2),
    best_from = r$start[1],
    n_starts = nrow(r))
  cat("published-start:", round(cold, 2), " best:", round(r$obj[1], 2),
      " penalty:", round(cold - r$obj[1], 2), "\n")
}
tab <- do.call(rbind, res)
tab <- tab[order(-tab$penalty), , drop = FALSE]
print(tab, row.names = FALSE)
write.csv(tab, "review/figs/05-sensitivity-multistart.csv", row.names = FALSE)
