about_text <- function() {
  bsModal("about-modal", 
          "About", 
          "btn-about", 
          size = "medium",
          about_content()
          )
}

about_content <- function() {
  div(id="about-text",
    tags$img(id="about-logo", src="img/Extension_Logo.png"),
    div(
    HTML('<h4>Tool Development</h4>
          William F. Lazarus<br>
          Professor and Extension Economist<br>
          wlazarus@umn.edu, 612-625-8150<br><br>
          Marcia Endres<br>
          Professor-Dairy Cattle Production<br>
          miendres@umn.edu, 612-624-5391<br><br>
          <h4>Web App Development</h4>
          Kota Minegishi<br>
          Dairy Analytics, Assistant Professor <br>
          Kota@umn.edu, 612-624-7455<br><br>
          Johnathan Nault<br>
          Web Developer<br>
          nault027@umn.edu, 952-913-3248<br><br>'))
    )
}