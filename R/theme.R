LIGHT_GREY  <- "#e9e9e9"  # gridlines, bars and columns, neutral sentiment
MID_GREY    <- "#c0c0c0"  # table borders, bars and columns if light grey is too lightGrey
DARK_GREY   <- "#444444"  # All text

#' Provides a BrandsEye ggplot2 theme.
#'
#' This is still a work in progress, but should provide a ggplot2 theme
#' for charts.
#'
#' @return The theme object.
#' @export
theme_brandseye <- function() {
  # panel.border = element_blank(),
  theme_light() + theme(text = element_text(family = "Open Sans Light",
                                            colour = DARK_GREY),
                        panel.grid = element_line(colour = LIGHT_GREY),
                        panel.grid.major = element_line(color = LIGHT_GREY),
                        panel.grid.major.x = element_blank(),
                        panel.grid.minor = element_blank())
}



# update_geom_defaults("bar", list(fill = MID_GREY))
