setwd("/home/steffen/Documents/git/European Mammals/")
library(raster); library(maptools); library(ggplot2); library(rgdal); library(rgeos); library(plyr); library(dplyr)

source("./code/build_index.R"); source("./code/load_species.R"); source("./code/load_spatial.R")
source("./code/check_data.R"); source("./code/european_mammals.R")

# build look-up tables
abbr_species <- "tolower(paste(substr(unlist(strsplit(files[i], ' ')), 1, 3), collapse = '_'))"
index_species <- build_index(path="./data/SVGs/", type="svg", abbr=abbr_species)

abbr_shape <- "paste(unlist(strsplit(files[i], '_'))[1:(length(unlist(strsplit(files[i], '_')))-2)], collapse='_')"
index_shape <- build_index(path="./data/spatial/", type="shp", incl=TRUE, abbr=abbr_shape)
index_shape$code[15] <- "Europe"; index_shape$code[16] <- "europe_borders"

abbr_grid <- "paste(paste(toupper(substr(unlist(strsplit(files[i], '_'))[-1], 1, 1)), substr(unlist(strsplit(files[i], '_'))[-1], 2, nchar(unlist(strsplit(files[i], '_'))[-1])), sep=''), collapse='_')"
index_grid <- build_index(path="./data/spatial/", type="kml", incl=TRUE, abbr=abbr_grid)
index_grid$code <- substr(index_grid$code, 1, nchar(index_grid$code)-4)
index_grid$code[8] <- "Bosnia_and_Herzegovina"

index_spatial <- full_join(index_grid, index_shape, by="code")
colnames(index_spatial) <- c("grid", "code", "shape")
index_spatial <- index_spatial[!is.na(index_spatial$grid) & !is.na(index_spatial$shape),]
index_spatial <- index_spatial[, c(2, 1, 3)]; 
index_spatial2 <- data.frame(code = index_spatial$code, shape = paste(index_spatial$code, "_shape", sep=""), grid = paste(index_spatial$code, "_grid", sep=""), stringsAsFactors = FALSE)
rm(index_grid, index_shape, abbr_grid, abbr_shape, abbr_species)

# load spatial and species information
# setwd("/home/steffen/Documents/git/European Mammals/data/")
load_spatial(path="./data/spatial/", sbst=c("Europe", "Spain", "France", "Czech_Republic", "Poland", "Norway", 
                    "Germany", "United_Kingdom", "Sweden", "Finland"), 
             index=index_spatial, load="grids")

soi <- c("apo_syl", "apo_fla", "mic_sub", "mic_agr", "sor_min", "sor_ara", "myo_gla")

soi2 <- index_species$original[index_species$code %in% soi]
soi2 <- soi2[-7]
load_species(path="./data/SVGs/", soi = soi2)

euro_sp_country <- european_mammals(type="country", 
                 c("Spain", "France", "Czech_Republic", "Poland", "Norway", 
                                   "Germany", "United_Kingdom", "Sweden", "Finland"), 
                 soi=soi2, 
                 index_species=index_species, 
                 index_spatial=index_spatial2, 
                 mask="Sorex minutissimus")

study <- "butet2006"; years <- 1995; data <- read.csv(paste("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/", study, "/", study, "_meta_", years, ".csv", sep=""))

euro_sp_points <- european_mammals(type="points", 
                 data=data, 
                 soi=soi2, 
                 buffer <- 25000, 
                 index_species=index_species, 
                 index_spatial=index_spatial2, 
                 mask="Sorex minutissimus")


# make map of studies
laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
wgs84 <- c("+proj=longlat +datum=WGS84 +no_defs")
Europe_poly <- readOGR("./spatial/europe_country_borders.shp", "europe_country_borders")
Europe_line <- readOGR("./spatial/europe_country_borders_line.shp", "europe_country_borders_line")
crs(Europe_borders) <- laea

values500 <- read.csv("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/values_500_40.csv")
coordinates(values500) <- ~X+Y

par(mar=c(0, 0, 0, 0))
plot(Europe_line, lwd=.3)
plot(Europe_grid, lwd=.1, add=T)
points(values500, col="red", pch=3, cex=.4, lwd=.1)
