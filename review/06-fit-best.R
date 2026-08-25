# Produce the canonical fit for each configuration: the best optimum found
# by the multi-start, refit with the Hessian.
#
# Design note. The directories under ss3/ stay pure *definitions* -- each
# differs from ss3/A0/ only in the lines that define it, which is what
# makes the configuration auditable. The optimum reached is a *result*,
# not part of the definition, so the fits live here instead. Each fit
# starts from the best parameter vector the multi-start found and is
# reported as best-of-N, which is the honest description given how
# multi-modal this surface is.
#
# Run after 04-multistart-run.R.

work_root <- Sys.getenv("MS_WORK")
stopifnot(nzchar(work_root))
exe <- normalizePath(file.path("ss3", "bin", "ss3_opt"))
outroot <- "review/fits"
dir.create(outroot, recursive = TRUE, showWarnings = FALSE)

res <- read.csv("review/figs/04-multistart-all.csv", stringsAsFactors = FALSE)

fit_best <- function(model, ss_home = "ss3") {
  r <- res[res$model == model, , drop = FALSE]
  r <- r[order(r$obj), , drop = FALSE]
  best_par <- file.path(work_root, model, r$start[1], "ss.par")
  d <- file.path(outroot, model)
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
  file.copy(file.path(ss_home, model, c("control.ss", "data.ss", "forecast.ss")),
            d, overwrite = TRUE)
  st <- readLines(file.path(ss_home, model, "starter.ss"))
  st[9] <- "1 # 0=use init values in control file; 1=use ss.par"
  writeLines(st, file.path(d, "starter.ss"))
  file.copy(best_par, file.path(d, "ss.par"), overwrite = TRUE)
  system(sprintf("cd %s && %s modelname ss -maxfn 1000 > run.log 2>&1",
                 shQuote(normalizePath(d)), shQuote(exe)))
  h <- readLines(file.path(d, "ss.par"), n = 1)
  data.frame(
    model = model,
    n_starts = nrow(r),
    best_start = r$start[1],
    cold_obj = round(r$obj[r$start == "start00"], 2),
    npar = as.numeric(sub(".*Number of parameters = *([0-9]+).*", "\\1", h)),
    obj  = round(as.numeric(sub(".*Objective function value = *([0-9.eE+-]+).*",
                                "\\1", h)), 2),
    grad = signif(as.numeric(sub(".*Maximum gradient component = *([0-9.eE+-]+).*",
                                 "\\1", h)), 2))
}

mods <- c("A0", "S1_sexswap", "S2_mwswap", "D1_commonsel",
          "D2_nodiscardlen", "D3_recdev")
out <- do.call(rbind, lapply(X = mods, FUN = fit_best))
out$delta_vs_A0 <- round(out$obj - out$obj[out$model == "A0"], 2)
out$cold_penalty <- round(out$cold_obj - out$obj, 2)
print(out, row.names = FALSE)
write.csv(out, "review/figs/06-best-fits.csv", row.names = FALSE)
