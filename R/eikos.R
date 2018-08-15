library(grid)

#' Generic method for creating an eikosogram
#'
#' @param y Either the name of a variable in the data set (eikos.default), or a formula of such variables (eikos.formula).
#' @param x name(s) of any conditional variable(s) (horizontal axis). Should be null if formula given.
#' @param data data frame or table
#' @param marginalize variable(s) to marginalize on, or NULL if none. Marginalized variables still appear in plot.
#' 
#' @param main title of plot
#' @param main_size font size of title (in points)
#' 
#' @param ylabs logical, whether y labels should appear or not.
#' @param ylab_rot rotation of y labels
#' @param yname_size font size of vertical axis names (in points)
#' @param yvals_size font size of labels for values of y variable (in points)
#' 
#' @param yaxs logical, whether y axis should appear or not.
#' @param yprobs probabilities to be shown on y-axis. NULL if they should be calculated from the data.
#' @param yprobs_size font size of labels for horizontal probabilities (in points)
#' 
#' @param xlabs logical, whether x labels should appear or not.
#' @param xlab_rot rotation of x labels
#' @param xname_size font size of horizontal axis names (in points)
#' @param xvals_size font size of labels for values of x variables (in points)
#' 
#' @param xaxs logical, whether x axis should appear or not.
#' @param xprobs probabilities to be shown on x-axis. NULL if they should be calculated from the data.
#' @param xprobs_size font size of labels for horizontal probabilities (in points)
#' @param vertical_xprobs logical, whether probabilities on x axis should be rotated vertically.
#' 
#' @param ispace list of four items (bottom, left, top, right) indicating the margins separating the text around the diagram. 
#'        Each value is a positive integer giving a measure in "points".
#' @param legend logical, whether to include legend
#' 
#' @param col a vector of colours to match the response values.  If NULL (the default), the colours are constructed as a smooth
#'        transition from `bottomcol` to `topcol` via `grDevices::colorRampPalette
#' @param bottomcol bottom colour
#' @param topcol top colour
#' @param lcol colour of lines
#' @param draw logical, whether to draw eikosogram.
#' @param newpage logical, whether to draw on a newpage.
#' @param lock_aspect logical, whether to force entire plot to 1:1 aspect ratio.
#' @seealso \code{\link{eikos.default}}
#' @seealso \code{\link{eikos.formula}}
#' @import grid plyr
#' @export
eikos <- function(y, x = NULL, data = NULL, marginalize = NULL, 
                  main = "", main_size = 16,
                  ylabs = TRUE,  ylab_rot=0,  yname_size = 12, yvals_size = 12, 
                  yaxs = TRUE, yprobs = NULL, yprobs_size = 8,
                  xlabs = TRUE,  xlab_rot=0,  xname_size = 12, xvals_size = 12, 
                  xaxs = TRUE, xprobs = NULL, xprobs_size = 8, vertical_xprobs = TRUE, 
                  ispace = list(bottom = 8, 
                                left = 2,
                                top = 2, 
                                right = 5 ),
                  legend = FALSE, 
                  col = NULL, bottomcol="steelblue", topcol="snow2", lcol = "black", 
                  draw = TRUE, newpage = TRUE, 
                  lock_aspect = TRUE) {
    UseMethod("eikos")
}

