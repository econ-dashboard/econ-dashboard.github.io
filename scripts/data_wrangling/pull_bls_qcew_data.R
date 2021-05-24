################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Gather and process BLS QCEW data for the number of establishments
# and avg. weekly wages by quarter and county. This script generates a csv for 
# each county in the data
# Notes: As is, this script will break as soon as the earliest quarter (2014 Q1)
# is no longer available using the BLS URL/API this script uses. Future updates
# need to be made to auto-calculate the earliest available data, or alternatively,
# only pull in new data that isn't already stored. The latter may be quicker and
# more efficient.
################################################################################

if (!exists("running_pipeline")) source("lib/load_r_libraries.R")

# Start timer
tic("BLS QCEW data scrape")

writeLines("Pulling BLS QCEW establishments and wage data...")

# Relevant BLS data api and file paths for the FIPS mappings data and outpath for
# formatted CSV's.
bls_data_url_in <- "http://www.bls.gov/cew/data/api/"
fips_mappings_path_in <- "data/processed/reference_data/county_fips_mappings.csv"
bls_data_path_out <- "county-data/counties/"

# Set the time period for which you'd like to fetch the data. Will generate each
# fiscal quarter in between the specified period. Currently, data is available
# from the first quarter of 2014 to the third quarter of 2020.
period_start <- yq("2014-01")
period_end <- yq("2020-03")

# Initializes dataframe to hold BLS data as we pull it in from the API.
data_bls <- 
	tibble(
		fips_code = NA_character_,
		period = NA_character_,
		qtrly_estabs = NA_real_,
		avg_wkly_wage = NA_real_
	)

# Reads in the FIPS mappings generated in an earlier step to join to the pulled
# BLS data.
data_fips_mappings <-
	fips_mappings_path_in %>% 
	read_csv(col_types = cols())

# Constructs a list of all quarters for which data is available depending on the
# requested dates above.
available_periods <- 
	quarter(
		seq(period_start, period_end, by = "1 quarter"), 
		with_year = T
	) %>% 
	as.character()

# Iterates through each requested period and pulls BLS data by county and quarter
# on the number of establishments in a county and the avg. weekly wage during the
# quarter.
for (period in available_periods) {
	yr <- str_sub(period, start = 0L, end = 4L)
	qtr <- str_sub(period, start = 6L, end = 6L)
	
	data_path <- paste0(bls_data_url_in, yr, "/", qtr, "/industry/10.csv")
	
	data_bls <-
		data_path %>% 
		read_csv(col_types = cols()) %>% 
		filter(own_code == 0) %>% 
		transmute(
			fips_code = area_fips,
			period = str_c(year, "-", qtr),
			qtrly_estabs,
			avg_wkly_wage
		) %>% 
		rbind(data_bls)
}

# Combines the pulled BLS data with the area name using the FIPS mappings data
# generated in an earlier step.
data_bls <-
	data_fips_mappings %>% 
	left_join(data_bls, by = "fips_code") %>% 
	select(
		fips_code,
		area,
		period,
		qtrly_estabs,
		avg_wkly_wage
	) %>% 
	arrange(fips_code, period)

# Writes out a CSV of the data for every county in the data.
for (fip in available_fips) {
	data_bls %>% 
		filter(fips_code == fip) %>% 
		write_csv(str_c(bls_data_path_out, fip, "/bls_data_", fip, ".csv"))
}

writeLines("BLS QCEW data successfully pulled and stored at county-data/counties/<county fips>/.")

# End timer
toc()
writeLines("")