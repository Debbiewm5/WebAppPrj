library(shiny)

shinyServer(function(input, output) {
  
  getsample <- reactive({
    
    #Get Input variables and assign them to local variables
    total_sims <- input$total_sims
    sample_size <- input$sample_size
    effect_size <- input$effect_size
    sd <- input$sd
    
    #Randomly generate numbers based on input parameters
    randomsample <- rnorm(total_sims * sample_size, effect_size, sd)
    sample <- matrix(randomsample, nrow=total_sims)
    
    sample_means <- apply(sample, 1, mean)
    sample_sems <- apply(sample, 1, sd) / sqrt(sample_size)
    
    df <- sample_size - 1
    t_stats <- sample_means / sample_sems   
    p_values <- pt(t_stats, df, lower.tail=FALSE)
    
    sig_rate <- sum(p_values < 0.05) / total_sims
    power_val <- power.t.test(sample_size, effect_size, sd, 0.05,
                          type="one.sample", alternative="one.sided")$power
    
    list(df=df, t.stats=t_stats, p.values=p_values, sig.rate=sig_rate, power=power_val)
    
  })
  
  output$t.stats <- renderPlot({
    
    sample <- getsample()
    plot.title <- sprintf("Power = %.2f and Proportion of rejected nulls = %.2f", sample$power, sample$sig.rate)
    hist(sample$t.stats, 25, col="red", main=plot.title, xlab="t statistics")
    
    abline(v=qt(0.05, sample$df, lower.tail=FALSE), lwd=3,col="green")
    
  })
  
  output$p.values <- renderPlot({
    
    sample <- getsample()  
    bins <- seq(0, 1, length.out=40)
    hist(sample$p.values, bins, col="yellow", main=NULL, xlab="p values")

    abline(v=0.05, lwd=3,col="green")
    
  })
  
})