#' @title Create a new eikosogram
#'
#' @description Return a grid graphic object (grob) and draw an eikosogram if draw = TRUE.
#'
#' @param y Either the name of a variable in the data set (eikos.default), or a formula of such variables (eikos.formula).
#' @param x name(s) of any conditional variable(s) (horizontal axis). Should be null if formula given.
#' @param data data frame or table
#' @param marginalize variable(s) to marginalize on, or NULL if none. Marginalized variables still appear in plot.
#' 
#' @param main title of plot
#' @param main_size font size of title (in points)
#' 
#' @param ylabs logical, whether y labels should appear or not.
#' @param ylab_rot rotation of y labels
#' @param yname_size font size of vertical axis names (in points)
#' @param yvals_size font size of labels for values of y variable (in points)
#' 
#' @param yaxs logical, whether y axis should appear or not.
#' @param yprobs probabilities to be shown on y-axis. NULL if they should be calculated from the data.
#' @param yprobs_size font size of labels for horizontal probabilities (in points)
#' 
#' @param xlabs logical, whether x labels should appear or not.
#' @param xlab_rot rotation of x labels
#' @param xname_size font size of horizontal axis names (in points)
#' @param xvals_size font size of labels for values of x variables (in points)
#' 
#' @param xaxs logical, whether x axis should appear or not.
#' @param xprobs probabilities to be shown on x-axis. NULL if they should be calculated from the data.
#' @param xprobs_size font size of labels for horizontal probabilities (in points)
#' @param vertical_xprobs logical, whether probabilities on x axis should be rotated vertically.
#' 
#' @param ispace list of four items (bottom, left, top, right) indicating the margins separating the text around the diagram. 
#'        Each value is a positive integer giving a measure in "points".
#' @param legend logical, whether to include legend
#' 
#' @param col a vector of colours to match the response values.  If NULL (the default), the colours are constructed as a smooth
#'        transition from `bottomcol` to `topcol` via `grDevices::colorRampPalette
#' @param bottomcol bottom colour
#' @param topcol top colour
#' @param lcol colour of lines
#' @param draw logical, whether to draw eikosogram.
#' @param newpage logical, whether to draw on a newpage.
#' @param lock_aspect logical, whether to force entire plot to 1:1 aspect ratio.
#'
#' @examples
#' eikos("Hair", "Eye", data=HairEyeColor, legend = TRUE)
#' eikos("Hair", "Eye", data=HairEyeColor, 
#'       legend = TRUE, ylabs = FALSE, 
#'       yname_size = 16, yvals_size = 8)
#' eikos("Hair", "Eye", data=HairEyeColor, 
#'       legend = TRUE, ylabs = FALSE, 
#'       yprobs = seq(0.2, 1, .2))
#' eikos("Eye", "Hair", data=HairEyeColor, yprobs = seq(0,1,0.25),
#'       yname_size = 20, xname_size = 20,
#'       col = c("sienna4", "steelblue", "darkkhaki", "springgreen3"),
#'       lcol = "grey10",
#'       lock_aspect = FALSE)
#'
#' @export
eikos.default <- function(y, x = NULL, data = NULL, marginalize = NULL, 
                          main = "", main_size = 16,
                          ylabs = TRUE,  ylab_rot=0,  yname_size = 12, yvals_size = 12, 
                          yaxs = TRUE, yprobs = NULL, yprobs_size = 8,
                          xlabs = TRUE,  xlab_rot=0,  xname_size = 12, xvals_size = 12, 
                          xaxs = TRUE, xprobs = NULL, xprobs_size = 8, vertical_xprobs = TRUE, 
                          ispace = list(bottom = 8, 
                                        left = 2,
                                        top = 2, 
                                        right = 5 ),
                          legend = FALSE, 
                          col = NULL, bottomcol="steelblue", topcol="snow2", lcol = "black", 
                          draw = TRUE, newpage = TRUE, 
                          lock_aspect = TRUE){


    # response variable cannot be more than one
    if(length(y) > 1) {
        stop("y must be a single response variable.")
    }

    # conditional variable cannot contain response variable
    if(y %in% x) {
        stop("Response variable must be different from conditioning variables.")
    }
    
    if(newpage & draw) grid::grid.newpage()
    
    # Set default ispace values if missing
    if (!"bottom" %in% names(ispace)) ispace$bottom <- unit(8, units = "points") 
    if (!"left" %in% names(ispace)) ispace$left <- unit(2, units = "points")  
    if (!"top" %in% names(ispace)) ispace$top <- unit(2, units = "points")  
    if (!"right" %in% names(ispace)) ispace$right<- unit(5, units = "points")
    
    # Make sure they are grid units (default is "points")
    for (i in 1:length(ispace)) {
        if (!is.unit(ispace[[i]])) {
            if (is.numeric(ispace[[i]]) & ispace[[i]] >= 0) {
                ispace[[i]] <- unit(ispace[[i]], units = "points")
            } else {
                stop(paste0("ispace$", names(ispace)[i], " must be either a grid graphic unit or a non-negative integer, not ",
                            ispace[[i]]))
            }
        } 
    }
    
    # sets margin between eikosogram and labels.
    margin <- unit(2, "points")
    legend_margin <- ispace$right 
    title_margin <- ispace$top
    ylab_margin <- ispace$left
    xlab_margin <- ispace$bottom
    xprobs_margin <- ispace$top
    yprobs_margin <- ispace$right

    # transform data
    idf <- eikos_data(y, x,  data, marginalize)

    # create colour palette
    responses <- as.vector(unique(idf[,y]))
    if (is.null(col)){
        colour_palette <- grDevices::colorRampPalette(c(bottomcol,topcol))(length(responses))
    } else {
        if (length(responses) != length(col)) stop("col must have the same length as the number of unique response values.")
        colour_palette <- col
    }
    names(colour_palette) <- responses
    
    # create rectangles
    x0 <- idf$xmin
    y0 <- idf$ymin
    widths <- idf$CondProb
    heights <- idf$MarginProb

    rectangles <- rectGrob(x = x0,
        y = y0,
        width = widths,
        height = heights,
        just=c("left", "bottom"),
        gp =  gpar(fill = colour_palette[ idf[,y] ], col = lcol),
        name = "rectangles of joint probability")
    # rect_layout <- grid.layout(respect = lock_aspect)
    # rect_layout <- placeGrob(rect_layout, rectangles, col = 1, row = 1)
    # rectangles <- frameGrob(rect_layout, name = "unitSquare")
    # get axes text
    labels <- list(x = nullGrob(name = "null: no x labels"), 
                   y = nullGrob(name = "null: no y labels") 
                   )
    if(ylabs) {
        labels$y <- eikos_y_labels(y, idf, margin = ylab_margin, 
                                   yname_size = yname_size, yvals_size = yvals_size,
                                   lab_rot=ylab_rot)
    }

    x_names <- nullGrob(name = "null: no x names")
    if(xlabs & (!is.null(x))) {
        x_grobs <- eikos_x_labels(x, idf, margin = xlab_margin, 
                                  xname_size = xname_size, xvals_size = xvals_size,
                                  lab_rot=xlab_rot)

        labels$x <- x_grobs$labels
        x_names <- x_grobs$names
    }

    probs <- list(x = frameGrob(layout = grid.layout(1, 1,widths = unit(1,"npc"), heights = unit(4, "points"))),
        y = frameGrob(layout = grid.layout(1, 1,heights = unit(1,"npc"), widths = unit(4, "points"))))

    # get axes
    if(xaxs & !is.null(x)) {
        probs$x <- eikos_x_probs(data = idf, xprobs = xprobs, xprobs_size = xprobs_size,
                                 margin = xprobs_margin, rotate = vertical_xprobs)
    }
    if(yaxs) {
        probs$y <- eikos_y_probs(idf, yprobs, margin = yprobs_margin)
    }

    # get legend
    lgnd <- nullGrob(name = "null: no legend")
    if(legend) {
        lgnd <- eikos_legend(labels = responses, 
                             title = if (ylabs) NULL else y, yname_size = yname_size, yvals_size = yvals_size,
                             col = colour_palette, margin = legend_margin)
    }

    # get plot title
    title <- if (main != "") {
        textGrob(main, gp = gpar(fontsize = main_size), name = "main title")
    } else nullGrob(name = "null: no main title")

    legend_width <- grobWidth(lgnd) + as.numeric(legend)*legend_margin

    # set layout
    widths <- unit.c(grobWidth(labels$y) + 2*margin,
        unit(1, "null", NULL),
        max(grobWidth(probs$y)+ unit(4, "points"), grobWidth(x_names)) ,
        legend_width)
    heights <- unit.c(grobHeight(title) + as.numeric(main != "")*title_margin,
        grobHeight(probs$x) + 2*margin,
        unit(1, "null", NULL),
        grobHeight(labels$x) + 2*margin)


    rows <- 4
    columns <- 4

    viewport <- pushViewport(viewport(gp = gpar(fontsize = min(yvals_size, xvals_size))))
    layout <- grid.layout(rows, columns,
        widths = widths,
        heights =  heights,
        respect = lock_aspect)

    # assemble eikosogram
    object <- frameGrob(layout = layout, name = "eikosogram")
    pushViewport(viewport())

    object <- placeGrob(object, rectangles, col = 2, row = 3)
    object <- placeGrob(object, title, col = 2, row = 1)
    object <- placeGrob(object, labels$y, col = 1, row = 3)
    object <- placeGrob(object, probs$y, col = 3, row = 3)
    object <- placeGrob(object, labels$x, col = 2, row = 4)
    object <- placeGrob(object, x_names, col = 3, row = 4)
    object <- placeGrob(object, probs$x, col = 2, row = 2)
    object <- placeGrob(object, lgnd, col = 4, row = 3)
   
    if(draw) {
        grid.draw(object)
    }
    invisible(object)
}



