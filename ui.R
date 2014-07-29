library(shiny);

graphsAvailable <- c(
  "Histogram",
  "Normal distribution",
  "Hypothesis test",
  "Qualitative"
);

hypothesisTestTypeAvailable <- c(
  "two.sided",
  "greater",
  "less"
);

hypothesisTestSamples <- c(
  "one",
  "two"
);

frequencyFunctionAvailable <- c("square", "sturges", "scott", "FD");

qualitativeGraph <- c(
  "pie",
  "bar"
);

shinyUI(fluidPage(
  headerPanel("Workplace accidents in brazilian states"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Dataset", choices = dir("data/")),
      selectInput("graph", "Graph", choices = graphsAvailable),
      conditionalPanel(
        condition = "input.graph == 'Normal distribution' ||
        input.graph == 'Hypothesis test'",
        sliderInput("confidence",
                    "Confidence interval",
                    min = 0.75,
                    max = 0.99,
                    step = 0.01,
                    value = 0.95)
      ),
      conditionalPanel(
        condition = "input.graph == 'Hypothesis test'",
        radioButtons("hypothesisTestSamples", "Hypothesis Test samples",
                     hypothesisTestSamples),
        radioButtons("hypothesisTestType", "Hypothesis Test type",
                     hypothesisTestTypeAvailable)
      ),
      conditionalPanel(
        condition = "input.graph == 'Histogram'",
        sliderInput("bins",
                    "Number of bins for histogram",
                    min = 1,
                    max = 40,
                    value = 5)
      ),
      conditionalPanel(
        condition = "input.graph == 'Qualitative'",
        radioButtons("plot", "Plot type", choices = qualitativeGraph),
        hr(),
        h2("Qualitative Frequency"),
        tableOutput("distQualitativeTable")
      ),
      conditionalPanel(
        condition = "input.graph != 'Qualitative'",
        radioButtons("frequencyFunction", "Interval function",
                     frequencyFunctionAvailable),
        hr(),
        h2("Frequency table"),
        tableOutput("distTable")
      ),
      htmlOutput("about")
    ),

    mainPanel(
      verbatimTextOutput("distProperties"),
      plotOutput("distPlot"),
      textOutput("distPlotNotes")
    )
  )
));
