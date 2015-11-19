load_species <- function(path=getwd(), soi=NULL){
  
  pb <- txtProgressBar(min = 0, max = length(soi), style = 3, char=">", width=getOption("width")-14)
  
  for(i in 1:length(soi)){
    # read in *.svg of i-th species of interest
    txt <- suppressWarnings(readLines(paste(path, "/SVGs/", soi[i], ".svg", sep="")))
    
    # throw out uninteresting lines
    txt <- txt[grep("use id=", txt)]
    txt <- sub('<use id=\"', "", txt)
    txt <- sub('\"', "", txt)
    txt <- sub('xlink:href=\"', "", txt)
    txt <- sub('#', "", txt)
    txt <- sub('\"/>', "", txt)
    
    # strip down text to desired data
    l1 <- strsplit(txt, " ")
    df <- as.data.frame(t(as.data.frame(l1)))
    df <- df[-c(2, 3)]                                                # throw out columns 2 and 3. They seem to contain
                                                                      # coordinates, but they are only valid relative
                                                                      # the borders of the svg-files and can't be geo-
                                                                      # referenced.
    rownames(df) <- NULL
    colnames(df) <- c("SQ", "occ")
    assign(eval(soi[i]), df, envir = .GlobalEnv)
    
    setTxtProgressBar(pb, i)
    
  }
  close(pb)
  
  return(soi)
}