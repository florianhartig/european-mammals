setwd("~/Documents/git/European Mammals")
library(raster)
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
apo_fla <- df
rm("txt", "txt2", "txt3", "txt4", "txt5", "txt6", "l1", "df")

laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
eu <- readShapePoly("./data/europe.shp")
crs(eu) <- laea

setwd("~/Documents/git/European Mammals/data/raw/")
files <- list.files(pattern="[.]shp$", recursive=T)
for(i in 1:length(files)){
  assign(eval(files[i]), readShapePoly(files[i]))
}
for(i in 1:length(files)){
  str <- paste("+proj=utm +zone=", substr(files[i], 17, 18), " +datum=WGS84 +units=m +no_defs", sep="")
  x <- get(files[i])
  crs(x) <- str
  x <- spTransform(x, "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
  assign(eval(files[i]), x[, order(names(x))])
}

plot(eu)
for(i in 1:length(files)){
  plot(get(files[i]), add=T)
}

