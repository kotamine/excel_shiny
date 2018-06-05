
# ui <- 
  fluidPage(
    h2("Google Login Authentication Example"),
    googleAuthUI("loginButton"),
    uiOutput("user_info")
  )

