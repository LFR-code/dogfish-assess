# Multi-start every configuration so likelihoods are compared at the best
# optimum found, not at whatever the optimiser happened to reach from the
# supplied initial values.
source("review/03-jitter.R")

work_root <- Sys.getenv("MS_WORK")
if (!nzchar(work_root)) work_root <- file.path(tempdir(), "multistart")
dir.create(work_root, recursive = TRUE, showWarnings = FALSE)

# Configurations sharing A0's control file can warm-start from A0's solution.
same_ctl <- c("S1_sexswap", "S2_mwswap", "D2_nodiscardlen")
mods <- c("A0", "S1_sexswap", "S2_mwswap", "D1_commonsel",
          "D2_nodiscardlen", "D3_recdev")

all_res <- list()
for (m in mods) {
  cat("\n==== multistart:", m, "====\n")
  wp <- if (m %in% same_ctl) "ss3/A0/ss.par" else NULL
  r <- multistart(model = m, work = file.path(work_root, m),
                  n = 20, frac = 0.10, seed = 42, warm_par = wp, cores = 8)
  r$model <- m
  all_res[[m]] <- r
  cat("best:", round(r$obj[1], 2), " from ", r$start[1],
      " | cold start was ",
      round(r$obj[r$start == "start00"], 2), "\n")
}

res <- do.call(rbind, all_res)
write.csv(res, "review/figs/04-multistart-all.csv", row.names = FALSE)

best <- do.call(rbind, lapply(X = all_res, FUN = function(r) {
  cold <- r$obj[r$start == "start00"]
  data.frame(model = r$model[1],
             best_obj = round(r$obj[1], 2),
             best_start = r$start[1],
             cold_obj = round(cold, 2),
             cold_penalty = round(cold - r$obj[1], 2),
             n_converged = sum(is.finite(r$obj)),
             n_within_1 = sum(r$obj <= r$obj[1] + 1, na.rm = TRUE),
             max_grad_best = signif(r$grad[1], 2))
}))
print(best, row.names = FALSE)
write.csv(best, "review/figs/04-multistart-best.csv", row.names = FALSE)
cat("\nwork dir:", work_root, "\n")
