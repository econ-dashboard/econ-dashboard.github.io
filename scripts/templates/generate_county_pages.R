################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Create an HTML page for every county for which we have data
# available.
# Notes: Pulls in previously processed data and variables to generate the dynamic
# data/text which will populate the county page HTML template.
################################################################################

if (!running_pipeline) source("lib/load_r_libraries.R")

print("Generating HTML files for each available county...")

# Saves the template and processed county FIPS data file paths to variables.
template_filepath <- "scripts/templates/template-detail-page.html"
cty_fips_filepath <- "data/processed/reference_data/county_fips_mappings.csv"

# Reads in the template and county FIPS data.
template <- read_file(template_filepath)
data_county_names <- read_csv(cty_fips_filepath)

# Iterates through each row in the county FIPS data and pulls the county, state,
# and constructed file path to output the county page HTML file. Any data that
# is used in the template is passed within a list to the `template_data` variable
# which is ultimately fed into `whisker` for template generation.

# TO-DO: As the data pipeline is fleshed out and the template is updated, this
# process may grow larger. We'll need to think through the best way to do it as
# that happens.
for (record in 1:nrow(data_county_names)) {
	template_data <-
		list(
			county_name = data_county_names[record, "county"],
			state = data_county_names[record, "state"]
		)

	writeLines(
		whisker.render(template, template_data),
		data_county_names[record, "county_page_filepath"] %>% pull()
	)
}

print("All HTML files generated! HTML files are stored in site/county-pages/.")