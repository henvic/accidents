library(shiny);

source("lib.R");

shinyServer(function(input, output) {
  output$about <- renderText(paste('<iframe src="',
    'http://ghbtns.com/github-btn.html?',
    'user=henvic&repo=accidents&type=fork&size=large&count=true"',
    'allowtransparency="true"',
    'frameborder="0"',
    'scrolling="0"',
    'width="170"',
    'height="30"',
    '></iframe>',
    sep = ''
    ));
  
  output$distTable <- renderTable({
    frequencyFunction <- paste("lib.intervalFunctions.",
                              input$frequencyFunction,
                              sep = "");
    
    dataset <- lib.getData(input$dataset);
    
    entries <- lib.getDeathsByStates(dataset);
    
    if (!exists(frequencyFunction)) {
      stop("Frequency function not available.");
      return(null);
    }
    
    lib.renderFrequencyTable(entries, get(frequencyFunction));
  });
  
  output$distQuantitativeTable <- renderTable({
    dataset <- lib.getData(input$dataset);
    
    entries <- lib.getDeathsByStates(dataset);
    states <- lib.getDeathsStates(dataset);
    
    lib.renderQuantitativeTable(entries, states);
  });
  
  output$distProperties <- renderText({
    dataset <- lib.getData(input$dataset);
    entries <- lib.getDeathsByStates(dataset);
    paste(lib.getSummary(entries));
  });
  
  output$distPlot <- renderPlot({
    dataset <- lib.getData(input$dataset);
    
    entries <- lib.getDeathsByStates(dataset);
    states <- lib.getDeathsStates(dataset);
    
    if (input$graph == "Histogram") {
      bins <- seq(0, max(entries), length.out = input$bins + 1);
      lib.plotHistogram(entries, bins);
      output$distPlotNotes <- renderText(paste("Ideal bins:",
              lib.intervalFunctions.square(entries), "(square),",
              lib.intervalFunctions.sturges(entries), "(sturges),",
              lib.intervalFunctions.scott(entries), "(Scoot),",
              lib.intervalFunctions.FD(entries), "(FD)."
          ));
      return(NULL);
    }
    
    if (input$graph == "Normal distribution") {
      lib.plotNormal(mean(entries), sd(entries), input$confidence);
      output$distPlotNotes <- renderText("");
      return(NULL);
    }
    
    if (input$graph == "Hypothesis test") {
      if (input$hypothesisTestSamples == "one") {
        hypothesis <- lib.hypothesisTestOneSample(entries,
          input$hypothesisTestType,
          input$confidence,
          sample(entries, ceiling(length(entries) / 10)));
        
        output$distPlotNotes <- renderText(hypothesis);
        return(NULL);
      }
      
      hypothesis <- lib.hypothesisTestTwoSamples(entries,
        input$hypothesisTestType,
        input$confidence,
        sample(entries, ceiling(length(entries) / 10)),
        sample(entries, ceiling(length(entries) / 10)));
      
      output$distPlotNotes <- renderText(hypothesis);
      return(NULL);
    }
    
    if (input$graph == "Quantitative") {
      plotFunction <- paste("lib.plotFunctions.", input$plot, sep = "");
      
      if (!exists(plotFunction)) {
        stop("Plot function not available.");
        return(null);
      }
      
      get(plotFunction)(entries, states);
      
      output$distPlotNotes <- renderText("");
      return(NULL);
    }
  });
});
