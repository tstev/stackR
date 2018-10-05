reprex::reprex({library(stringr)

  txt <- c("a ~ b c d*e !r x",
           "a ~ b c",
           "a ~ b c d1 !r y",
           "a ~ b c D !r z",
           "a~b c d*e!r z")

# Different tries with capture groups
str_replace(txt, "^.*~ (.*) !r.*$", "\\1")
str_replace(txt, "^(.*~ )(.*)( !r.*)$", "\\2")
str_replace(txt, "^(.*~)(.*)(!r.*|\n)$", "\\1\\2")
str_replace(txt, "^(.*) ~ (.*)!r.*($)", "\\2")
str_replace(txt, "^.* ~ (.*)(!r.*|\n)$", "\\1")


# Multiple steps
step1 <- str_replace(txt, "^.*~\\s*", "")
step2 <- str_replace(step1, "\\s*!r.*$", "")
step2}, venue = "so")

# My (probably non-robust) solution/monstrosity
str_replace(txt, "(^.*~\\s*(.*)\\s*!r.*$|^.*~\\s*(.*)$)", "\\2\\3")

str_extract_all(txt, "(?<=~\\s)[a-zA-Z0-9\\s*]+(?=\\b)")

str_replace(txt, "(^.*~ (.*) !r.*$|^.*~ (.*)$)", "\\2\\3")

# Weird cases
library(stringr)
txt <- c("a ~ b c d*e !r x",
         "a ~ b c",
         "a ~ b c d1 !r y",
         "a ~ b c D !r z",
         "a~b c d*e!r z")

# All solutions proposed on Stack
str_trim(str_extract(txt, "(?<=~)\\s*[a-zA-Z0-9*\\s]+(?=\\b)"))
str_trim(str_extract(txt, "(?<=~)[^!]+"))
str_replace_all(txt, "^[^~]+~\\s*|\\s*!r\\b.*", "")
gsub("^[^~]+~\\s*|\\s*!r\\b.*", "", txt)
str_replace_all(txt, ".*~ ?([\\w\\*\\-\\+\\ ]*)(!r.*)?", "\\1")

