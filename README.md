# Linear Increases in Arizona Pesticide Usage, 1992 - 2017
Analysis of Arizona pesticide usage trends from 1992 to 2017.
This project aims to analyze which pesticides within Arizona have seen the greatest (linear) increase, as measured by kilograms applied per year.

Raw data is the HighEstimate_AgPestUsebyCropGroup92to17_v2.txt dataset from Estimated Annual Agricultural Pesticide Use by Major Crop or Crop Group for States of the Conterminous United States, 1992-2017 (ver. 2.0, May 2020), published by the USGS's Pesticide National Synthesis Project. The original, unaltered table is called raw_data.txt within this repo, but all tables and metadata can be found at https://doi.org/doi:10.5066/F7NP22KM

All data analysis was performed using RStudio. The script I used is az_pesticide_usage.R. Load in the raw_data.txt table to the environment, run the script, and you should end up with the exported final_results.csv, which is also included in this repo.
