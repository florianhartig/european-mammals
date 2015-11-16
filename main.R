setwd("~/Documents/git/European Mammals")
library(raster); library(maptools); library(ggplot2); library(rgdal); library(rgeos); library(plyr); library(dplyr)
txt <- readLines("./data/SVGs/Apodemus flavicollis.svg")

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
colnames(df) <- c("SQ", "occ")
apo_fla <- df
rm("txt", "txt2", "txt3", "txt4", "txt5", "txt6", "l1", "df")

laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
wgs84 <- c("+proj=longlat +datum=WGS84 +no_defs")
eu <- readShapePoly("./data/europe.shp")
crs(eu) <- laea
bioregions <- readOGR("./data/bioregions.kml", "bioregions")
crs(bioregions) <- wgs84
bioregions <- spTransform(bioregions, laea)

# http://www.helsinki.fi/~rlampine/gmap/afegrid_kml.html
# http://pakillo.github.io/R-GIS-tutorial/
# http://www.luomus.fi/en/new-grid-system-atlas-florae-europaeae
setwd("~/Documents/git/European Mammals/data/AFE-grid")

# read in shapefiles for country delineation
files <- list.files(pattern="[.]shp$")
for(i in 1:length(files)){
  x <- readShapePoly(files[i])
  crs(x) <- laea
  assign(eval(files[i]), x)
}

# read in kml-files to find central points per SQ. This is neccessary, since the SQs in the country shapes are cut at
# intersected at all the borders and thus the centre of the polygon would not be at the eight position.
files2 <- list.files(pattern="[.]kml$")
for(i in 1:length(files2)){
  x <- readOGR(files2[i], substr(files2[i], 1, nchar(files2[i])-4))
  x <- spTransform(x, laea)
  assign(eval(files2[i]), x)
}

# extract coordinates from kml-files and join them with abundance of desired species to get a subset of the species per
# desired area.
crd <- coordinates(cgrs_france.kml)
crd <- as.data.frame(crd)
crd <- cbind(crd, cgrs_france.kml@data$Name)
colnames(crd) <- c("X", "Y", "SQ")
apo_fla_est <- join(crd, apo_fla, by="SQ")
coordinates(apo_fla_est) <- ~X+Y
crs(apo_fla_est) <- laea

# determine the ccurence and build subsets
apo_fla_pre70_1 <- subset(apo_fla_est, apo_fla_est$occ=="pre70_1")
apo_fla_post70_1 <- subset(apo_fla_est, apo_fla_est$occ=="post70_1")
apo_fla_pre70_2 <- subset(apo_fla_est, apo_fla_est$occ=="pre70_2")
apo_fla_post70_2 <- subset(apo_fla_est, apo_fla_est$occ=="post70_2")

plot(cgrs_france.kml)
plot(France_EBBA2_grid.shp, add=T)
points(apo_fla_post70_1, pch=16, cex=1)

## next: function that puts together the grid of several countries and extracts coordinates from these.

values500 <- read.csv("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/values_500_40.csv")
coordinates(values500) <- ~X+Y

study <- "butet2006"; years <- 1995
meta <- read.csv(paste("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/", study, "/", study, "_meta_", years[i], ".csv", sep=""))
coordinates(meta) <- ~X+Y
points(meta, col="red")

coordinates(cgrs_france.kml@polygons[[1]]@Polygons[[1]])
blubb <- coordinates(cgrs_france.kml@polygons[[1]]@Polygons[[1]])
blubb <- as.data.frame(blubb)



# make map of studies
values500 <- read.csv("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/values_500_40.csv")
coordinates(values500) <- ~X+Y

par(mar=c(0, 0, 0, 0))
plot(eu, lwd=.5)
points(values500, col="red", pch=3, cex=.4, lwd=.1)
points(apo_fla_post70_1, pch=16, cex=0.5)
