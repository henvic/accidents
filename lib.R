library(visualizationTools);

lib.getData <- function(file) {
  # only read inside data/
  if (length(grep("\\.\\.", file)) != 0) {
    stop("Reading files outside of the data directory is not allowed.");
    return(null);
  }

  return(read.table(paste("data/", file, sep = ""), sep = ',', header = TRUE));
}

lib.getSkewness <- function(entries) {
  n <- length(entries);
  s <- sd(entries);
  m <- mean(entries);

  return(n / ((n - 1) * (n - 2)) * sum((entries - m) ^ 3) / (s ^ 3));
}

lib.getKurtosis <- function(entries) {
  n <- length(entries);
  s <- sd(entries);
  m <- mean(entries);

  return((n * (n + 1) / ((n - 1) * (n - 2) * (n - 3))) *
           sum((entries - m) ^ 4) / (s ^ 4) - 3 *
           ((n - 1) ^ 2) / ((n - 2) * (n - 3)));
}

lib.getSummary <- function(entries) {
  names <- c("Mode",
            "Mean",
            "Median",
            "Variance",
            "Standard deviation",
            "Quantile 0%",
            "Quantile 25% (quartile 1)",
            "Quantile 50% (quartile 2)",
            "Quantile 75% (quartile 3)",
            "Quantile 100%",
            "Skewness",
            "Kurtosis"
  );

  q <- quantile(entries);
  s <- sd(entries);

  properties <- c(paste(lib.mode(entries), collapse = ", "),
                 lib.escape.decimal(mean(entries)),
                 lib.escape.decimal(median(entries)),
                 lib.escape.decimal(s ^ 2),
                 lib.escape.decimal(s),
                 lib.escape.decimal(q[1]),
                 lib.escape.decimal(q[2]),
                 lib.escape.decimal(q[3]),
                 lib.escape.decimal(q[4]),
                 lib.escape.decimal(q[5]),
                 lib.escape.decimal(lib.getSkewness(entries)),
                 lib.escape.decimal(lib.getKurtosis(entries)));

  length <- length(names);

  res <- "";

  for(counter in 1:length) {
    res <- paste(res, names[counter], properties[counter], "\n");
  }

  return(res);
}

lib.mode <- function(entries) {
  entries <- sort(entries);

  uniqueEntries <- unique(entries);
  uniqueEntriesLength <- length(uniqueEntries);

  total <- rep(0, uniqueEntriesLength);

  posTotal <- 1;
  last <- entries[1];

  entriesLength <- length(entries);

  for (i in 1:entriesLength) {
    if (entries[i] != last) {
      posTotal <- posTotal + 1;
      last <- entries[i];
    }

    total[posTotal] <- total[posTotal] + 1;
  }

  maxFrequency <- max(total);

  mode <- c();

  for (i in 1:uniqueEntriesLength) {
    if (maxFrequency == total[i]) {
      mode <- c(mode, uniqueEntries[i]);
    }
  }

  return(sort(mode));
}

lib.getDeathsByGrouping <- function(dataset, field) {
  group <- levels(field);
  size <- nrow(dataset);
  deaths <- numeric(length(group));

  for (i in 1:size) {
    pos <- match(field[i], group);
    deaths[pos] <- deaths[pos] + dataset$Quantidade_Obitos[i];
  }

  return(deaths);
}

lib.getDeathsStates <- function(dataset) {
  return(unique(dataset$UF));
}

lib.getDeathsByStates <- function(dataset) {
  return(lib.getDeathsByGrouping(dataset, dataset$UF));
}

lib.plotHistogram <- function(v, bins) {
  histogram <- hist(v,
                   ylab = "Frequency",
                   xlab = "Deaths",
                   main = "Histogram: deaths frequency",
                   col = "lightblue",
                   breaks = bins);

  lines(c(min(histogram$breaks),
          histogram$mids,
          max(histogram$breaks)),
        c(0,histogram$counts, 0),
        type = "l");
}

lib.intervalFunctions.square <- function(entries) {
  k <- 5;

  if (length(entries) > 25) {
    k <- round(sqrt(length(entries)));
  }

  return(k);
}

lib.intervalFunctions.scott <- function(entries) {
  return(nclass.scott(entries));
}

