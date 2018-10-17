# A survey designed to randomly selected filtered images to present to a survey participant
# Created by Aidan Draper

library(shiny)
library(shinythemes)
library(googlesheets)
library(ggplot2)

ui <- fluidPage(
  
  theme = shinytheme("slate"),

  textOutput("ack1"),
  conditionalPanel(condition="input.ack==0",actionButton("ack","Acknowledge")),
  
  conditionalPanel("input.ack && !output.hide_panel", 
    fluidRow(
      column(1.5,
         # Application title
         img(src='elon-logo.png', width = 100, height =100, align= "left")
      ),
      column(10.5,
         titlePanel("STS 499: Image Quality Loss Survey")  
      )
    ),
    tabsetPanel(type = "tabs",
      tabPanel("True Image"
               ),
      tabPanel("Filtered Image",
        fluidRow(
          column(12,
            img(src='IMG_0692_lr.jpg', width = 900, height =600)
          ),
          column(4,
            br(),
            conditionalPanel(condition="input.submit==0",sliderInput(inputId="score",label="Image Quality Score",1,10,5,1))
          ),
          column(8,
            conditionalPanel(condition="input.submit==0",br(),br(),actionButton("submit","Submit")),
            br(),
            br(),
            textOutput("submission")
          ),
          column(12,
            conditionalPanel(condition="input.submit==0",textOutput("note")),
            br(),
            br()
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
   
  
  #output$show.button <- FALSE
  
  values <- reactiveValues()
  
  output$hide_panel <- eventReactive(input$num_input, TRUE, ignoreInit = TRUE)
  
  outputOptions(output, "hide_panel", suspendWhenHidden = FALSE) 
  
  output$ack1 <- renderText({
    if(input$ack[1] == 0){
      paste("Insert paragraph about survey.")
    } else{
      paste("")
    }
  })
  
  output$submission <- renderText({
    if(input$submit[1] == 0){
      # add google sheets submission line
      paste("")
    } else{
      paste("Thanks for submitting!")
    }
  })
  
  output$note <- renderText({
    paste("Note: You should base this on how well this image represents the true image.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

