check_data <- function(data, index=NULL, column=NULL, mask=NULL){
  
  old <- NULL; new <- NULL
  
  for(i in 1:length(data)){
    if(exists(data[i])){
      old <- c(old, data[i])
      next
    } else{
      if(!is.null(index)){
        if(any(as.character(index$code) == data[i])){
          orig <- eval(parse(text=paste("index$", column, "[index$code==data[i]]", sep="")))
          if(!is.null(mask)){
            orig <- orig[!orig %in% mask]
          }
          if(exists(orig)){
            new <- c(new, orig)
          } else{
            warning(paste("'", orig, "' does not seem to be defined. Please check if the species is loaded into the environment or built an index with correct names and relations (build_index()).", sep=""))
          }
        } else{
          warning(paste("'", data[i], "' does not seem to be defined. Please check if the species name is given correctly or built an index with correct names and relations.", sep=""))
        }
        
      } else{
        warning(paste("'", data[i], "' is not specified properly, it will not be processed. \n Use 'build_index()' and use the output in 'species_ind = ' to help with this or give the respective name in 'soi' which is defined already.", sep=""))
      }
    }
  }
  data2 <- c(old, new)
  return(data2)
}
