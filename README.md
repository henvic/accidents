# Accidents / [ET586CC](https://sites.google.com/a/cin.ufpe.br/et586cc/)

## Source
Source: [Anuário Estatístico de Acidentes de Trabalho - AEAT](http://dados.gov.br/dataset/anuario-estatistico-de-acidentes-de-trabalho)

Project theme: workplace accidents in Brazil.

**data/accidents-compiled.csv** has data compiled between the 2002-2009 period.

## Tools and dependencies
* [R runtime](http://cran.rstudio.com/) >= 3.1.1
* [Shiny](http://shiny.rstudio.com/) by RStudio: A web application framework for R
* [visualization-tools](http://cran.r-project.org/web/packages/visualizationTools/index.html): for plotting t-test

You may find it worth to use the [RStudio IDE](http://www.rstudio.com/) (Integrated Development Environment).

## Web-available demo
Before downloading the app you can [try it on-line](http://henvic.shinyapps.io/accidents/) at **http://henvic.shinyapps.io/accidents/**

Shiny uses a web-based UI with WebSocket to sync it with the R logic on the server-side.

App kindly hosted for free at the [ShinyApps.io](https://www.shinyapps.io) cloud.

## Deploying
You can fast deploy this program in a just few seconds with

```
R -e "shiny::runGitHub('accidents', 'henvic');"
```

This will download the last version of the program and run it.

## Possible simple improvements
* lib.R code could be more organized
* Interval functions options could be dynamically added to the UI
* Server.R has linting problems
* Caching

### Caching
The code doesn't cache almost anything because the tradeoff would be code quality and the benefits weren't enough to justify it, even thought when loading the 2002-2009 dataset we can notice there's a evident bottleneck.

The caching decision was deferred and, then, once complete, deferred indefinitely.

> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. ~ [Donald Knuth](http://cs.stanford.edu/~uno/)

The parsing of the CSV file with the construction of the raw data table seems to be one of the most costly operations but no statistics were taken to prove this claim.

## Docs
* [The Shiny Cheat sheet](http://shiny.rstudio.com/articles/cheatsheet.html)
* [R Functions Things Your Mother (Probably) Didn’t Tell You About](https://www.stat.auckland.ac.nz/~ihaka/downloads/Waikato-WRUG.pdf)
* [The R Manuals](http://cran.r-project.org/manuals.html)

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using the R [lint](http://cran.r-project.org/web/packages/lint/index.html) package.

Read the [Google's R Style Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml) and try to follow it.

If you're new to git and GitHub see the [GitHub Guides](https://guides.github.com/).

## License
Licensed under the [MIT license](http://henvic.mit-license.org/).
