# Create grob with eikosogram y-axis probabilities

Creates y axis grob to be placed on eikosogram. Called by eikos
functions.

## Usage

``` r
eikos_y_probs(data, yprobs, yprobs_size = 8, margin = unit(2, "points"))
```

## Arguments

- data:

  data frame from eikos_data object

- yprobs:

  vector of probabilities to be shown. NULL if they should be calculated
  from the data.

- yprobs_size:

  font size of labels for horizontal probabilities (in points)

- margin:

  unit specifying margin between y axis and eikosogram

## Value

textGrob with y-axis probabilities.
