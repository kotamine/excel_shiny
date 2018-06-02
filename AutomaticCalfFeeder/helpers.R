# color of tabs in Data Entry etc.

zeros <- function(r,c) matrix(c(mat.or.vec(r,c)),nrow=r,ncol=c) 
ones <- function(r,c) matrix(c(rep(1,r*c)),nrow=r,ncol=c) 
nulls <- function(r,c) matrix(c(rep(NA,r*c)),nrow=r,ncol=c)

myCapitalize <- function(textvec) {
  gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", textvec, perl=TRUE)
} 


my_add_row <- function(A,a) {
  # A: data.frame
  # a: row vector that is going to be appended to A   
  A <- as.matrix(A)
  A <- rbind(A,a)
  data.frame(A)
}

round_pct <- function(x, digits=2) { 
  paste0(round(x,digits),"%")
} 


formatcomma <- function(x, digits=NULL, dollar=FALSE) {
  if (length(x)==0) { return(NA) }
  if (is.null(digits)) {
    xFormat <- format(x, big.mark=",", scientific=FALSE) 
  } else {
    xFormat <- format(round(x,digits), big.mark=",", scientific=FALSE) 
  }
  if (dollar) { xFormat <- paste0("$", xFormat) }
  return(xFormat)
} 

formatdollar <- function(x,digit=0) {
  if (length(x)==0) { return(NA) }
  if (x>=0) {
    paste0("$",x %>% round(digit) %>% formatcomma()) 
  } else {
    paste0("-$",-x %>% round(digit) %>% formatcomma()) 
  }
}

gen_formatdollar <- function(digit=0) {
  function(x) {
    if (length(x)==0) { return(NA) }
    if (x>=0) { 
      paste0("$",x %>% round(digit) %>% formatcomma()) 
    }  else {
      paste0("-$",-x %>% round(digit) %>% formatcomma())
    }
  }
}

formatdollar_2d <- gen_formatdollar(2)
# formatdollar_2d(-12.345)

formatdollar2 <- function(x,digit=0) { # add +/- sign
  if (is.na(x)) { return(NA) }
  if (is.null(x)) { return(NA) }
  if (x>=0) {
    paste0("+$",x %>% round(digit) %>% formatcomma()) 
  } else {
    paste0("-$",-x %>% round(digit) %>% formatcomma()) 
  }
}

formatdollar2b <- function(x,digit=0) { # add parenthesis 
  if (is.na(x)) { return(NA) }
  if (is.null(x)) { return(NA) }
  if (x>=0) {
    paste0("(+$",x %>% round(digit) %>% formatcomma(),")") 
  } else {
    paste0("(-$",-x %>% round(digit) %>% formatcomma(),")") 
  }
}

# 
# df_null <- function(colnames) {
#   dummy <- matrix(rep(NA,length(colnames)),nrow=1)
#   colnames(dummy) <- colnames 
#   empty_table <- data.frame(Column1 = numeric(0)) 
#   empty_table <- rbind(empty_table, dummy)[NULL,] 
#   empty_table
# }



