library(stringr)

str_msg <- function (..., env) {
  if (missing(env) || is.null(env)) env <- parent.frame()
  str_interp(str_c(..., sep = " "), env = env)
}


get_blah <- function(x, ...) {
  if (identical(x, 1L)) {
    ret <- "blah"
    ans <- str_msg("here is ${ret}", ...)
    return(ans)
  }
  NULL
}

get_blah(0)
get_blah(1L)
get_blah(1L, env = list(ret = "blah"))


get_blah <- function(x, ...) {
  if (identical(x, 1L)) {
    ret <- "blah"
    ans0 <- str_msg("here is ${ret}", ...)
    ans1 <- str_interp(str_c("${ret}", sep = " "))
    return(list(ans0 = ans0, ans1 = ans1))
  }
  NULL
}

get_blah(1L)
