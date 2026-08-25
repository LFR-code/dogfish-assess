# Locate the pinned SS3 executable that lives alongside this repo.
# Fetch it with: bash ss3/bin/get-ss3.sh
ss3_exe <- function(ss_home = here::here("ss3")) {
  exe <- if (.Platform$OS.type == "windows") "ss3_opt.exe" else "ss3_opt"
  path <- normalizePath(
    path = file.path(ss_home, "bin", exe),
    mustWork = FALSE
  )
  if (!file.exists(path)) {
    stop(
      "SS3 executable not found at:\n  ", path,
      "\nFetch the pinned version (v3.30.22.1) with:\n",
      "  bash ss3/bin/get-ss3.sh",
      call. = FALSE
    )
  }
  path
}

fit_ss3 <- function(
    model_dir = "model1",
    hessian = FALSE,
    ss_home = here::here("ss3"),
    max_phase,
    extra_args = "") {
  dir_cur <- getwd()
  dir_run <- file.path(ss_home, model_dir)

  fn_exe <- ss3_exe(ss_home = ss_home)

  setwd(dir_run)
  on.exit(setwd(dir_cur))

  cmd <- paste(shQuote(fn_exe), "modelname ss")

  if (!hessian) {
    cmd <- paste(cmd, "-nohess")
  }
  if (!missing(max_phase) && is.integer(max_phase)) {
    cmd <- paste(cmd, "-maxph", max_phase)
  }
  cmd <- paste(cmd, extra_args)
  message("File directory: ", dir_run)
  message("Command: ", cmd)

  system(cmd)
}
