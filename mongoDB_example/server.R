
server <- 
  function(input, output, session) {
    
    rv <- reactiveValues(update_mdb_users =0)
    
    # create basic  user data when a session starts  
    usage_data <- data.frame(
      session_id = get_time_epoch(),
      start_time = get_time_human(),
      stop_time = NA,
      entered_data = 0
    )
    
    # pass a set of user inputs to UI side
    # (getting around mongodb functions interferring with updating inputs to defaults)
    output$user_inputs <- renderUI({
      # triggered by changes in "rv$update_mdb_users" or "selected_row()"
      rv$update_mdb_users
      
      # fill the input variables when a row in user table is selected 
      if (length(input$users_rows_selected)>0) {
        row <- selected_row() %>% as.list()
        tmp <- sapply(interest_choices, function(x) grepl(x, row$interests))
        row$interests_selected <- interest_choices[tmp]
      } else {
        row <- NULL
      }
      
      div(
        textInput("user_name","User Name", value = row$user_name),
        radioButtons("user_type", "User Type",
                     choices = c("academic", "industry", "student","other"),
                     selected = row$user_type),
        textInput("affiliation","Affiliation", value = row$affiliation),
        numericInput("years_aff","Years of Affiliation",
                     value= row$years_aff, step=1, min=0, max=50),
        selectInput("interests", "Interests",
                    choices = interest_choices, 
                    selected =  row$interests_selected,
                    multiple = T)
      )
    })
    
    # selected row in output$users 
    # see https://yihui.shinyapps.io/DT-rows/
    selected_row <- reactive({ 
      tbl_users()[input$users_rows_selected,, drop=FALSE] 
    })
    
    # add button 
    observeEvent(input$add, {
      if (usage_data$entered_data >0) return()
      
      usage_data$entered_data <<- usage_data$entered_data + 1
      
      addMongoRow(mdb_users, 
                  data.frame(
                    session_id = usage_data$session_id,
                    user_name = input$user_name,
                    user_type = input$user_type,
                    affiliation = input$affiliation,
                    years_aff = input$years_aff,
                    interests = paste(input$interests, collapse=", ")))
      
      rv$update_mdb_users <- rv$update_mdb_users + 1
    })
    
    # update button 
    observeEvent(input$update, {
      if (length(input$users_rows_selected)==0) return()
      
      fields <- c("user_name", "user_type", "affiliation", "years_aff", "interests")
      values <- c(input$user_name, input$user_type, input$affiliation, input$years_aff, 
                  paste(input$interests, collapse=", "))
      
      updateMongoField(mdb_users, 
                       'session_id', 
                       selected_row()$session_id, 
                       fields, values) 
      
      rv$update_mdb_users <- rv$update_mdb_users + 1
    })
    
    # delete button 
    observeEvent(input$delete, {
      if (length(input$users_rows_selected)==0) return()
      
      remove_item <- paste0('{"session_id":', selected_row()$session_id, '}')
      mdb_users$remove(remove_item)
      rv$update_mdb_users <- rv$update_mdb_users + 1
    })
    
    # buttons able/disable 
    observe({
      toggleState("add", length(input$users_rows_selected)==0 &  !is.null(input$user_name))
      toggleState("update", length(input$users_rows_selected)>0)
      toggleState("delete", length(input$users_rows_selected)>0)
    })
    
    # reactive tables 
    tbl_users <- reactive({
      input$add
      rv$update_mdb_users
      mdb_users$find("{}") %>% arrange(-session_id)
    })
    
    tbl_usage <- reactive({
      input$add
      mdb_usage$find("{}") %>% arrange(-session_id)
    })
    
    # render UI output
    output$usage_summary <- renderUI({
      usage <- tbl_usage() %>% 
        dplyr::mutate(start_time = as.POSIXct(start_time, origin = "1970-01-01"),
                      stop_time = as.POSIXct(stop_time, origin = "1970-01-01"))
      
      div(h4("Usage summary"),
          paste('Session numbers:', tbl_usage() %>% nrow()), br(),
          paste('Oldest access date:', min(usage$start_time)),  br(),
          paste('Mean access date:',  mean(usage$start_time)), br(),
          paste('Most recent access date:', max(usage$stop_time)))
    })
    
    # render DT 
    output$users <- renderDT({  tbl_users() }, 
                             server = TRUE, 
                             options = list(pageLength = 5),
                             selection = 'single')
    
    output$usage <- renderDT({ tbl_usage() }, 
                             options = list(pageLength = 5))
    
    # figures 
    output$fig_user_type <- renderPlot({  
      if (length(nrow(tbl_users()))==0) return()
      
      tbl_users() %>% 
        ggplot(aes(x=user_type, fill=user_type)) + geom_bar() +
        labs(title = "User Type")
    })
    
    output$fig_interests <- renderPlot({
      if (length(nrow(tbl_users()))==0) return()
      
      tmp <- tbl_users() %>% dplyr::mutate(Crop = grepl('Crop', interests),
                                           Livestock = grepl('Livestock', interests),
                                           Value_Chain = grepl('Value Chian', interests),
                                           Global_Trade = grepl('Global Trade', interests),
                                           Econ_Theory = grepl('Economic Theory', interests),
                                           Econometrics = grepl('Econometrics', interests),
                                           Programming = grepl('Programming', interests)) %>%
        gather(key = interests_item, value = interest_val,
               -session_id, -user_name, -user_type,
               -interests, -affiliation, -years_aff)
      
      tmp %>%
        filter(interest_val==TRUE) %>%
        ggplot(aes(x = interests_item, fill = interests_item)) + geom_bar() +
        facet_wrap(~ user_type) +
        theme(axis.text.x = element_text(angle = 25, vjust = .5)) +
        labs(title = "Interests by User Type")
    })
    
    # This code will be run after the client has disconnected
    session$onSessionEnded(function() {
      usage_data$stop_time <<- get_time_human() 
      addMongoRow(mdb_usage, usage_data) 
    })
    
  }