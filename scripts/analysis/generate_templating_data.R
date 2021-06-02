################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Generate the relevant data points that are used to populate
# each county's detail page.
# Notes: This script is called once for every county page that is generated.
################################################################################

if (!exists("running_pipeline")) source("lib/load_r_libraries.R")

# Generates the relevant data file paths for the county page that is being generated
bls_data_path <- str_c("county-data/counties/", fips, "/bls_data_", fips, ".csv")
lau_data_path <- str_c("county-data/counties/", fips, "/lau_data_", fips, ".csv")

# Reads in the BLS data and generates the year and quarter for display in the
# web page.
bls_data <- 
	read_csv(bls_data_path, col_types = c("dccdd")) %>% 
	mutate(
		year = str_sub(period, 1, 4),
		quarter_num = str_sub(period, 6, 6),
		quarter = case_when(
			quarter_num == "1" ~ "first quarter",
			quarter_num == "2" ~ "second quarter",
			quarter_num == "3" ~ "third quarter",
			quarter_num == "4" ~ "fourth quarter"
		)
	)

# Reads in the LAU data.
lau_data <- read_csv(lau_data_path, col_types = c("cccdddddc"))

# All of the data capture below counts on the fact that the data has been presorted.
# Thus, for the BLS metrics (qtrly_estabs and avg_wkly_wage), we can simply take
# the last entry in the dataframe to be the most recent. For the LAU data, we take
# the first entry in the dataframe to be the most recent.

# The following captures the latest date/period and second latest date
# for which BLS data exists.
bls_date_quarter <- bls_data[nrow(bls_data), "quarter"]
bls_date_year <- bls_data[nrow(bls_data), "year"]

# Captures the relevant metrics about business establishments. 
qtrly_estabs <- bls_data[nrow(bls_data), "qtrly_estabs"]
qtrly_estabs_last_period <- bls_data[nrow(bls_data) - 1, "qtrly_estabs"]
qtrly_estabs_pct_change <- ((qtrly_estabs - qtrly_estabs_last_period)/qtrly_estabs_last_period)

# Captures the relevant metrics about wages. 
avg_wkly_wage <- bls_data[nrow(bls_data), "avg_wkly_wage"]
avg_wkly_wage_last_period <- bls_data[nrow(bls_data) - 1, "avg_wkly_wage"]
avg_wkly_wage_pct_change <- ((avg_wkly_wage - avg_wkly_wage_last_period)/avg_wkly_wage_last_period) 

# Captures the relevant metrics about unemployment. 
unemployment_rate <- lau_data[1, "unemployment_rate"]
unemployment_rate_date <- lau_data[1, "year"]
unemployment_rate_last_period <- lau_data[2, "unemployment_rate"]
unemployment_rate_pct_change <- ((unemployment_rate - unemployment_rate_last_period)/unemployment_rate_last_period)