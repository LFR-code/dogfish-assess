# Multi-start (jitter) harness.
#
# The dogfish likelihood surface is multi-modal: perturbed configurations
# reached optima up to 660 units worse than a warm start from A0's
# solution found for the same configuration. Single-start fits are
# therefore not trustworthy and every configuration must be multi-started
# before its likelihood is compared with any other.
#
# SS3's own jitter was deterministic across runs in this setup, so the
# perturbation is done here instead: reproducible, seeded, and recorded.

# Identify parameter lines in a control file: exactly 14 numeric fields
# followed by a comment. Returns indices into the line vector.
ctl_par_lines <- function(lines) {
  vapply(X = lines, FUN.VALUE = logical(1), USE.NAMES = FALSE, FUN = function(l) {
    if (!grepl("#", l)) return(FALSE)
    body <- sub("#.*$", "", l)
    f <- strsplit(trimws(body), "[[:space:]]+")[[1]]
    if (length(f) != 14) return(FALSE)
    all(!is.na(suppressWarnings(as.numeric(f))))
  })
}

ctl_fields <- function(l) {
  body <- sub("#.*$", "", l)
  as.numeric(strsplit(trimws(body), "[[:space:]]+")[[1]])
}

# Write a jittered copy of a control file. Estimated parameters (phase > 0)
# are displaced by `frac` of their bounded range and clipped inside bounds.
jitter_ctl <- function(ctl_in, ctl_out, frac = 0.10) {
  lines <- readLines(ctl_in)
  isp <- ctl_par_lines(lines)
  idx <- which(isp)
  njit <- 0
  for (i in idx) {
    f <- ctl_fields(lines[i])
    lo <- f[1]; hi <- f[2]; init <- f[3]; phase <- f[7]
    if (phase <= 0) next
    if (!is.finite(lo) || !is.finite(hi) || hi <= lo) next
    rng <- hi - lo
    new <- init + frac * rng * rnorm(1)
    pad <- 0.001 * rng
    new <- min(max(new, lo + pad), hi - pad)
    f[3] <- new
    comment <- sub("^[^#]*", "", lines[i])
    lines[i] <- paste0("  ", paste(formatC(f, width = 13, format = "g",
                                           digits = 10), collapse = " "),
                       "  ", comment)
    njit <- njit + 1
  }
  writeLines(lines, ctl_out)
  njit
}

# Count estimated parameters in a control file.
n_estimated <- function(ctl) {
  lines <- readLines(ctl)
  idx <- which(ctl_par_lines(lines))
  sum(vapply(X = idx, FUN.VALUE = numeric(1),
             FUN = function(i) ctl_fields(lines[i])[7]) > 0)
}

obj_from_par <- function(par_file) {
  if (!file.exists(par_file)) return(NA_real_)
  h <- readLines(par_file, n = 1)
  as.numeric(sub(".*Objective function value = *([0-9.eE+-]+).*", "\\1", h))
}

grad_from_par <- function(par_file) {
  if (!file.exists(par_file)) return(NA_real_)
  h <- readLines(par_file, n = 1)
  as.numeric(sub(".*Maximum gradient component = *([0-9.eE+-]+).*", "\\1", h))
}

# Multi-start one model directory. Returns a data frame of all starts.
# Also leaves the best-found parameter vector at <work>/best/ss.par.
multistart <- function(model, ss_home = "ss3", work, n = 20, frac = 0.10,
                       seed = 42, warm_par = NULL, cores = 8,
                       exe = normalizePath(file.path("ss3", "bin", "ss3_opt"))) {
  src <- file.path(ss_home, model)
  dir.create(work, recursive = TRUE, showWarnings = FALSE)
  set.seed(seed)

  runs <- list()
  # start 0: the control file as supplied (cold start)
  d0 <- file.path(work, "start00")
  dir.create(d0, showWarnings = FALSE)
  file.copy(file.path(src, c("control.ss", "data.ss", "forecast.ss",
                             "starter.ss")), d0, overwrite = TRUE)
  runs[["start00"]] <- d0

  # start W: warm start from a supplied par file, when the vector matches
  if (!is.null(warm_par) && file.exists(warm_par)) {
    dw <- file.path(work, "startWarm")
    dir.create(dw, showWarnings = FALSE)
    file.copy(file.path(src, c("control.ss", "data.ss", "forecast.ss")),
              dw, overwrite = TRUE)
    st <- readLines(file.path(src, "starter.ss"))
    st[9] <- "1 # 0=use init values in control file; 1=use ss.par"
    writeLines(st, file.path(dw, "starter.ss"))
    file.copy(warm_par, file.path(dw, "ss.par"), overwrite = TRUE)
    runs[["startWarm"]] <- dw
  }

  # jittered starts
  for (j in seq_len(n)) {
    dj <- file.path(work, sprintf("start%02d", j))
    dir.create(dj, showWarnings = FALSE)
    file.copy(file.path(src, c("data.ss", "forecast.ss", "starter.ss")),
              dj, overwrite = TRUE)
    jitter_ctl(file.path(src, "control.ss"), file.path(dj, "control.ss"),
               frac = frac)
    runs[[sprintf("start%02d", j)]] <- dj
  }

  cmd <- sprintf("cd %s && %s modelname ss -nohess -maxfn 1000 > run.log 2>&1",
                 shQuote(unlist(runs)), shQuote(exe))
  parallel::mclapply(X = cmd, FUN = system, mc.cores = cores)

  res <- data.frame(
    start = names(runs),
    obj   = vapply(X = unlist(runs), FUN.VALUE = numeric(1),
                   FUN = function(d) obj_from_par(file.path(d, "ss.par"))),
    grad  = vapply(X = unlist(runs), FUN.VALUE = numeric(1),
                   FUN = function(d) grad_from_par(file.path(d, "ss.par"))),
    stringsAsFactors = FALSE, row.names = NULL)
  res <- res[order(res$obj), , drop = FALSE]

  best_dir <- unlist(runs)[[res$start[1]]]
  dir.create(file.path(work, "best"), showWarnings = FALSE)
  file.copy(file.path(best_dir, "ss.par"), file.path(work, "best", "ss.par"),
            overwrite = TRUE)
  attr(res, "best_dir") <- best_dir
  res
}
