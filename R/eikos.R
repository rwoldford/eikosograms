#' Generic method for creating an eikosogram
#'

#' @param y Either the name of a variable in the data set (eikos.default), or a formula of such variables (eikos.formula).
#' @param ... includes a data argument as well as other arguments for features of the display
#' @seealso \code{\link{eikos.default}}
#' @seealso \code{\link{eikos.formula}}
#' @export
eikos <- function(y, ...) {
    UseMethod("eikos")
}

#' @title Create a new eikosogram
#'
#' @description Return a grid graphic object (grob) and draw an eikosogram if draw = TRUE.
#'
#' @param y name of the response variable (vertical axis)
#' @param x name(s) of any conditional variable(s) (horizontal axis)
#' @param data data frame or table
#' @param marginalize variable(s) to marginalize on, or NULL if none
#' @param bottomcol bottom colour
#' @param topcol top colour
#' @param lcol colour of lines
#' @param draw logical, whether to draw eikosogram.
#' @param newpage logical, whether to draw on a newpage.
#' @param xlabs logical, whether x labels should appear or not.
#' @param ylabs logical, whether y labels should appear or not.
#' @param xaxs logical, whether x axis should appear or not.
#' @param yaxs logical, whether y axis should appear or not.
#' @param xprobs probabilities to be shown on x-axis. NULL if they should be calculated from the data.
#' @param yprobs probabilities to be shown on y-axis. NULL if they should be calculated from the data.
#' @param vertical_xprobs logical, whether probabilities on x axis should be rotated vertically.
#' @param main title of plot
#' @param main_size font size of title (points)
#' @param label_size font size of labels (points)
#' @param xlab_rot rotation of x labels
#' @param ylab_rot rotation of y labels
#' @param ospace list of four items (bottom, left, top, right) indicating the margin of texts around the diagram
#' @param axis_name_size font size of axis names (points)
#' @param legend logical, whether to include legend
#' @param lock_aspect logical, whether to force 1:1 aspect ratio.
#'
#' @examples
#' eikos("Hair", "Eye", data=HairEyeColor, legend = TRUE)
#'
#' @export
eikos.default <- function(y, x=NULL, data=NULL,
    marginalize=NULL, bottomcol="steelblue", topcol="snow2",
    lcol = "black", draw = TRUE, newpage = TRUE, xlabs = TRUE, ylabs = TRUE, xaxs = TRUE, yaxs = TRUE,
    xprobs = NULL, yprobs = NULL, vertical_xprobs = TRUE, main = "", main_size = 16, label_size = 10,
    xlab_rot = 0, ylab_rot=0, ospace = list(bottom = unit(2,"points"), left=unit(2,"points"),
        top=unit(2,"points"), right=unit(2,"points")),
    axis_name_size = 12, legend = FALSE, lock_aspect = FALSE) {


    # response variable cannot be more than one
    if(length(y) > 1) {
        stop("y must be a single response variable.")
    }

    # conditional variable cannot contain response variable
    if(y %in% x) {
        stop("Response variable must be different from conditioning variables.")
    }
    
    if(newpage & draw) grid.newpage()
    
    # sets margin between eikosogram and labels.
    margin <- unit(2, "points")
    legend_margin <- ospace[[4]]
    title_margin <- ospace[[3]]
    ylab_margin <- ospace[[2]]
    xlab_margin <- ospace[[1]]
    xprobs_margin <- ospace[[3]]
    yprobs_margin <- ospace[[4]]

    # transform data
    idf <- eikos_data(y, x,  data, marginalize)

    # create colour palette
    responses <- as.vector(unique(idf[,y]))
    colour_palette <- colorRampPalette(c(bottomcol,topcol))(length(responses))
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
        gp =  gpar(fill = colour_palette[ idf[,y] ], col = lcol))

    # get axes text
    labels <- list( x = nullGrob(), y = nullGrob() )
    if(ylabs) {
        labels$y <- eikos_y_labels(y, idf, margin = ylab_margin, lab_rot=ylab_rot)
    }

    x_names <- nullGrob()
    if(xlabs & (!is.null(x))) {
        x_grobs <- eikos_x_labels(x, idf, margin = xlab_margin, axis_name_size, lab_rot=xlab_rot)

        labels$x <- x_grobs$labels
        x_names <- x_grobs$names
    }

    probs <- list(x = frameGrob(layout = grid.layout(1, 1,widths = unit(1,"npc"), heights = unit(4, "points"))),
        y = frameGrob(layout = grid.layout(1, 1,heights = unit(1,"npc"), widths = unit(4, "points"))))

    # get axes
    if(xaxs & !is.null(x)) {
        probs$x <- eikos_x_probs(idf, xprobs, margin = xprobs_margin, rotate = vertical_xprobs)
    }
    if(yaxs) {
        probs$y <- eikos_y_probs(idf, yprobs, margin = yprobs_margin)
    }

    # get legend
    lgnd <- nullGrob()
    if(legend) {
        lgnd <- eikos_legend(responses, colour_palette, margin = legend_margin)
    }

    # get plot title
    title <- nullGrob(name = "title")
    if(main != "") {
        title <- textGrob(main, gp = gpar(fontsize = main_size), name = "title")
    }

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

    viewport <- pushViewport(viewport(gp = gpar(fontsize = label_size)))
    layout <- grid.layout(rows, columns,
        widths = widths,
        heights =  heights,
        respect = lock_aspect)

    # assemble eikosogram
    object <- frameGrob(layout = layout)
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



