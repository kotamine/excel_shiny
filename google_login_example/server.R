
# server <-
  function(input, output, session){
    
    user_session <- reactiveValues()
    
    ## Create access token and render login button
    access_token <- callModule(googleAuth, 
                               "loginButton", 
                               login_text =  HTML('<i class="fa fa-google fa-1x"></i> Login with Google'),
                               logout_class = "btn btn-primary",
                               approval_prompt = "force")
    
    observeEvent(access_token, {
      if (!is.null(access_token()$credentials$access_token)) {
        # browser()  # check here to see if login was successful 
        token <- with_shiny(f = get_user_info, 
                            shiny_access_token = access_token())
        user_session$info  <- data.frame(token)
      } else {
        user_session$info <- NULL
      }
    })
    
    
    output$user_info <- renderUI({
      if (is.null(user_session$info)) return()
      
      user <- user_session$info
      
      div(HTML(
        paste("Dsiplay Name:", ems(user$displayName), '<br>',
              "Family Name:", ems(user$name.familyName), '<br>',
              "Given Name:", ems(user$name.givenName), '<br>',
              "Gender:", ems(user$gender),'<br>',
              "Organizations:", ems(user$organizations.name), '<br>',
              "Email Address:", ems(user$emails.value), '<br>'),
        paste0("<img src= '", gsub('?sz=50','',user$image.url[1]),"' width='100' height='100'>")
      )) 
    })
  }
