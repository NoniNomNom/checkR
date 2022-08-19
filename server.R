library(shiny)
library(lubridate)
library(DT)

daysfr <- function(x) {
  
  if (x == "Monday") {return("lundi")} else
    if (x == "Tuesday") {return("mardi")} else
      if (x == "Wednesday") {return("mercredi")} else
        if (x == "Thursday") {return("jeudi")} else
          if (x == "Friday") {return("vendredi")} else
            if (x == "Saturday") {return("samedi")} else
              if (x == "Sunday") {return("dimanche")} else
                
                return(x)
  
}

load("data/db.Rdata")

shinyServer(function(input, output, session) {
  
  rowsum <- reactive(sum(input$dbshow_rows_selected))
  
  valuebox <- reactive({
    
    if(input$box == FALSE) {
      return("Non")
    } else if (input$box == TRUE) {
      return("Oui")}
  })
  date <- reactive(today())
  
  output$date_txt <- renderText(paste0("Nous sommes le ", 
                                       daysfr(weekdays(date())), 
                                       " ", 
                                       format(date(), "%d"),
                                       "/",
                                       format(date(), "%m"),
                                       "/",
                                       format(date(), "%Y")))
  
  dbmaj <- reactiveVal(db)
  
  output$dbshow <- DT::renderDT(datatable(dbmaj(),
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
      print("ok")}
  })
  
  diff <- reactive({date() - head(dbmaj(), 1)$Jour})
  
  observe({
    
    if (diff() > 0) {
      
      db3 <- dbmaj()
      diff2 <- diff()
      
      for (i in 1:diff2) {
        
        x <- diff2 - 1
        print(x)
        db3 <- rbind(data.frame(Jour = date() - x, Pris = "Non"), db3)
        diff2 <- diff2 - 1
        dbmaj(db3)
        saveData(dbmaj())
        loadData()

      }

      print(diff())
      
    }
  })
  
}
)