#' Draw eikosogram from formula
#'
#' @param formula formula giving conditional as the sum of named response variables
#' @param data data frame or table
#' @param marginalize variable to marginalize on, or NULL if none
#' @param bottomcol bottom colour
#' @param topcol top colour
#' @param lcol colour of lines
#' @param draw logical, whether to draw eikosogram.
#' @param newpage logical, whether to draw on a new page
#' @param xlabs logical, whether x labels should appear or not.
#' @param ylabs logical, whether y labels should appear or not.
#' @param xaxs logical, whether x axis should appear or not.
#' @param yaxs logical, whether y axis should appear or not.
#' @param xprobs probabilities to be shown on x-axis. NULL if they should be calculated from the data.
#' @param yprobs probabilities to be shown on y-axis. NULL if they should be calculated from the data.
#' @param vertical_xprobs logical, whether probabilities on x axis should be rotated vertically.
#' @param main title of plot
#' @param main_size font size of title (points)
#' @param label_size font size of labels (points)
#' @param xlab_rot rotation of x labels
#' @param ylab_rot rotation of y labels
#' @param ospace list of four items (bottom, left, top, right) indicating the margin of texts around the diagram
#' @param axis_name_size font size of axis names (points)
#' @param legend logical, whether to include legend
#' @param lock_aspect logical, whether to force 1:1 aspect ratio.
#'
#' @examples
#' eikos(Eye ~ Hair + Sex, data=HairEyeColor)
#'
#' @export
eikos.formula <- function(formula, data=NULL,
    marginalize=NULL, bottomcol="steelblue", topcol="snow2",
    lcol = "black", draw = TRUE, newpage = TRUE, xlabs = TRUE, ylabs = TRUE, xaxs = TRUE, yaxs = TRUE,
    xprobs = NULL, yprobs = NULL, vertical_xprobs = TRUE, main = "", main_size = 16,
    label_size = 10, xlab_rot = 0, ylab_rot=0, ospace = list(bottom = unit(2,"points"),
        left=unit(2,"points"), top=unit(2,"points"), right=unit(2,"points")),
    axis_name_size = 12, legend = FALSE, lock_aspect = FALSE) {

    # extract response vaiable from formula
    y <- all.vars(formula[[2]])
    # extract conditional variables from formula
    x <- all.vars(formula[[3]])

    if (x == ".") {
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
    eikos.default(y, x, data, marginalize, bottomcol, topcol, lcol, draw, newpage, xlabs, ylabs,
        xaxs, yaxs, xprobs, yprobs, vertical_xprobs, main, main_size, label_size, xlab_rot, ylab_rot, ospace, axis_name_size, legend, lock_aspect)
}


