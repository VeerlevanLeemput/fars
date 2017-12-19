#' Read csv data
#'
#' This function reads the data in a csv file and transforms it to a R table dataframe.
#'
#' @details If the file does not exist the function returns an error message.
#'
#' @param filename Character string
#'
#' @return This function returns a table data frame.
#'
#' @examples
#' \dontrun{
#' fars_read("filename.csv")
#' }
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' Print filename for a provided year
#'
#' This function prints a character vector consisting of a filename format combined with the passed year argument.
#'
#' @param year An integer
#'
#' @return This function returns a character vector containing a combination of text and provided year number.
#'
#' @examples
#' \dontrun{
#' make_filename(2017)
#' make_filename(2018)
#' }
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' Generate a dataframe with months and years for a provided series of years
#'
#' This function reads multiple csv files for a given series of years, to provide an overview of months and years in those files.
#'
#' @details If a year is provided for which no data file is found, the function returns an error message.
#'
#' @param years A vector of integers
#'
#' @return This function returns a dataframe with for each year the month numbers in the datafile.
#'
#' @importFrom dplyr mutate select %>%
#'
#' @examples
#' \dontrun{
#' fars_read_years(2017)
#' fars_read_years(c(2013, 2014, 2015))
#' }
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' Summarize data per month for a series a provided years
#'
#' This function generates an overview of the number of accidents per month in the provided year(s).
#'
#' @param years A vector of integers
#'
#' @return This function returns a dataframe with the number of accidents by month and year.
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2017)
#' fars_summarize_years(c(2013, 2014, 2015))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' Plot a map showing all accidents in a given state and year
#'
#' This function plots a map with all the accident recorded in the given state and year, when the state number and year are provided.
#'
#' @details If the provided state number does not exist in the data for the given year, the function
#' returns an error message.
#'
#' @details If there are no accidents in a given state and year, the function returns an error message.
#'
#' @param state.num an integer
#' @param year an integer
#'
#' @return This function returns a graphical object containing locations of accidents.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' fars_map_state(16, 2017)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
