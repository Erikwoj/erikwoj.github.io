# Required packages
library(shiny)
library(quantmod)

# Define UI
ui <- fluidPage(
  titlePanel("Apple Stock Price Visualization"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", label = "Date Range", start = "2000-01-01", end = Sys.Date()),
      submitButton("Update")
    ),
    mainPanel(
      plotOutput("stock_plot")
    )
  )
)

# Define server
server <- function(input, output) {
  # Load Apple stock data
  stock_data <- reactive({
    getSymbols("AAPL", src = "yahoo", from = input$date_range[1], to = input$date_range[2], auto.assign = FALSE)
  })
  
  # Convert stock data to xts object
  stock_xts <- reactive({
    xts::as.xts(stock_data())
  })
  
  # Generate stock price plot
  output$stock_plot <- renderPlot({
    chartSeries(stock_xts(), theme = "white")
  })
}




# Run the app
shinyApp(ui = ui, server = server)



