ui <- fluidPage(
  
  tags$style("
      .checkbox {
        line-height: 100px;
        margin-bottom: 30px; 
      }
      input[type='checkbox']{ 
        width: 100px; /*Desired width*/
        height: 100px; /*Desired height*/
        line-height: 100px; 
      }
      span { 
          margin-left: 50px;
          line-height: 30px; 
      }
  "),
  
  titlePanel("LE MEDICAMENT"),
  column(12, 
         align = "center",
         textOutput("date_txt")),
  column(12, 
         align = "center",
         checkboxInput("box", "", FALSE)),
  column(12, 
         align = "center",
         actionButton("valider", "Valider")),
  dataTableOutput("dbshow")
)