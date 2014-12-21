library(shiny)

fig.width <- 600
fig.height <- 300

shinyUI(pageWithSidebar(
  
  headerPanel("Simulate t test"),
  
  sidebarPanel(
    
    div(p("Simulate t tests using Effect Size, Sample Size, Total Simulations and SD as input")),
    
    div(
      
      sliderInput("effect_size", 
                  strong("How much Effect Size?"), 
                  min=0, max=1, value=0, step=.1, ticks=FALSE),
      sliderInput("sample_size",
                  strong("How many Observations in a sample?"),
                  min=1, max=50, value=20, step=1, ticks=FALSE),
      sliderInput("total_sims",
                  strong("How many Total Simulations?"),
                  min=100, max=5000, value=500, step=100, ticks=FALSE),
      sliderInput("sd",
                  strong("How varied the data is? (SD)"),
                  min=1, max=5, value=1, step=1, ticks=FALSE)
      
    )
  ),
  
  mainPanel(
    plotOutput("t.stats", width=fig.width, height=fig.height),
    plotOutput("p.values", width=fig.width, height=fig.height)
  )
  
))