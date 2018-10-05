# Setting column by reference by selecting first observation of a group with 
# more than 1 observation
# 
# Selecting first observation of a group with more than one observation at least.
#
# Hadleys question
# https://stackoverflow.com/q/16573995/4524755
# 
# Answer to select first observation effeciently +
# Matts comment in the following answer
# https://stackoverflow.com/a/16325932/4524755
# https://stackoverflow.com/a/20204630/4524755
# 
# Found another solution
# https://stackoverflow.com/a/30745366/4524755

# Test dataset for reproducible example
library(data.table)
set.seed(42L)
dat <- data.table(GRP = rep(c("A","B", "C"), seq_len(3L)),
                  VAL = sample.int(100L, 6L, TRUE))

# Result I desire
res <- cbind(dat, data.table(SEL = c("N", "Y", "N", "Y", "N", "N")))

# What I tried using above references
dat[dat[, .I[.N > 1L], by = "GRP"]$V1]
dat[dat[, .I[1L], by = "GRP"]$V1]
dat[, .SD[.N > 1L], by = "GRP"]

dat[dat[, if(.N > 1L) .SD[1L], by = "GRP"], on = c("GRP", "VAL"), SEL := "Y"][
  , SEL := ifelse(is.na(SEL), "N", SEL)]
dat
dat[dat[, head(.I[.N > 1L], 1L), by = "GRP"]$V1, SEL := "Y"][
  , SEL := ifelse(is.na(SEL), "N", SEL)]
dat
identical(dat, res)

library(microbenchmark)
library(ggplot2)
set.seed(42L)
dat1 <- data.table(GRP = rep(c("A","B", "C"), seq_len(3L)),
                  VAL = sample.int(100L, 6L, TRUE))
dat2 <- copy(dat1)

tmp <- microbenchmark(
  "SD_way" = dat1[dat1[, if(.N > 1L) .SD[1L], by = "GRP"], 
                  on = c("GRP", "VAL"), SEL := "Y"][
    , SEL := ifelse(is.na(SEL), "N", SEL)],
  "I_way" = dat2[dat2[, head(.I[.N > 1L], 1L), by = "GRP"]$V1, SEL := "Y"][
    , SEL := ifelse(is.na(SEL), "N", SEL)], 
  times = 1000L)
tmp
autoplot(tmp)
