# eikos helper function. Returns grob with y axis labels.

eikos helper function. Returns grob with y axis labels.

## Usage

``` r
eikos_y_labels(
  y,
  data,
  margin = unit(2, "points"),
  yname_size = 12,
  yvals_size = 10,
  lab_rot = 0
)
```

## Arguments

- y:

  response variable

- data:

  data frame from eikos_data.

- margin:

  unit specifying margin

- yname_size:

  font size for y axis variable names (in points)

- yvals_size:

  font size of labels for values of y variable (in points)

- lab_rot:

  integer indicating the rotation of the label, default is horizontal

## Value

grobFrame with response variable labels and axis text
