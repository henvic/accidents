library(shiny);
library(visualizationTools);

source("lib.R");

run <- function () {
  input <- "data/accidents-compiled.csv";
  
  dataset <- read.table(input, sep = ',', header = TRUE);
  
  entries <- lib.getDeathsByStates(dataset);
  
  lib.plotFrequencyTable(entries, lib.intervalFunctions.square);
  
  curve(dnorm(x, 0, 1), xlim = c( - 3, 3), main = "Normal distribution");
  
  lib.plotNormal(3, 4, 0.95);
}

run();
