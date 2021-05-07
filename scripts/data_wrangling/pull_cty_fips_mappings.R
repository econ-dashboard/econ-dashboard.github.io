################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Gather and process the county FIPS mappings from the Census. 
# The script generates a csv for all available counties, and for each county,
# provides the FIPS code, name of the area, and the file path/URL for the county's
# HTML page.
# Notes: Pulls the 2019 FIPS codes for all states, counties, minor divisions, and
# incorporated places via a URL. A copy of this data is also stored locally should
# the URL ever fail to work.
################################################################################

if (!running_pipeline) source("lib/load_r_libraries.R")

print("Pulling county-FIPS code mappings data...")

# Saves the data source URL and output location to variables.
cty_fips_url_in <- "https://www2.census.gov/programs-surveys/popest/geographies/2019/all-geocodes-v2019.xlsx"
cty_fips_path_out <- "data/processed/reference_data/county_fips_mappings.csv"

# Reads in the source XLSX (Excel) file from the URL, skipping the first four
# lines since they are simply descriptive info.
data_raw_fips_mappings <- 
	openxlsx::read.xlsx(
		cty_fips_url_in, 
		startRow = 4, 
		sep.names= " "
	)

# Generates a dataframe from the raw data that includes each state and its 2-digit
# FIPS code.
state_fips_mappings <-
	data_raw_fips_mappings %>% 
	filter(`Summary Level` == "040") %>% 
	select(
		state_fips = `State Code (FIPS)`,
		state = `Area Name (including legal/statistical area description)`
	)

# Generates a dataframe containing the cleaned and processed county FIPS mappings.
cty_fips_mappings <- 
	data_raw_fips_mappings %>%
	
	# Filters the raw data to just the records which are for counties or
	# county-equivalent geographies (i.e. boroughs in Alaska or parishes in
	# Louisiana). Checks to make sure that the designation is at the end of the
	# string (i.e. would exclude "Parish City").
	filter(
		str_detect(
			`Area Name (including legal/statistical area description)`,
			"County$|Borough$|Parish$"
		)
	) %>% 
	rename(state_fips = `State Code (FIPS)`) %>% 
	
	# Joins the county-level data to the state data for construction of unique 
	# FIPS codes, names, and file paths.
	left_join(state_fips_mappings, by = "state_fips") %>% 
	transmute(
		
		# Constructs the 5 digit county-specific FIPS codes.
		fips_code = str_c(state_fips, `County Code (FIPS)`),
		county = `Area Name (including legal/statistical area description)`,
		state,
		
		# Constructs the display name for each area.
		area = str_c(county, ", ", state),
		
		# Constructs the file path/URL for each area.
		# TO-DO: May consider making this URL just the unique FIPS code.
		area_formatted = 
			area %>% 
			str_remove_all(",") %>% 
			str_to_lower() %>% 
			str_replace_all(" |/", "-"),
		county_page_url = 
			paste0("site/county-pages/", area_formatted, "-", fips_code, ".html")
	) %>% 
	arrange("fips_code")

# Writes the processed data to a csv file in the `data/processed/reference_data`
# folder.
cty_fips_mappings %>% write_csv(cty_fips_path_out)

print("County-FIPS code mappings pulled and processed. Data is stored in data/processed/reference_data/.")