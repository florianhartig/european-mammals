european_mammals <- function(type=c("points", "polygon", "country", "identify"), 
                             data, buffer=NULL, soi=NULL, 
                             index_species=NULL, index_spatial=NULL, mask=NULL){
  
  # debugging:
  #   path <- setwd("/home/steffen/Documents/git/European Mammals/data/")
  #   type <- "country"
  #   # data <- c("Spain", "France", "Czech_Republic", "Poland", "Norway", "Germany", "United_Kingdom", "Sweden", "Finland")
  #   # data for 'points
  #   study <- "butet2006"; years <- 1995
  #   data <- read.csv(paste("/home/steffen/Documents/git/PhD/small mammals and the landscape/data/", study, "/", study, "_meta_", years, ".csv", sep=""))
  #   buffer <- NULL
  #   soi <- soi2
  #   index_species <- index_species
  #   index_spatial <- index_spatial2
  #   mask <- "Sorex minutissimus"
  #   the_grid <- France_grid
  
  # type            chose which type the data have. The choice is between coordinates (points), one polygon (polygon), a
  #                 set of countries (country) or some shape drawn on the current plot (identify).
  # data            give here the respective data, as defined in 'type'.
  #                   - 'points' should be a data-frame with two (3) columns named 'X/lon', 'Y/lat' and optinally 'SQ'
  #                     with the respective names of the AFE-grid the coordinates are located in.
  #                   - 'polygon' should be an already defined polygon or the path to a shapefile which can be read in via
  #                     readShapePoly().
  #                   - 'country' should be a set of country names. Can be abbreviated, see build_index().
  #                   - 'identify' should be the number of clicks on the current graph. Must be at least 3.
  #                 All spatial data should be loaded into the environment already, otherwise a warning will appear and
  #                 only the already loaded data will be used.
  # buffer          meters around which the data should be buffered. One grid of the AFE-grid has an extent of 50kmx50km.
  # soi             name of species to get information for. Can be abbreviated but than and index should be built
  #                 (build_index()) or the species should be defined and loaded into the environment with their
  #                 abbreviated names. 
  # index_species   give index where abbreviations in 'soi' and their original names are given.
  # index_spatial   
  # mask            give the names of species here, which should be excluded from any querry. Must be defined as full 
  #                 species name as given by the original data.
  
  laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

  type <- match.arg(type, c("points", "polygon", "country", "identify"))
  
  if(type=="identify" & attr(dev.cur(), "name")=="null device"){
    stop("please plot some map from which you want to select an area first.")
  }
  if(type=="points" & (!(any(colnames(data)=="X") | any(colnames(data)=="lon")) | !(any(colnames(data)=="Y") | any(colnames(data)=="lat")))){
    stop("please give a dataframe which has at least two columns names 'X or lon' and 'Y or lat'.")
  }
  
  occurences <- NULL
  check_data(data = soi, index = index_species, column = "original", mask = mask)
  
  
  # the_grid <- define polygon which can be used here.
  # Europe_grid <- spChFIDs(Europe_grid, as.character(Europe_grid$Name))
  
  if(type == "points"){
    
    c1 <- suppressWarnings(check_data("Europe_grid", index = index_spatial, column = "grid"))

    if(!is.null(c1)){
      Europe <- get(c1)
      Europe <- Europe[-c(which(duplicated(Europe$Name))),]
      Europe <- spChFIDs(Europe, as.character(Europe$Name))
    } else{
      stop("Please read in the AFE-grid for whole Europe or specify a subset of countries to intersect with the given coordinates.")
    }
    
    coordinates(data) <- ~X+Y
    crs(data) <- laea
    
    for(j in 1:dim(data)[1]){
      
      if(!is.null(buffer)){
        data_buffered <- gBuffer(data[j,], byid=FALSE, width = buffer, quadsegs = 5)
        square <- gIntersection(Europe, data_buffered, byid = TRUE)
        square_names <- c(unlist(lapply(strsplit(names(square), " "), function(x) x[[1]])))
      } else{
        square <- gIntersection(Europe, data, byid = TRUE)
        square_names <- c(unlist(lapply(strsplit(row.names(square), " "), function(x) x[[1]])))
      }
      
      for(k in 1:length(soi2)){
        
        species <- get(soi2[k])
        species$SQ <- as.character(species$SQ)
        species_sub <- species[species$SQ %in% square_names,]
        ds <- dim(species_sub)[1]
        occurences_temp <- cbind(point=rep(j, ds), species=rep(soi2[k], ds), species_sub)
        occurences <- rbind(occurences, occurences_temp)
        
      }
      
      occurences$SQ <- as.factor(occurences$SQ)
      
    }
    
  } else if(type == "polygon"){
    
    stop("nothing defined here yet")
    if(!is.null(buffer)){
      data <- gBuffer(data, width = buffer, capStyle = "SQUARE", quadsegs = 1)
    }
    
  } else if(type == "country"){
    
    check_data(data, index = index_spatial, column = "grid")
    
    for(j in 1:length(data)){
      
      if(exists(data[j])){
        country_name <- data[j]
        country <- get(country_name)
      } else{
        country_name <- index_spatial$grid[index_spatial$code==data[j]]
        country <- get(country_name)
      }
      country <- spChFIDs(country, as.character(country$Name))
      
      crd <- coordinates(country)
      crd <- as.data.frame(crd)
      crd <- cbind(crd, country@data$Name)
      colnames(crd) <- c("X", "Y", "SQ")
      
      for(k in 1:length(soi2)){
        
        species <- get(soi2[k])
        species$SQ <- as.character(species$SQ)
        species_sub <- species[species$SQ %in% crd$SQ,]
        # species_sub <- join(crd, species, by="SQ")
        ds <- dim(species_sub)[1]
        occurences_temp <- cbind(country=rep(data[j], ds), species=rep(soi2[k], ds), species_sub)
        occurences <- rbind(occurences, occurences_temp)
        
      }
      
      occurences$SQ <- as.factor(occurences$SQ)
      
    }
    
  } else if(type == "identify"){
    
    stop("nothing defined here yet")
    if(!is.null(buffer)){
      data <- gBuffer(data, width = buffer, capStyle = "SQUARE", quadsegs = 1)
    }
    
  }
  
  # plotting functions for the object which comes from this function.
  # since the output contains column 'SQ' and since there are spatial information available which also contain this
  # column, both of them can be joined. Than subsets for column 'occ'. These subsets will be spatial objects which can
  # be plotted.
#   crd <- coordinates(France_grid)
#   crd <- as.data.frame(crd)
#   crd <- cbind(crd, France_grid@data$Name)
#   colnames(crd) <- c("X", "Y", "SQ")
#   
#   apo_fla_est <- join(crd, `Apodemus flavicollis`, by="SQ")
#   coordinates(apo_fla_est) <- ~X+Y
#   crs(apo_fla_est) <- laea
#   
#   apo_fla_pre70_1 <- subset(apo_fla_est, apo_fla_est$occ=="pre70_1")
#   apo_fla_post70_1 <- subset(apo_fla_est, apo_fla_est$occ=="post70_1")
#   apo_fla_pre70_2 <- subset(apo_fla_est, apo_fla_est$occ=="pre70_2")
#   apo_fla_post70_2 <- subset(apo_fla_est, apo_fla_est$occ=="post70_2")
#   
#   plot(France_grid)
#   points(apo_fla_post70_1, pch=16, cex=1)
  return(occurences)
  
}