lib.intervalFunctions.sturges <- function(entries) {
  return(nclass.Sturges(entries));
}

lib.intervalFunctions.FD <- function(entries) {
  return(nclass.FD(entries));
}

lib.renderFrequencyTable <- function(entries, intervalsFunction) {
  # get intervals using the given intervals function callback
  k <- intervalsFunction(entries);

  minEntry <- min(entries);
  maxEntry <- max(entries);

  # amplitude
  r <- maxEntry - minEntry;

  # intervals amplitude: amplitude / intervals
  h <- r / k;

  lim <- seq(minEntry, maxEntry, h);

  # intervals/cut
  int <- cut(entries, breaks = lim, include.lowest = TRUE);

  # print dataset
  out <- as.data.frame(table(int));

  # Add cumFreq and proportions and return
  return(transform(out, cumFreq = cumsum(Freq), relative = prop.table(Freq)));
}

lib.renderQuantitativeTable <- function(frequency, labels) {
  relative <- paste(
    lib.escape.decimal((frequency / sum(frequency) * 100), 2),
    "%", sep = "");

  # print dataset
  # out <- as.data.frame(table(labels));

  return(transform(cbind(levels(labels), frequency, relative)));
}

lib.plotNormal <- function(mean, sd, confidence) {
  curve(dnorm(x, mean, sd), xlim = c(mean - (3 * sd), mean + (3 * sd)));

  left <- (1 - confidence) / 2;
  right <- confidence + left;

  dotL <- qnorm(left, mean, sd);
  dotR <- qnorm(right, mean, sd);
  interval <- 0.01;

  cordX <- c(dotL, seq(dotL, dotR, interval), dotR);
  cordY <- c(0, dnorm(seq(dotL, dotR, interval), mean, sd), 0);

  polygon(cordX, cordY, col = "skyblue");
  polygon(c(mean, mean), c(0, dnorm(mean, mean, sd)), border="lightblue");
}

lib.escape.decimal <- function (number, digits = 2) {
  return(format(round(number, digits), nsmall = digits));
}

lib.escape.character <- function (text) {
  return(as.character(decimal(text)));
}

lib.getHypothesisTestAlternatives <- function(type, mean) {
  # two.sided is the default
  h0 <- "=";
  ha <- "!=";

  # right
  if (type == "greater") {
    h0 <- "<=";
    ha <- ">";
  }

  # left
  if (type == "less") {
    h0 <- ">=";
    ha <- "<";
  }

  return(paste("H0: μ", h0, as.character(lib.escape.decimal(mean)), ";",
               "Ha: μ", ha, as.character(lib.escape.decimal(mean))));
}

lib.hypothesisTestTwoSamples <- function(entries,
                                        type = "two.side",
                                        confidenceRate,
                                        sampleX,
                                        sampleY) {
  meanX <- mean(sampleX);
  meanY <- mean(sampleY);

  mean <- abs(meanX - meanY);

  plot(t.test(x = sampleX,
              y = sampleY,
              alternative = type,
              conf.level = confidenceRate,
              mu = mean));

  return(lib.getHypothesisTestAlternatives(type, mean));
}

lib.hypothesisTestOneSample <- function(entries, type, confidenceRate, sample) {
  mean <- mean(entries);

  plot(t.test(x = sample,
              alternative = type,
              conf.level = confidenceRate,
              mu = mean));

  return(lib.getHypothesisTestAlternatives(type, mean));
}

lib.plotFunctions.pie <- function(entries, labels) {
  cols <- rainbow(length(entries));
  percentLabels <- round(100 * entries / sum(entries), 1);
  pieLabels <- paste(percentLabels, "%", sep = "");
  pieLabels <- paste(levels(labels), pieLabels);

  pie(entries,
      main="Deaths by workplace accidents by state",
      col = cols,
      labels = entries,
      cex = 0.75);

  legend("topright",
         pieLabels,
         fill = cols,
         ncol = 2,
         cex = 1.2);
}

lib.plotFunctions.bar <- function(entries, labels) {
  barplot(entries,
          main="Deaths by workplace accidents by state",
          names.arg=levels(labels),
          col = rainbow(length(entries)),
          cex.names = 0.65,
          pi,
          ylim = c(0, max(entries) * 1.1));
}
