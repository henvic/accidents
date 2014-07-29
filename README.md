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

## Deploying
You can easily download and deploy this program locally inside a R shell, if you have Shiny:

```
runGitHub("accidents", "henvic");
```

## Drawbacks
The code currently doesn't take too much attention to memory / processing. For large datasets it may take a while for it to load. Caching could be used to avoid this, but it's not really a bottleneck for the choose accidents dataset so this decision was deferred and for this case it turned out to be acceptable to defer it indefinitely because the benefits would be pointless in terms of performance and slightly bad for code quality / simplicity.

## Docs
* [The Shiny Cheat sheet](http://shiny.rstudio.com/articles/cheatsheet.html)
* [R Functions Things Your Mother (Probably) Didn’t Tell You About](https://www.stat.auckland.ac.nz/~ihaka/downloads/Waikato-WRUG.pdf)
* [The R Manuals](http://cran.r-project.org/manuals.html)

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using the R [lint](http://cran.r-project.org/web/packages/lint/index.html) package.

Read the [Google's R Style Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml) and try to follow it.

To clone this repo:
```
git clone git@github.com:henvic/accidents.git
```

If you're new to git and GitHub see the [GitHub Guides](https://guides.github.com/).
