################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Runs the data pipeline in four steps:
		# (1) Gathers all the necessary data for the project
		# (2) Wrangles and cleans the data
		# (3) Pulls the relevant templating variables unique to each county's HTML page
		# (4) Generates an HTML page for each county for which we have data
# Notes: Executing this script should populate all necessary data for the
# project by calling on other scripts.
################################################################################

source("lib/load_r_libraries.R")

running_pipeline <- TRUE

source("scripts/data_wrangling/pull_cty_fips_mappings.R")
source("scripts/data_wrangling/pull_lau_data.R")
source("scripts/data_wrangling/pull_bls_qcew_data.R")
source("scripts/templates/generate_county_pages.R")
