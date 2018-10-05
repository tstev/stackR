library(data.table)

set.seed(42L)
dat <- data.table(ID1 = rep(c(1234L, 1236L, 1257L), 3:1), 
                  ID2 = c(1234L, 1236L, 1257L, 1236L, 1257L, 1257L),
                  VAL = rnorm(6))

sel <- data.table(ID = c(1234L, 1236L, 1248L, 1257L),
                  SEL = c("Y", "N", "N", "Y"))

# Desired result
dat[ID1 %in% sel[SEL == "Y", ID] & ID2 %in% sel[SEL == "Y", ID]]

# Inner join attempt
dat1 <- copy(dat)
sel1 <- copy(sel)

dat1[sel1[SEL == "Y"], on = c(ID1 = "ID", ID2 = "ID"), nomatch = 0][
  , .(ID1, ID2, VAL)]
dat1[sel1[SEL == "Y"], on = .(ID1 == ID, ID2 == ID), .SD, by = .EACHI]
dat1[sel1[SEL == "Y"], on = .(ID1 == ID, ID2 == ID), nomatch = 0]
merge(dat1, sel1[SEL == "Y", .(ID1 = ID, ID2 = ID)], by = c("ID1", "ID2"))

# Attempt 2
# https://stackoverflow.com/q/10600060/4524755
dat2 <- copy(dat)
sel2 <- copy(sel)
setkey(dat2, ID1, ID2)
setkey(sel2, ID)

dat2[CJ(sel2[SEL == "Y", ID], sel2[SEL == "Y", ID]), nomatch = 0]

# Two step merge
dat3 <- copy(dat)
sel3 <- copy(sel)
tmp <- merge(dat3, sel3[SEL == "Y"], by.x = "ID1", by.y = "ID")[, .(ID1, ID2, VAL)]
tmp <- merge(tmp, sel3[SEL == "Y"], by.x = "ID2", by.y = "ID")[, .(ID1, ID2, VAL)]
tmp

# Another attempt at two step merge
# # Tried: understood one of the more efficient ways to join
# https://stackoverflow.com/a/31486457/4524755
dat4 <- copy(dat)
sel4 <- copy(sel)
tmp <- dat4[sel4[SEL == "Y"], .SD, on = c(ID1 = "ID")]
tmp <- tmp[sel4[SEL == "Y"], .SD, on = c(ID2 = "ID")]
tmp

# Another attempt
# https://stackoverflow.com/a/12773976/4524755
dat5 <- copy(dat)
sel5 <- copy(sel)
setkey(dat5, ID1, ID2)
setkey(sel5, ID)
unique_keys <- unique(sel[SEL == "Y", ID])
dat5[CJ(sel[SEL == "Y", ID], sel[SEL == "Y", ID]), nomatch = 0]

# Another attempt
# https://stackoverflow.com/a/13274291/4524755
dat6 <- copy(dat)
sel6 <- copy(sel)
Reduce(merge, list(dat6, sel6, sel6))
