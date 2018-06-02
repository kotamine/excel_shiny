
# Server logic ----
server <- function(input, output) {
  
  map <- reactive({
    args <- switch(input$var,
                   "Percent White" = list("white", "darkgreen", "% White"),
                   "Percent Black" = list("black", "black", "% Black"),
                   "Percent Hispanic" = list("hispanic", "darkorange", "% Hispanic"),
                   "Percent Asian" = list("asian", "darkviolet", "% Asian"),
                   "Percent Native American" = list("native", "red", "% Native American"))
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
     do.call(my_percent_map, args)
    # my_percent_map(args[[1]], args[[2]], args[[3]])
  })
  
  output$map <- renderPlot({ map() })
  
  # Generate report 
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = paste0("report_example_",get_time_epoch(),".html"),
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(
        date_time = get_time_human(),
        var = input$var,
        range = input$range,
        map = map()
      )
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
}

