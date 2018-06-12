# Based on usethis
bullet <- function (lines, bullet) {
  lines <- paste0(bullet, " ", lines)
  cat(lines)
}

# Based on usethis
done <- function (...) {
  bullet(paste0(...), bullet = crayon::green(clisymbols::symbol$tick))
}

