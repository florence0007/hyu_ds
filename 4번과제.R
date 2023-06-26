install.packages("palmerpenguins")

library(shiny)
library(palmerpenguins)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("species", "펭귄 종류", choices = unique(penguins$species)),
      selectInput("x_axis", "그림의 x축", choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
      selectInput("y_axis", "그림의 y축", choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
      sliderInput("point_size", "그림의 점 크기", min = 1, max = 10, value = 5)
    ),
    mainPanel(
      dataTableOutput("table"),
      plotOutput("plot")
    )
  )
)


server <- function(input, output) {
  filtered_data <- reactive({
    penguins[penguins$species %in% input$species, ]
  })
  
  output$table <- renderDataTable({
    filtered_data()
  })
  
  output$plot <- renderPlot({
    plot_data <- filtered_data()
    plot(plot_data[[input$x_axis]], plot_data[[input$y_axis]],
         pch = ifelse(plot_data$sex == "MALE", 1, 2),
         cex = input$point_size,
         xlab = input$x_axis, ylab = input$y_axis)
  })
}

shinyApp(ui, server)
