# Based on usethis
bullet <- function (lines, bullet) {
  lines <- paste0(bullet, " ", lines)
  cat(lines, "\n")
}

# Based on usethis
done <- function (...) {
  bullet(paste0(...), bullet = crayon::green(clisymbols::symbol$tick))
}

warn <- function(...) {
  rlang::warn(paste(crayon::red(clisymbols::symbol$warning), paste0(...)))
}

error <- function(...) {
  rlang::abort(paste(crayon::red(clisymbols::symbol$cross), paste0(...)))
}
