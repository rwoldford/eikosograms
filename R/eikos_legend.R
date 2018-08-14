library(grid)

#' Create eikosogram legend
#'
#' @description Eikos helper function used to create legend.
#'
#' @param labels labels to be included in legend
#' @param title if non-NULL a string to give as the legend title
#' @param yname_size font size of vertical axis names (in points)
#' @param yvals_size font size of labels for values of y variable (in points)
#' @param col colours od
#' @param margin unit specifying margin between legend entries
#' @param lcol line colour
eikos_legend <- function(labels, title = NULL, 
                         yname_size = 12, yvals_size = 12,
                         col, margin = unit(2, "points"), lcol = "black") {
    
    # check the number of labels and the color levels
    if(length(labels) != length(col)) {
        stop("labels and col vectors must have the same length.")
    }
    
    # set the square object size
    square_size <- unit(14, "points")
    n <- length(labels)
    # setting row heights and positions
    row_height <- (margin + square_size)
    y <- unit.c(margin + 0.5*square_size + 0:(n - 1) * row_height)
    
    # create label object
    labelGrob <- textGrob(labels, x = 0, y = y, just = "left",
                          gp = gpar(fontsize = yvals_size))
    
    # create square object
    squareGrob <- rectGrob(x = 0.5, y = y,
                           width = square_size,
                           height = square_size,
                           gp = gpar(fill = col))
    #
    # setting widths
    square_width <- 2*margin + square_size
    label_width <- unit(1, "grobwidth", labelGrob)
    row_widths <- unit.c(square_width, label_width)
    
    # create legend interior
    legend_interior_layout <- grid.layout(1, 2,
                                 widths = row_widths,
                                 heights = n*row_height) 
    legend_interior_width <-  square_width + label_width
    legend_interior_height <-  n * row_height
    legend_interior_frame <- frameGrob(layout = legend_interior_layout)
    legend_interior_frame <- placeGrob(legend_interior_frame, squareGrob, 1, 1)
    legend_interior_frame <- placeGrob(legend_interior_frame, labelGrob, 1, 2)
    
    # Add a title if given
    if (is.null(title)) {
        legend_frame <- legend_interior_frame
    } else
    {
        # create title object
        titleGrob <- textGrob(title, x = 0.5, y = row_height, just = "centre",
                              gp = gpar(fontsize = yname_size))
        title_width <- unit(1, "grobwidth", titleGrob)
        legend_width <-  unit.pmax(title_width, square_width + label_width)
        legend_heights <- unit.c(unit(1, "grobheight", titleGrob), 
                                 n * row_height)
        legend_layout <- grid.layout(2,1,
                                     widths = legend_width,
                                     heights = legend_heights)
        legend_frame <- frameGrob(layout = legend_layout)
        legend_frame <- placeGrob(legend_frame, titleGrob, 1, 1)
        legend_frame <- placeGrob(legend_frame, legend_interior_frame, 2, 1)
    }
    
    return(legend_frame)
}

