table = read.table("acidentes.csv", sep = ',', header = TRUE);

getDeathsByGrouping = function(field) {
  group = levels(field);
  size = nrow(table);
  deaths = numeric(length(group));
  
  for (i in 1:size) {
    pos = match(field[i], group);
    deaths[pos] = deaths[pos] + table$Obitos[i];
  }
  
  return(deaths);
}

getDeathsByStates = function() {
  return(getDeathsByGrouping(table$UF));
}

plotHistogram = function(v) {
  histogram = hist(v, ylab = "Freqüência", xlab = "Mortes", main = "Histograma das mortes por estados");
  lines(c(min(histogram$breaks), histogram$mids, max(histogram$breaks)), c(0,histogram$counts, 0), type = "l");
}

getSquareInterval = function(entries) {
  k = 5;
  
  if (length(entries) > 25) {
    k = round(sqrt(length(entries)));
  }
  
  return(k);
}

getSturgesInterval = function(entries) {
  return(ceiling(1 + (3.22 * log10(length(entries)))));
}

plotFrequencyTable = function(entries, intervalsFunction) {
  # get intervals using the given intervals function callback
  k = intervalsFunction(entries);
  
  minEntry = min(entries);
  maxEntry = max(entries);
  
  # amplitude
  r = maxEntry - minEntry;

  # intervals amplitude: amplitude / intervals
  h = r / k;
  
  lim = seq(minEntry, maxEntry, h);
  
  # intervals/cut
  int = cut(entries, breaks = lim, include.lowest = TRUE);
  
  # print table
  data.frame(table(int));
}

deathsByStates = getDeathsByStates();

plotFrequencyTable(deathsByStates, getSquareInterval);
