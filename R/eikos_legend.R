#' Create eikosogram legend
#'
#' @description Eikos helper function used to create legend.
#'
#' @param labels labels to be included in legend
#' @param colours colours
#' @param margin unit specifying margin between legend entries
#' @param lcol line colour
eikos_legend <- function(labels, colours, margin = unit(2, "points"), lcol = "black") {
    
    # check the number of labels and the color levels
    if(length(labels) != length(colours)) {
        stop("label and colour vectors must have same length.")
    }
    
    # set the square object size
    square_size <- unit(14, "points")
    n <- length(labels)
    y <- unit.c(margin + 0.5*square_size + 0:(n - 1)*(margin + square_size))
    
    # create label object
    labelGrob <- textGrob(labels, x = 0, y = y, just = "left")
    # create square object
    squareGrob <- rectGrob(x = 0.5, y = y,
                           width = square_size,
                           height = square_size,
                           gp = gpar(fill = colours))
    
    # create legend object
    legend_layout <- grid.layout(1, 2,
                                 widths = unit.c(2*margin + square_size, unit(1, "grobwidth", labelGrob)),
                                 height = unit(1, "grobheight", squareGrob))
    
    legend_frame <- frameGrob(layout = legend_layout)
    legend_frame <- placeGrob(legend_frame, squareGrob, 1, 1)
    legend_frame <- placeGrob(legend_frame, labelGrob, 1, 2)
    
    return(legend_frame)
}

