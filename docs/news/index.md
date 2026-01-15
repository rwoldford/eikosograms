# Changelog

## eikosograms 1.0.0

CRAN release: 2026-01-11

- Updating of local URL references in vignettes to meet CRAN standards

- Added some data sets

  - historical data set tuberculosis_1910 being the (possibly) earliest
    appearance of Simpson’s paradox in the statistical literature.

  - medicalRecords, a fictional data set constructed by R.W. Oldford
    that illustrates a twice reversing Simpson’s paradox

- Took the opportunity to remove dependency on the package plyr by
  replacing calls with base/stats equivalents. Not as tidy a code but
  possibly more robust in the long run.

- Note that should eikosograms be used for LARGE data sets, a rewrite
  that calls on dplyr from the tidyverse might be in order. Look for
  aggregate, sum, and ave functionality.

## eikosograms 0.1.1

CRAN release: 2018-08-22

Released August 22, 2018

- vignettes expanded.

## eikosograms 0.1.0

CRAN release: 2018-08-17

Initial CRAN release August 16, 2008
