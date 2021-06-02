################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Create an HTML page for every county for which we have data
# available.
# Notes: Pulls in previously processed data and variables to generate the dynamic
# data/text which will populate the county page HTML template.
################################################################################

if (!exists("running_pipeline")) source("lib/load_r_libraries.R")

# Start timer
tic("HTML page creation")

writeLines("Generating HTML files for each available county...")

# Saves the template and processed county FIPS data file paths to variables.
template_filepath <- "scripts/templates/template.html"
cty_fips_filepath <- "data/processed/reference_data/county_fips_mappings.csv"

# Gets the date for display on the live site
data_pull_date <- today()

# Reads in the template and county FIPS data. The string of c's simply specifies
# that the columns can all be read in as character columns to avoid a parsing
# message.
template <- read_file(template_filepath)
data_county_names <- 
	read_csv(cty_fips_filepath, col_types = "ccccccccc") %>% 
	# Filters out Puerto Rico since there is not recent data
	filter(state_fips != 72)

# Iterates through each row in the county FIPS data and pulls the relevant 
# county-level metrics by running the 1generate_templating_data` script. 
# Any data that is used in the template is passed within a list to the 
# `template_data` variable which is ultimately fed into `whisker` for template 
# generation.

# TO-DO: As the data pipeline is fleshed out and the template is updated, this
# process may grow larger. We'll need to think through the best way to do it as
# that happens.
for (record in 1:nrow(data_county_names)) {
	
	fips = data_county_names[record, "fips_code"]
	
	source("scripts/analysis/generate_templating_data.R")
	
	template_data <-
		list(
			data_pull_date = data_pull_date,
			fips = fips,
			area_name = data_county_names[record, "area"],
			bls_date_quarter = bls_date_quarter,
			bls_date_year = bls_date_year,
			qtrly_estabs = qtrly_estabs %>% pull() %>% number(big.mark = ","),
			qtrly_estabs_last_period = qtrly_estabs_last_period %>% pull() %>% number(big.mark = ","),
			qtrly_estabs_pct_change = qtrly_estabs_pct_change %>% pull %>% percent(),
			avg_wkly_wage = avg_wkly_wage %>% pull() %>% number(big.mark = ",", prefix = "$"),
			avg_wkly_wage_last_period = avg_wkly_wage_last_period %>% pull() %>% number(big.mark = ",", prefix = "$"),
			avg_wkly_wage_pct_change = avg_wkly_wage_pct_change %>% pull %>% percent(),
			unemployment_rate = unemployment_rate %>% pull() %>% percent(scale = 1, accuracy = .01),
			unemployment_rate_date = unemployment_rate_date,
			unemployment_rate_last_period = unemployment_rate_last_period %>% pull() %>% percent(scale = 1, accuracy = .01),
			unemployment_rate_pct_change = unemployment_rate_pct_change %>% pull %>% percent()
		)

	writeLines(
		whisker.render(template, template_data),
		data_county_names[record, "county_page_filepath"] %>% pull()
	)
}

writeLines("All HTML files generated! HTML files are stored in county-pages/.")

# End timer
toc()
writeLines("")