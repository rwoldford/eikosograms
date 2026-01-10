# Create grob with eikosogram x-axis probabilities

Creates x axis grob to be placed on eikosogram. Called by eikos
functions.

## Usage

``` r
eikos_x_probs(
  data,
  xprobs = NULL,
  xprobs_size = 8,
  margin = unit(2, "points"),
  rotate = TRUE
)
```

## Arguments

- data:

  data frame from eikos_data object

- xprobs:

  vector of probabilities to be shown. NULL if they should be calculated
  from the data.

- xprobs_size:

  font size of labels for horizontal probabilities (in points)

- margin:

  unit specifying margin between y axis and eikosogram

- rotate:

  logical, whether probabilities should be rotated vertically.

## Value

textGrob with x-axis probabilities.
