library(shiny)
library(googleAuthR) 
library(googleID)
# remotes::install_github("MarkEdmondson1234/googleID") 

# Google login authentication: -----------------------

# for the first time, set up your CLIENT ID 
# https://console.developers.google.com/apis

CLIENT_ID      <- "256934643886-8pnre1d6e4o7rgm941cnb9ehq43dlk63.apps.googleusercontent.com"
CLIENT_SECRET  <- "Kk1v2MPAI-6DXF22v60B4o1t"

# CLIENT_URL     <-  "https://kotamine.shinyapps.io/google_login_example/"
# CLIENT_URL     <-  'http://127.0.0.1:4488'  # URL on my desktop
CLIENT_URL     <-  'http://localhost:4488'   # URL on my desktop
# Run this as: shiny::runApp(port=4488) on desktop 

options("googleAuthR.webapp.client_id" = CLIENT_ID)
options("googleAuthR.webapp.client_secret" = CLIENT_SECRET)
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/userinfo.email",
                                          "https://www.googleapis.com/auth/userinfo.profile"))


# googleAuthR::gar_auth()

ems <- function(txt) em(strong(txt)) 

