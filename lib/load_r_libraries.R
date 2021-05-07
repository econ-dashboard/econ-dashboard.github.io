################################################################################
# Authors: Rachel Oh, Michael Spencer
# Project: BNA-ECON-N-METRICS
# Script Purpose: Load relevant R packages for project
# Notes: These are neccessary R packages to run the data pipeline for this
# project. If you have such packages already installed, feel free to comment out
# the relevant lines so as not to make uneeded changes to your local environment.

# TO-DO: Think through more elegant solution to installing packages on others'
# machines.
################################################################################

# For each line below, we check to see if the relevant library is already
# installed. If so, we load it, if not, we install it, then load it.
if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

if (!require(whisker)) install.packages("whisker")
library(whisker)