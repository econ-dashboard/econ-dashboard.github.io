################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Gather and process the LAU annual average unemployment data by
# county since 1990. This script generates a csv for each county in the data
# Notes: 
################################################################################

if (!exists("running_pipeline")) source("lib/load_r_libraries.R")

# Start timer
tic("BLS LAU data scrape")

writeLines("Pulling BLS LAU unemployment data...")

# This path is a partial path and "<two-digit year>.xlsx" need to be appended to
# properly make the call to the source.
lau_data_url_in <- "https://www.bls.gov/lau/laucnty"
lau_data_path_out <- "site/county-data/counties/"

# Creates a list of two-digit years for which data is available.
available_years <-
	seq(1990, 2020, 1) %>% 
	as.character() %>% 
	str_sub(start = -2, end = -1)

data_lau <- 
	tibble(
		state_fips = NA_character_,
		cty_fips = NA_character_,
		area = NA_character_,
		year = NA_integer_,
		total_labor_force = NA_integer_,
		num_employed = NA_integer_,
		num_unemployed = NA_integer_,
		unemployment_rate = NA_real_
	)

for (year in available_years) {
	
	data_lau <-
		read.xlsx(
			str_c(lau_data_url_in, year, ".xlsx"), 
			startRow = 7, 
			colNames = F,
			cols = 2:10
		) %>% 
		rename(
			state_fips = X1,
			cty_fips = X2,
			area = X3,
			year = X4,
			total_labor_force = X5,
			num_employed = X6,
			num_unemployed = X7,
			unemployment_rate = X8
		) %>% 
		rbind(data_lau)
}

data_lau <- 
	data_lau %>% 
	mutate(fips = str_c(state_fips, cty_fips))

for (fip in available_fips) {
	data_lau %>% 
		filter(fips == fip) %>% 
		write_csv(str_c(lau_data_path_out, fip, "/lau_data_", fip, ".csv"))
}

writeLines("BLS LAU data successfully pulled and stored at site/county-data/counties/<county fips>/.")

# End timer
toc()
writeLines("")