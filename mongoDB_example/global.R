library(shiny)
library(mongolite)
library(shinythemes)
library(DT)
library(ggplot2)
library(dplyr)
library(tidyr)
library(shinyjs)

# set up database and database user at mlab.com 
host <- "ds139920.mlab.com:39920" 
username <- "user2018"
password <- "user2018"
db <- "mlab_example"

url <- paste0("mongodb://",username,":",password,"@", host, "/",db)

# connect to mlab's database 
mdb_users <- mongo(collection="users", db=db, url = url)
mdb_usage <-  mongo(collection="usage", db=db, url = url)

## example of mongo query 
# usage <- mdb_usage$find("{}")
# nrow(usage)
# usage <- usage %>% dplyr::mutate(start_time = as.POSIXct(start_time, origin = "1970-01-01"))
# min(usage$start_time)
# usage %>% ggplot(aes(x=start_time)) + geom_histogram(color="white")

# get current Epoch time
get_time_epoch <- function() {
  return(as.integer(Sys.time()))
}

# get human friendly time
get_time_human <- function() {
  format(Sys.time(), "%Y-%m-%d-%H:%M:%OS")
}


# Function to add a row in mongodb 
addMongoRow <- function(mongodb,field_data) {
  if(length(colnames(field_data)) != ncol(field_data)) {
    stop('length(colnames(field_data)) != ncol(field_data)')
  }
  
  new_row <- data.frame(field_data) 
  mongodb$insert(new_row)  
}


# Update functions for mongodb
updateMongoField <- function(mongodb, id_field, id_value, fields, values) {
  
  tmp_id <- ifelse(is.numeric(id_value), 
                   paste0('{"',id_field,'": ', id_value,'}'),
                   paste0('{"',id_field,'": "', id_value,'"}'))
  
  if (length(fields)==1) {
    mongodb$update(tmp_id, paste0('{"$set": {"', fields,'":"', values,'"} }'))
  } else {
    df <- to_df(fields, values)
    tmp_update <- fieldSet(df)
    mongodb$update(tmp_id, tmp_update)
  }
}

to_df <- function(fields, values) {
  mat <- matrix(values, nrow=1) 
  colnames(mat) <- fields  
  data.frame(mat, stringsAsFactors=FALSE)
}


fieldSet <- function(df, set=TRUE) {
  fields=colnames(df)
  values=matrix(df[1,], nrow=1, dimnames=NULL)
  
  if (length(fields)!=length(values)) stop("length(field)!=length(value")
  
  tmp <- '{'  
  lapply(seq_along(fields), function(i) {
    if (is.numeric(values[i])) {
      tmp <<- paste0(tmp,'"', fields[i],'":', values[i]) 
    }  else {
      tmp <<- paste0(tmp,'"', fields[i],'":"', values[i],'"') 
    }
    if (i<length(fields)) tmp <<- paste0(tmp, ', ')
  }) 
  tmp <- paste0(tmp, '}')
  if (set)   tmp <- paste0('{"$set":', tmp, '}')  
  tmp
} 

# predetermined variable
interest_choices <- c("Crop","Livestock","Value Chain","Global Trade",
                      "Economic Theory", "Econometrics", "Programming")

