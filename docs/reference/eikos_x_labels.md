# eikos helper function. Returns grob with x axis labels.

eikos helper function. Returns grob with x axis labels.

## Usage

``` r
eikos_x_labels(
  x,
  data,
  margin = unit(10, "points"),
  xname_size = 12,
  xvals_size = 10,
  lab_rot = 0
)
```

## Arguments

- x:

  vector of conditional variables

- data:

  data frame from eikos_data.

- margin:

  unit specifying margin

- xname_size:

  font size for x axis variable names (in points)

- xvals_size:

  font size of labels for values of x variables (in points)

- lab_rot:

  integer indicating the rotation of the label, default is horizontal

## Value

gList with x labels and x-axis names as grob frames.
