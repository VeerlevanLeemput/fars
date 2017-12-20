# Project Title

fars package for Coursera course

# Installation

This package is used as a development version on GitHub and was built for passing a course on Coursera. To use the package, you can install it directly from GitHub using `install_github` from `devtools`. 

The following code will install the package `fars`: 

```R
library(devtools)
install_github("VeerlevanLeemput/fars")
library(fars)
```

## Data included in the package

There are three datasets included in the package. This data includes information on accidents of 2013, 2014 and 2015. Sample data is available and can be obtained by the following code:

```R
filepath1<-system.file("extdata", "accident_2013.csv.bz2", package = "fars")
filepath2<-system.file("extdata", "accident_2014.csv.bz2", package = "fars")
filepath3<-system.file("extdata", "accident_2015.csv.bz2", package = "fars")
```

## fars_functions

The package provides several functions to help read, summarise and visualise the data. These are `fars_read`, `make_filename`, `fars_read_years`,  `fars_summarize_years` and `fars_map_state`.

Use of the above mentioned functions are shown below.

### fars_read
This function reads the fars data files and transforms to a workable R dataframe table.

```R
fars_read("filename.csv")
```

### make_filename
This function provides a filename, when a certain year is given. This way filenames will be consistent.

```R
make_filename(2017)
```

### fars_read_years
The function `fars_read_years` generates a dataframe with months and years for a provided series of years. This way, you will be able to quickly overview what months and years are avaible.

```R
fars_read_years(c(2013, 2014, 2015))
```

### fars_summarize_years

The `fars_summarize_years` function summarises the total number of accidents by month and year.

Enter years as a vector or integer years in YYYY format (eg 2013).

```R
fars_summarize_years(c(2013, 2014, 2015))
```

### fars_map_state

The `fars_map_state` function generates of map of the location of accidents within the specified US state during the specified year.

Enter the State number (eg 1) and the year to be analysed in YYYY format eg 2011.

```R
fars_map_state(1, 2014)
```
## Authors

Veerle van Leemput

## License

This project is licensed under the GPL License.

