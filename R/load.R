.onLoad <- function(libname, pkgname) {
  if (!"Open Sans Light" %in% extrafont::fonts()) {
    warn("Open Sans Light is not installed. Please install it.")
  }
  if (!"Nunito Sans" %in% extrafont::fonts()) {
    warn("Nunito Sans is not installed. Please install it.")
  }

  invisible()
}
