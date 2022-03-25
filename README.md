# EstimationStatistics

[![Build Status](https://ci.appveyor.com/api/projects/status/github/neuro-myoung/EstimationStatistics.jl?svg=true)](https://ci.appveyor.com/project/neuro-myoung/EstimationStatistics-jl)
[![Coverage](https://codecov.io/gh/neuro-myoung/EstimationStatistics.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/neuro-myoung/EstimationStatistics.jl)
[![Coverage](https://coveralls.io/repos/github/neuro-myoung/EstimationStatistics.jl/badge.svg?branch=master)](https://coveralls.io/github/neuro-myoung/EstimationStatistics.jl?branch=master)


## Description
Estimation plots offer a more transparent representation of data and focuses on the conveying the effect size and its confidence interval using bootstrapping as opposed to null-hypothesis testing. One of the advantages of bootstrapping is that it does not make strong assumptions about the shape of the underlying distribution such as the normality assumption of parametric tests. Instead it relies on resampling sample distributions many thousands of times and only assumes that our sample distribution accurately represents the distribution of the underlying population. This package offers bias-corrected and accelerated bootstrapping and a few convenenient extensions to Julia's Plots.jl for making estimation plots. This was in part inspired by the python package DABEST. 

## Built-in Plots:

* Quasirandom Scatter
  * Allows for plotting all samples and representing the underlying distributions all while minimizing overplotting.
* Gardner-Altman
  * Represent effect sizes and their confidence intervals between two groups

## Built-in Boostrap methods

* Bias-corrected and accelerated bootstrap

| Plot      | Estimation Statistics | Parametric equivalent |
| ----------- | ----------- | ---------- |
| Quasirandom Scatter + Gardner-Altman Plot | Two-group estimation plot |    Unpaired T-test    |
| Tufte Slopegraph + Garnder-Altman Plot | Paired estimation plot | Paired T-test        |

Works in progress:
| Plot      | Estimation Statistics | Parametric equivalent |
| ----------- | ----------- | ---------- |
| Quasirandom Scatter + Cumming estimation plot | Multi two-group estimation plot| One-way ANOVA + multiple comparisons |
| Quasirandom Scatter + Cumming estimation plot |   Shared-control estimation plot   |    Ordered groups ANOVA    |
| Tufte Slopegraph + Cumming estimation plot   |    Multi paired estimation plot   | Repeated measures ANOVA |

To learn more about estimation statistics I recommend the following:
[Robust and Beautiful Statistical Visualization](https://acclab.github.io/DABEST-python-docs/robust-beautiful.html)

To learn more about different bootstrapping methods I recommend the following:
[Bootstrapping (Wikipedia)](https://en.wikipedia.org/wiki/Bootstrapping_(statistics))
[Bootstrap Confidence Intervals by Nathaiel E. Helwig](http://users.stat.umn.edu/~helwig/notes/bootci-Notes.pdf)

## Prerequisites

Before you begin make sure you have Julia v1.6 or higher (It may work on older versions but was not tested)

## Installation

To be added

## Functionality

## Contributing
To contribute to **EstimationStatistics.jl**, follow these steps:

1. Fork this repository.
2. Create a branch: git checkout -b *branch_name*.
3. Make your changes and commit them: git commit -m '*commit_message*'
4. Push to the original branch: git push origin *project_name* *location*
5. Create a pull request.

Alternatively see the GitHub [documentation](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) on creating a pull request.

## Contributors

[@neuro-myoung](https://github.com/neuro-myoung)

## Contact

If you want to contact me you can reach me at michael.young@duke.edu

## License
This project uses an [MIT License](https://opensource.org/licenses/MIT)