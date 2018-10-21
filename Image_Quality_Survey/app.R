# A survey designed to randomly selected filtered images to present to a survey participant
# Created by Aidan Draper

library(shiny)
library(shinythemes)
library(googlesheets)
library(ggplot2)

ui <- fluidPage(
  
  theme = shinytheme("slate"),

  conditionalPanel(condition="input.ack==0",
       br(),
       img(src='elon-sig.png', width = 300, height =100, align= "left"),
       titlePanel("STS 499: Image Quality Loss Survey"),
       br(),
       br(),
       textOutput("ack1"),
       br(),
       actionButton("ack","Acknowledge")
  ),
  
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
                  br(),
                  textOutput("note2"),
                  br()
           ),
           column(12,
                  img(src='true_state.jpg', width = 900, height =600),
                  br(),
                  br()
           )
         )
      ),
      tabPanel("Filtered Image",
        fluidRow(
          column(12,
             br(),
             conditionalPanel(condition="input.submit==0",textOutput("note")),
             br()
          ),
          column(12,
             imageOutput("filtered",width = 900, height =600)
             #img(src=output$selectedImage, width = 900, height =600)
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
    values$img.num <- sample(img.options,1)
    
    values$img.src <- ''
    if (values$img.num == 1){
      values$img.src <- 'tbd.jpg'
    } else if (values$img.num == 2){
      values$img.src <- 'filtered_cv2-bilateral.jpg'
    } else if (values$img.num == 3){
      values$img.src <- 'filtered_cv2-nonlocal.jpg'
    } else if (values$img.num == 4){
      values$img.src <- 'tbd.jpg'
    } else if (values$img.num == 5){
      values$img.src <- 'tbd.jpg'
    } else if (values$img.num == 6){
      values$img.src <- 'IMG_0692_lr.jpg'
    }

  })
  
  output$filtered <- renderImage({
    cat(values$img.src)
    return(list(
      src = paste('www/',values$img.src,sep=''),
      width = 900,
      height = 600,
      contentType = "image",
      alt = "Filtered"
    ))
    
    #img(src=output$selectedImage, width = 900, height =600)
  })
  
  output$hide_panel <- eventReactive(input$num_input, TRUE, ignoreInit = TRUE)
  
  outputOptions(output, "hide_panel", suspendWhenHidden = FALSE) 
  
  output$ack1 <- renderText({
    if(input$ack[1] == 0){
      paste("Thank you for taking the time to participate in our research study.  
            In this study, you will be asked to view several versions of the same image 
            (a night scene) and report a score on a scale of 1 to 10 for how well the image 
            represents an unaltered version.  We expect this survey will take approximately 
            3 minutes or less to complete.  The only data we will collect are your four numerical 
            scores of the images.  Your course instructor has agreed to share this link with you, 
            but they will not know if you agree to participate in this study.  Your participation is 
            completely voluntary, and you may choose to close the browser without submitting your 
            answers at any time.  There are no incentives for participation.  If you have any questions 
            about this study, please feel free to contact Dr. Laura Taylor (ltaylor18@elon.edu) or 
            Aidan Draper (adraper2@elon.edu).  Please click “Acknowledge” to indicate you have read this 
            statement and agree to participate in the study.")
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
      gs_add_row(ss=gs_title("survey_results"),ws = "Sheet1", input = c(values$img.num, input$score))
      paste("Thanks for submitting!")
    }
  })
  
  output$note <- renderText({
    paste("Scroll down to give the image a score from 1 (does not represent photo) to 10 (exact copy).")
  })
  
  output$note2 <- renderText({
    paste("Click on the \"Filter Image\" tab after analyzing this photo.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

