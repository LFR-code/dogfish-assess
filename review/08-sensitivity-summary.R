# Summarise the multi-start of the published A- and B-series
# configurations: how far each supplied start sits above the best optimum
# found, and whether the better optimum changes the model's conclusion.
#
# Reads the run log written by 05-multistart-sensitivities.R.
suppressMessages(library(r4ss))

sp <- Sys.getenv("MS_WORK2")
stopifnot(nzchar(sp))
log_file <- Sys.getenv("MS2_LOG")
stopifnot(nzchar(log_file))

obj <- function(d) {
  f <- file.path(d, "ss.par")
  if (!file.exists(f)) return(NA_real_)
  as.numeric(sub(".*Objective function value = *([0-9.eE+-]+).*", "\\1",
                 readLines(f, n = 1)))
}
status <- function(d) {
  r <- try(SS_output(d, verbose = FALSE, printstats = FALSE,
                     hidewarn = TRUE, covar = FALSE), silent = TRUE)
  if (inherits(r, "try-error")) return(c(NA, NA, NA))
  q <- r$derived_quants
  g <- function(l) { i <- match(l, q$Label); if (is.na(i)) NA else as.numeric(q$Value[i]) }
  L <- r$likelihoods_used
  c(lencomp = L["Length_comp", "values"], SSB0 = g("SSB_Virgin"),
    depl = g("Bratio_2023"))
}

mods <- basename(list.dirs(sp, recursive = FALSE))
res <- do.call(rbind, lapply(X = mods, FUN = function(m) {
  ds <- Sys.glob(file.path(sp, m, "start*"))
  if (!length(ds)) return(NULL)
  o <- vapply(X = ds, FUN.VALUE = numeric(1), FUN = obj)
  if (all(is.na(o))) return(NULL)
  pub <- ds[basename(ds) == "start00"]; best <- ds[which.min(o)]
  P <- status(pub); B <- status(best)
  data.frame(model = m,
             published = round(o[basename(ds) == "start00"], 2),
             best = round(min(o, na.rm = TRUE), 2),
             penalty = round(o[basename(ds) == "start00"] - min(o, na.rm = TRUE), 2),
             lencomp_pub = round(P[1], 1), lencomp_best = round(B[1], 1),
             depl_pub = round(P[3], 3), depl_best = round(B[3], 3),
             depl_shift = round(B[3] - P[3], 3),
             row.names = NULL)
}))
res <- res[order(-res$penalty), , drop = FALSE]
print(res, row.names = FALSE)
write.csv(res, "review/figs/08-sensitivity-multistart.csv", row.names = FALSE)

cat("\nconfigurations with penalty > 10:", sum(res$penalty > 10), "of", nrow(res), "\n")
cat("largest depletion shift:", max(abs(res$depl_shift), na.rm = TRUE), "\n")
