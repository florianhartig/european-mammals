
txt <- readLines("./data/Apodemus flavicollis.svg")

txt <- txt[grep("use id=", txt)]
txt2 <- sub('<use id=\"', "", txt)
txt3 <- sub('\"', "", txt2)
txt4 <- sub('xlink:href=\"', "", txt3)
txt5 <- sub('#', "", txt4)
txt6 <- sub('\"/>', "", txt5)

l1 <- strsplit(txt6, " ")
df <- as.data.frame(t(as.data.frame(l1)))

df <- df[-c(2, 3)]
rownames(df) <- NULL
