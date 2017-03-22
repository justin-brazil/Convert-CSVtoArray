#####################SCRIPT_CONTROLS##
#!#Name:   Convert-CSVtoArray
#!#Author:   Justin Brazil
#!#Description:  Converts a CSV file to a custom object array (CSV Headers required)
#!#Tags:  CSV,Array,Convert,Object,Data,Data Manipulation,Hash,Table,Custom,Custom Object,Import,Parse
#!#Type:  Function
#!#Product:  PowerShell
#!#Modes:  Scripting
#!#Notes:   Written because Import-CSV outputs hash tables rather than custom object arrays
#!#Link:    
#!#Group:  Data Manipulation
#!#Special: Universal
####################/SCRIPT_CONTROLS##
#UNIVERSAL

<#------------------------------------------------------------------    
 OUTLINE:   
		* Imports CSV file
		* Splits by specified delimiter
		* Counts number of columns
		* Adds headers to temporary hash lookup table
		* Steps through lines of CSV files
		* Creates temporary custom object for each line, with property names matched to table headers (via header lookup table)
		* Adds custom object to master $RESULTS array
     	* Returns $RESULTS array as object

 NOTES:  Script will automatically detect number of columns                                                      
--------------------------------------------------------------------#>




function Convert-CSVtoArray
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $false,
				   HelpMessage = 'Specify the path to the CSV file used for input here')]
		[Alias('Path')]
		[string]$CSVFile,
		[Parameter(Mandatory = $false,
				   HelpMessage = 'Specify a delimiter for the CSV data')]
		[string]$Delimiter = ','
	)
	<#
	.SYNOPSIS
		Converts a CSV file to a custom object array (CSV Headers required)
	
	.DESCRIPTION
		OUTLINE:
		* Imports CSV file
		* Splits by specified delimiter
		* Counts number of columns
		* Adds headers to temporary hash lookup table
		* Steps through lines of CSV files
		* Creates temporary custom object for each line, with property names matched to table headers (via header lookup table)
		* Adds custom object to master $RESULTS array
		* Returns $RESULTS array as object
		
		NOTES:  Script will automatically detect number of columns
	
	.PARAMETER CSVFile
		The file path for the CSV input file
	
	.PARAMETER Delimiter
		The delimiter used in the CSV file (defaults to ",")
	
	.NOTES
		Script will automatically detect number of columns 
	#>
	
	
######### PARSE CSV CONTENT ########
	$TEMP_CSV_RAW_CONTENT = Get-Content $CSVFILE #The contents of the CSV file
	$TEMP_CSV_HEADERS = $TEMP_CSV_RAW_CONTENT[0].Split($DELIMITER) #Finds headers by taking the first line of the CSV file and splitting via the delimiter
	$TEMP_FIELD_COUNTER = $NULL #Used for calculating the number of columns contained in the CSV file
	
######### POPULATE HEADER LOOKUP TABLE ########	
	
	$Global:TEMP_FIELD_LOOKUP = @{ } #Creates an empty lookup table to hold Header Names and their associated column number
	
	ForEach ($COLUMN in $TEMP_CSV_HEADERS) #Populates Header lookup table
	{
		$TEMP_FIELD_COUNTER += 0 #Incremental counter to associated header name with column number
		
		$Global:TEMP_FIELD_LOOKUP.Add($TEMP_FIELD_COUNTER, $COLUMN) #Populates Header lookup table
		
		$TEMP_FIELD_COUNTER = ($TEMP_FIELD_COUNTER + 1) #Increments counter by 1
	}
	
######### PARSE CSV DATA  ########	
	$RESULTS_OUTPUT = @() #Creates empty array to hold final results
	
	ForEach ($LINE in $TEMP_CSV_RAW_CONTENT[1..($TEMP_CSV_RAW_CONTENT.Count)]) #Loops through all but the first line of the CSV file to parse content
	{
		$TEMP_LINE_SPLIT = $LINE.SPLIT($DELIMITER) #Splits the line by the delimiter
		
		$TEMP_LINE_OBJECT = New-Object -TypeName PSObject #Creates a new object for each iteration of the loop to store split contents.  This will be added to the $RESULTS flie one line at a time
		
		$TEMP_HEADER_LOOKUP_NUMBER = 0 #Incremental counter used to look up headers using the Header reference table							
		
	######### PARSE LINE DATA AND ADD HEADERS ########			
		
		ForEach ($SPLIT in $TEMP_LINE_SPLIT) #Iterates through each column and adds the data to the custom object, using the Header found in the Header lookup table as the property name
		{
			$TEMP_HEADER_LOOKUP_NUMBER += 0 #Incremental counter used to look up headers using the Header reference table							
			
			$TEMP_LINE_OBJECT | Add-Member -MemberType NoteProperty -Name $Global:TEMP_FIELD_LOOKUP.$TEMP_HEADER_LOOKUP_NUMBER -Value $SPLIT #Populates custom object that holds line data split by column name
			
			$TEMP_HEADER_LOOKUP_NUMBER = $TEMP_HEADER_LOOKUP_NUMBER + 1 #Increments counter (associates Header name via Header table lookup)
		}
		
######### RETURN RESULTS  ########			
		$RESULTS_OUTPUT += $TEMP_LINE_OBJECT #Adds the custom object holding the line data into the master $RESULTS output array
		
	}
	
	
	$RESULTS_OUTPUT #Returns the array of custom objects as output
}
