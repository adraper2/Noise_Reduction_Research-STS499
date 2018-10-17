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
      tabPanel("True Image",
         fluidRow(
           column(12,
                  img(src='true_state.jpg', width = 900, height =600)
           ),
           column(12,
                  br(),
                  br(),
                  textOutput("note2"),
                  br(),
                  br()
           )
         )
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
  
  values <- reactiveValues()
  
  render.google <- reactive({
    gs_auth()
    results.df <- gs_read(gs_key("1ZJiwEa-tObwH0zTmWqEqwqxihwS1X0BncxzBgG75TCI"))
    
    # calculate current image options to sample from (need to catch for over 120 obs.)
    img.options <- rep(1:6,20)
    
    for(x in 1:length(results.df$img_num)){
      if (is.na(match(results.df$img_num[x], img.options))==FALSE){
        img.options <- img.options[-match(results.df$img_num[x], img.options)]
      }
    }
    
    #current image being used (1-6)
    img.num <- sample(img.options,1)
  })
  
  output$hide_panel <- eventReactive(input$num_input, TRUE, ignoreInit = TRUE)
  
  outputOptions(output, "hide_panel", suspendWhenHidden = FALSE) 
  
  output$ack1 <- renderText({
    if(input$ack[1] == 0){
      paste("Insert paragraph about survey.")
    } else{
      render.google()
      paste("")
    }
  })
  
  output$submission <- renderText({
    if(input$submit[1] == 0){
      paste("")
    } else{
      # submit score
      gs_add_row(ss=gs_title("survey_results"),ws = "Sheet1", input = c(6, input$score))
      paste("Thanks for submitting!")
    }
  })
  
  output$note <- renderText({
    paste("Note: You should base this on how well this image represents the true image.")
  })
  
  output$note2 <- renderText({
    paste("Click on the \"Filter Image\" tab after analyzing this photo.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

