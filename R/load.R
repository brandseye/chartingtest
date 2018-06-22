.onLoad <- function(libname, pkgname) {
  extrafont::loadfonts()
  if (!"Open Sans Light" %in% extrafont::fonts()) {
    extrafont::font_import(pattern = "OpenSans")
    if (!"Open Sans Light" %in% extrafont::fonts()) {
      warn("Open Sans Light is not installed. Please install it and reload this package.")
    }
  }
  if (!"Nunito Sans" %in% extrafont::fonts()) {
    extrafont::font_import(pattern = "NunitoSans")
    if (!"Nunito Sans" %in% extrafont::fonts()) {
      warn("Nunito Sans is not installed. Please install it and reload this package.")
    }
  }

  invisible()
}
