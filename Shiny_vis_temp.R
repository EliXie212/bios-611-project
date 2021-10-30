library(shiny)

heart <- read.csv("heart.csv")

## List of column name for drop down
metric_cont <- c("age", "chol", 'trestbps', 'oldpeak')


ui <- shinyUI(fluidPage(
  
  titlePanel("Heart Disease Visualization"),
  plotOutput('distPlot'),
  hr(),
  fluidRow(
    
    ## Metric Selection
    column(4,
             sidebarPanel(width = 12,
               selectInput('metric', 'Continuous Metric', metric_cont, selected = metric_cont[[2]])
              ),
    ),
    
    ## Bin Number Control
    column(8,
             sidebarPanel(width = 12,
                 sliderInput("bins",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30)
             ),
          )
  )
 )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x_1 <- heart[heart$target == 1, ][, input$metric]
        x_2 <- heart[heart$target == 0, ][, input$metric]
        
        
        min_v = min(min(x_1), min(x_2))
        max_v = max(max(x_1), max(x_2))
        
        bins <- seq(min_v, max_v, length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hg_1 = hist(x_1, breaks = bins, plot=FALSE)
        hg_2 = hist(x_2, breaks = bins, plot=FALSE)
        
        ## Specify colors
        c1 <- rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue")
        c2 <- rgb(255,192,100, max = 255, alpha = 80, names = "lt.pink")
        
        
        plot(hg_1, col=c1, main='Heart Disease Visualization', xlab='chol')
        plot(hg_2, col=c2, add=TRUE)
        legend("topright",   # Position
               inset = 0.05,
               legend = c("Heart Disease", "Healthy"),
               fill = c(c1, c2))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