#' Draw eikosogram using a formula to identify response and conditioning variates
#'
#' @param y Either the name of a variable in the data set (eikos.default), or a formula of such variables (eikos.formula).
#' @param x name(s) of any conditional variable(s) (horizontal axis). Should be null if formula given.
#' @param data data frame or table
#' @param marginalize variable(s) to marginalize on, or NULL if none. Marginalized variables still appear in plot.
#' 
#' @param main title of plot
#' @param main_size font size of title (in points)
#' 
#' @param ylabs logical, whether y labels should appear or not.
#' @param ylab_rot rotation of y labels
#' @param yname_size font size of vertical axis names (in points)
#' @param yvals_size font size of labels for values of y variable (in points)
#' 
#' @param yaxs logical, whether y axis should appear or not.
#' @param yprobs probabilities to be shown on y-axis. NULL if they should be calculated from the data.
#' @param yprobs_size font size of labels for horizontal probabilities (in points)
#' 
#' @param xlabs logical, whether x labels should appear or not.
#' @param xlab_rot rotation of x labels
#' @param xname_size font size of horizontal axis names (in points)
#' @param xvals_size font size of labels for values of x variables (in points)
#' 
#' @param xaxs logical, whether x axis should appear or not.
#' @param xprobs probabilities to be shown on x-axis. NULL if they should be calculated from the data.
#' @param xprobs_size font size of labels for horizontal probabilities (in points)
#' @param vertical_xprobs logical, whether probabilities on x axis should be rotated vertically.
#' 
#' @param ispace list of four items (bottom, left, top, right) indicating the margins separating the text around the diagram. 
#'        Each value is a positive integer giving a measure in "points".
#' @param legend logical, whether to include legend
#' 
#' @param col a vector of colours to match the response values.  If NULL (the default), the colours are constructed as a smooth
#'        transition from `bottomcol` to `topcol` via `grDevices::colorRampPalette
#' @param bottomcol bottom colour
#' @param topcol top colour
#' @param lcol colour of lines
#' @param draw logical, whether to draw eikosogram.
#' @param newpage logical, whether to draw on a newpage.
#' @param lock_aspect logical, whether to force entire plot to 1:1 aspect ratio.
#'
#' @examples
#' eikos(Eye ~ Hair + Sex, data=HairEyeColor)
#' eikos(Hair ~ ., data=HairEyeColor, 
#'       yaxs = FALSE, ylabs = FALSE,
#'       legend = TRUE, 
#'       col = c("black", "sienna4", 
#'               "orangered", "lightgoldenrod" ))
#' eikos(Hair ~ ., data=HairEyeColor, xlab_rot = 30,
#'       yprobs = seq(0.1, 1, 0.1),
#'       yvals_size = 10,
#'       xvals_size = 8,
#'       ispace = list(bottom = 10),
#'       bottomcol = "grey30", topcol = "grey70",
#'       lcol = "white")
#' eikos(Hair ~ ., data=HairEyeColor, xlab_rot = 30,
#'       marginalize = "Eye",
#'       yvals_size = 10,
#'       xvals_size = 8,
#'       ispace = list(bottom = 10),
#'       bottomcol = "grey30", topcol = "grey70",
#'       lcol = "white")
#' eikos(Hair ~ ., data=HairEyeColor, xlab_rot = 30,
#'       marginalize = c("Eye", "Sex"),
#'       yvals_size = 10,
#'       xvals_size = 8,
#'       ispace = list(bottom = 10),
#'       bottomcol = "grey30", topcol = "grey70",
#'       lcol = "white")
#'
#' @export
eikos.formula <- function(y, x = NULL, data = NULL, marginalize = NULL, 
                          main = "", main_size = 16,
                          ylabs = TRUE,  ylab_rot=0,  yname_size = 12, yvals_size = 12, 
                          yaxs = TRUE, yprobs = NULL, yprobs_size = 8,
                          xlabs = TRUE,  xlab_rot=0,  xname_size = 12, xvals_size = 12, 
                          xaxs = TRUE, xprobs = NULL, xprobs_size = 8, vertical_xprobs = TRUE, 
                          ispace = list(bottom = 8, 
                                        left = 2,
                                        top = 2, 
                                        right = 5 ),
                          legend = FALSE, 
                          col = NULL, bottomcol="steelblue", topcol="snow2", lcol = "black", 
                          draw = TRUE, newpage = TRUE, 
                          lock_aspect = TRUE) {
    formula <- y
    # extract response vaiable from formula
    y <- all.vars(formula[[2]])
    # extract conditional variables from formula
    if (is.null(x)) {x <- all.vars(formula[[3]])} 
    if (any(x == ".")) {
        # take the conditional variables as removing responsible variable from all variables
        if (is.data.frame(data)) {
            allvars <- colnames(data)
            allvars <- allvars[allvars!="Freq"]
        } else if (is.table(data)){
            allvars <- names(dimnames(data))
        } else if (is.array(data)) {
            allvars <- names(dimnames(data))
        } else {
            # print error message and quit
            stop("data argument must be either a table or a data frame.")
        }
        x <- allvars[allvars!=y]
    }

    # call eikos function with new parameters y and x
    eikos.default(y = y, x = x, data = data , marginalize = marginalize, 
                  main = main, main_size = main_size, 
                  ylabs = ylabs,  ylab_rot = ylab_rot,  yname_size = yname_size, yvals_size = yvals_size, 
                  yaxs = yaxs, yprobs = yprobs, yprobs_size = yprobs_size,
                  xlabs = xlabs,  xlab_rot = xlab_rot,  xname_size = xname_size, xvals_size = xvals_size, 
                  xaxs = xaxs, xprobs = xprobs, xprobs_size = xprobs_size, vertical_xprobs = vertical_xprobs, 
                  ispace = ispace,
                  legend = legend, 
                  col = col, bottomcol = bottomcol, topcol = topcol, lcol = lcol, 
                  draw = draw, newpage = newpage, lock_aspect = lock_aspect
                  )
}

