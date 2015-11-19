setwd("/home/steffen/Documents/git/European Mammals/")
library(raster); library(maptools); library(ggplot2); library(rgdal); library(rgeos); library(plyr); library(dplyr)

source("./code/build_index.R"); source("./code/extract_species.R"); source("./code/load_spatial.R")#; source("./code/check.R")

# build look-up tables
abbr_species <- "tolower(paste(substr(unlist(strsplit(files[i], ' ')), 1, 3), collapse = '_'))"
index_species <- build_index(path="./data/SVGs/", type="svg", abbr=abbr_species)

setwd("/home/steffen/Documents/git/European Mammals/data/spatial/")
abbr_shape <- "paste(unlist(strsplit(files[i], '_'))[1:(length(unlist(strsplit(files[i], '_')))-2)], collapse='_')"
index_shape <- build_index(type="shp", incl=TRUE, abbr=abbr_shape)
index_shape$code[15] <- "European_countries"

abbr_grid <- "paste(paste(toupper(substr(unlist(strsplit(files[i], '_'))[-1], 1, 1)), substr(unlist(strsplit(files[i], '_'))[-1], 2, nchar(unlist(strsplit(files[i], '_'))[-1])), sep=''), collapse='_')"
index_grid <- build_index(type="kml", incl=TRUE, abbr=abbr_grid)
index_grid$code <- substr(index_grid$code, 1, nchar(index_grid$code)-4)
index_grid$code[8] <- "Bosnia_and_Herzegovina"

index_spatial <- full_join(index_grid, index_shape, by="code")
colnames(index_spatial) <- c("grid", "code", "shape")
index_spatial <- index_spatial[!is.na(index_spatial$grid) & !is.na(index_spatial$shape),]
index_spatial <- index_spatial[, c(2, 1, 3)]; 
index_spatial2 <- data.frame(code = index_spatial$code, shape = paste(index_spatial$code, "_shape", sep=""), grid = paste(index_spatial$code, "_grid", sep=""), stringsAsFactors = FALSE)
rm(index_grid, index_shape, abbr_grid, abbr_shape, abbr_species)

# load spatial and species information
setwd("/home/steffen/Documents/git/European Mammals/data/")
load_spatial(sbst=c("Spain", "France", "Czech_Republic", "Poland", "Norway", 
                    "Germany", "United_Kingdom", "Sweden", "Finland"), 
             index=index_spatial, load="grids")

soi <- c("apo_syl", "apo_fla", "mic_sub", "mic_agr", "sor_min", "sor_ara", "myo_gla")

soi2 <- index_species$original[index_species$code %in% soi]
soi2 <- soi2[-7]
extract_species(soi = soi2)

# occ <- check_coordinates(coords=, proj=, sbst=, )

France_grid <- France_grid[, -c(2:11)]
France_grid <- spChFIDs(France_grid, as.character(France_grid$Name))
Poland_grid <- Poland_grid[, -c(2:11)]
Poland_grid <- spChFIDs(Poland_grid, as.character(Poland_grid$Name))

bla <- spRbind(France_grid, Poland_grid)
# next: intersection between tow shapes while preserving the contained polys.
France_grid2 <- gIntersection(France_grid, France_grid_int)
Central <- spRbind(France_grid, Polan)

# extract coordinates from kml-files and join them with abundance of desired species to get a subset of the species per
# desired area.
laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
wgs84 <- c("+proj=longlat +datum=WGS84 +no_defs")
Europe_borders <- readOGR("./spatial/europe_country_borders.shp", "europe_country_borders")
crs(Europe_borders) <- laea

crd <- coordinates(France_grid)
crd <- as.data.frame(crd)
crd <- cbind(crd, France_grid@data$Name)
colnames(crd) <- c("X", "Y", "SQ")

apo_fla_est <- join(crd, `Apodemus flavicollis`, by="SQ")
coordinates(apo_fla_est) <- ~X+Y
crs(apo_fla_est) <- laea

plot(France_grid)
plot(France_shape, add=T)
points(apo_fla_post70_1, pch=16, cex=1)


## next: function that puts together the grid of several countries and extracts coordinates from these.


study <- "butet2006"; years <- 1995
meta <- read.csv(paste("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/", study, "/", study, "_meta_", years, ".csv", sep=""))
coordinates(meta) <- ~X+Y
points(meta, col="green")

coordinates(France_grid@polygons[[1]]@Polygons[[1]])
blubb <- coordinates(France_grid@polygons[[1]]@Polygons[[1]])
blubb <- as.data.frame(blubb)



# make map of studies
values500 <- read.csv("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/values_500_40.csv")
coordinates(values500) <- ~X+Y

par(mar=c(0, 0, 0, 0))
plot(Europe_borders, lwd=.3)
points(values500, col="red", pch=3, cex=.4, lwd=.1)
points(apo_fla_post70_1, pch=16, cex=0.5)
