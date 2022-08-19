library(shiny)
library(lubridate)
library(DT)

load("data/db.Rdata")

server <- function(input, output, session) {
  
  rowsum <- reactive(sum(input$dbshow_rows_selected))
  
  valuebox <- reactive({
    
    if(input$box == FALSE) {
      return("Non")
    } else if (input$box == TRUE) {
      return("Oui")}
  })
  date <- reactive(today())
  
  output$date_txt <- renderText(paste0("Nous sommes le ", 
                                       weekdays(date()), 
                                       " ", 
                                       format(date(), "%d"),
                                       "/",
                                       format(date(), "%m"),
                                       "/",
                                       format(date(), "%Y")))
  
  dbmaj <- reactiveVal(db)
  
  output$dbshow <- renderDT(datatable(dbmaj(),
                                      options = list(dom = 'tpl')) %>% formatStyle(
                                        'Pris',
                                        target = 'row',
                                        backgroundColor = styleEqual(c("Non", "Oui"), c('red', 'lightgreen'))
                                      )
  ) 
  
  saveData <- function(db) {
    save(db, file = "data/db.Rdata")
  }
  
  loadData <- function() {
    db <- load("data/db.Rdata")
    db
  }
  
  observeEvent(input$valider, {
    
    if (rowsum() > 0) {
      
      db1 <- dbmaj()
      db1[input$dbshow_rows_selected, "Pris"] <- valuebox() 
      dbmaj(db1)
      saveData(dbmaj())
      loadData()
      print(rowsum())
      
    } else {
      
      db2 <- dbmaj()
      db2[1, "Pris"] <- valuebox()
      dbmaj(db2)
      saveData(dbmaj())
      loadData()
      print("ok") }
  })
  
  observe({
    
    if (date() > head(dbmaj(), 1)$Jour) {
      db3 <- dbmaj()
      db3 <- rbind(data.frame(Jour = date(), Pris = "Non"), dbmaj())
      dbmaj(db3)
      saveData(dbmaj())
      loadData()
      print("ok")
      
    }
  })
}