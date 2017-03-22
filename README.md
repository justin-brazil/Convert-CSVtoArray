# Convert-CSVtoArray

### OVERVIEW  

  Converts a CSV file to a custom object array (CSV Headers are required), as opposed to the Hash Tables returned by IMPORT-CSV

### AUTHOR  

  Justin Brazil

### LICENSE  

  GNU GPLv3

### TYPE  

  Windows PowerShell Script

-------------------------------------------------

### LOGIC

* Imports CSV file
* Splits by specified delimiter
* Counts number of columns
* Adds headers to temporary hash lookup table
* Steps through lines of CSV files
* Creates temporary custom object for each line, with property names matched to table headers (via header lookup table)
* Adds custom object to master $RESULTS array 
* Returns $RESULTS array as object
