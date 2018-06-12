.onLoad <- function(libname, pkgname) {
  if (!"Open Sans Light" %in% extrafont::fonts()) {
    rlang::warn("Open Sans Light is not installed. Please install it.")
  }

  invisible()
}
