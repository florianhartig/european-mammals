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
            warning(paste("'", orig, "' is not available and can't be processed.\n   Either '", orig, "' is not loaded into the environment or the index for this object is not defined properly.", sep=""))
          }
        } else{
          warning(paste("'", data[i], "' is not available and can't be processed.\n   Either '", data[i], "' is not loaded into the environment or the index for this object is not defined properly.", sep=""))
        }
        
      } else{
        warning(paste("'", data[i], "' is not available and can't be processed.\n   Provide correct names or and index which gives relations between abbreviations and correct names (build_index()).", sep=""))
      }
    }
  }
  data2 <- c(old, new)
  return(data2)
}
