.onLoad <- function(libname, pkgname) {
  pdfFonts <- grDevices::pdfFonts
  extrafont::loadfonts(quiet = TRUE)

  if (!"Open Sans Light" %in% extrafont::fonts()) {
    extrafont::font_import(pattern = "OpenSans", prompt = FALSE)
    if (!"Open Sans Light" %in% extrafont::fonts()) {
      warn("Open Sans Light is not installed. Please install it and reload this package.")
    }
  }
  if (!"Nunito Sans" %in% extrafont::fonts()) {
    extrafont::font_import(pattern = "NunitoSans", prompt = FALSE)
    if (!"Nunito Sans" %in% extrafont::fonts()) {
      warn("Nunito Sans is not installed. Please install it and reload this package.")
    }
  }

  invisible()
}
