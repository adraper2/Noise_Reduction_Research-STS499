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
       p("Thank you for taking the time to participate in our research study.  
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
        statement and agree to participate in the study."),
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
    # training portion
    conditionalPanel("input.train==0 && input.ack && !output.hide_panel",
      tabsetPanel(type = "tabs",
        tabPanel("Instructions",
           fluidRow(
             column(12,
                # insert instructions
                h4("Instructions:"),
                p("1.   View the \"True Image\"."),
                p("2.   Click on \"Image One\".  Rate the quality of Image One compared to the True Image using the slider bar at the bottom of the page.  10 = Superior quality compared to true image, 5 = Equal quality to true image, and 0 = Poor quality compared to true image. A zoomed-in portion of the image has been provided for comparison purposes."),
                p('3.   Click on \"Image Two\". Using the same scale, rate the image using the scroll bar at the bottom of the page.'),
                p("4.   Click on \"Image Three\".  Using the same scale, rate the image using the scroll bar at the bottom of the page."),
                p('5.   Click \"Submit Part 1\" under \"Image Three\" to continue to Part 2.'),
                br(),
                br()
             )
           )
        ),
        tabPanel("True Image",
          fluidRow(
            column(12,
              img(src='shoes_true.jpg', width = 900, height =600),
              br(),
              br()
            )
          )
        ),
        tabPanel("Image One",
           fluidRow(
             column(12,
                img(src='shoes_noise.jpg', width = 900, height =600),
                br(),
                br()
             ),
             column(4,
                sliderInput(inputId="train.score1",label="Image One Quality Score",0,10,5,1)
             )
           )
        ),
        tabPanel("Image Two",
           fluidRow(
             column(12,
                img(src='shoes-bilateral.jpg', width = 900, height =600),
                br(),
                br()
             ),
             column(4,
                sliderInput(inputId="train.score2",label="Image Two Quality Score",0,10,5,1)
             )
           )
        ),
        tabPanel("Image Three",
           fluidRow(
             column(12,
              img(src='shoes_true.jpg', width = 900, height =600),
              br(),
              br()
             ),
             column(4,
               sliderInput(inputId="train.score3",label="Image Three Quality Score",0,10,5,1)
             ),
             column(8,
               actionButton("train","Submit Part 1")
             )
           )
        )
      )
    ),
    # actual survey
    conditionalPanel("input.train && input.ack && !output.hide_panel",
      tabsetPanel(type = "tabs",
        tabPanel("Instructions",
           fluidRow(
             column(12,
                # insert instructions
                h4("Instructions:"),
                p("1.   View the \"True Image\"."),
                p("2.   Click on \"Filtered Image\".  Rate the quality of Image One compared to the True Image using the slider bar at the bottom of the page.  10 = Superior quality compared to true image, 5 = Equal quality to true image, and 0 = Poor quality compared to true image.  A zoomed-in portion of the image has been provided for comparison purposes."),
                p('3.   Click on \"Submit Part 2\" to submit your response. (Wait for the \"Thanks for submitting!\" message before closing your browser.)'),
                p("4.   Close your browser."),
                br(),
                br()
             )
           )
        ),
        tabPanel("True Image",
           fluidRow(
             column(12,
                    br(),
                    textOutput("note2"),
                    br()
             ),
             column(12,
                    img(src='street_true.jpg', width = 900, height =600),
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
              conditionalPanel(condition="input.submit==0",sliderInput(inputId="score",label="Image Quality Score",0,10,5,1))
            ),
            column(8,
              conditionalPanel(condition="input.submit==0",br(),br(),actionButton("submit","Submit Part 2")),
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
)

server <- function(input, output, session) {
  
  values <- reactiveValues()
  
  render.google <- reactive({
    gs_auth()
    results.df <- gs_read(gs_key("1ZJiwEa-tObwH0zTmWqEqwqxihwS1X0BncxzBgG75TCI"))
    
    # calculate current image options to sample from (need to catch for over 120 obs.)
    #img.options <- rep(1:6,20)
    img.options <- rep(c(2,3,5,6),20)
    
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
      values$img.src <- 'street-bilateral.jpg'
    } else if (values$img.num == 3){
      values$img.src <- 'street-nonlocal.jpg'
    } else if (values$img.num == 4){
      values$img.src <- 'tbd.jpg'
    } else if (values$img.num == 5){
      values$img.src <- 'street_lr50.jpg'
    } else if (values$img.num == 6){
      values$img.src <- 'street_lr100.jpg'
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
  }, deleteFile = FALSE)
  
  output$hide_panel <- eventReactive(input$num_input, TRUE, ignoreInit = TRUE)
  
  outputOptions(output, "hide_panel", suspendWhenHidden = FALSE) 
  
  output$ack1 <- renderText({
    if(input$ack[1] == 0){
      paste("")
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
      gs_add_row(ss=gs_title("survey_results"),ws = "Sheet1", input = c(values$img.num, input$score, input$train.score1, input$train.score2, input$train.score3))
      paste("We just recieved your response. Thanks for submitting!")
    }
  })
  
  output$note <- renderText({
    paste("Scroll down to give the image a score.")
  })
  
  output$note2 <- renderText({
    paste("Click on the \"Filter Image\" tab after analyzing this photo.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

