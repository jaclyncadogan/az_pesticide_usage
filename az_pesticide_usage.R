# Load libraries
library(dplyr)
library(ggplot2)


# add a Total column to add pesticide usage across crop groups
crop_groups = c("Corn", "Soybeans", "Wheat", "Cotton", "Vegetables_and_fruit", "Rice", "Orchards_and_grapes", "Alfalfa", "Pasture_and_hay", "Other_crops")
raw_data$Total <- rowSums(raw_data[,crop_groups], na.rm=TRUE)

# filter for Arizona entries only, then add Compound, Year, and Total columns to new dataframe
az9217 <- raw_data %>%
  filter(State == "Arizona") %>%
  select(Compound, Year, Total)
az9217

# filter by compounds that appear in a majority of years
all_years <- az9217 %>%
  group_by(Compound) %>%
  filter(Total > 0) %>%
  filter(n()>12)
all_years

# create vector of compound names
all_compounds <- unique(all_years$Compound)

# create dataframe to store compounds with positive total increase
increases.total <- data.frame(matrix(ncol = 3, nrow = 0))
names.cols <- c("compound", "total_incr", "r")
colnames(increases.total) <- names.cols

# loop through each compound subgroup
for (i in all_compounds) {
  data <- all_years %>%
    filter(Compound == i)
  # create a linear model, then pull the r and slope from it
  model <- lm(Total ~ Year, data=data)
  r <- sqrt(summary(model)$r.squared)
  slope <- model$coefficients[2]
  # if the slope is positive and correlation is high, plot the model and add the info to a new dataframe
  if (slope > 0 && r >= 0.5) {
    plot(Total ~ Year, data=data, main = i) +
      abline(lm(Total ~ Year, data=data))
    increases.total[nrow(increases.total) + 1,] = c(i, slope, r)
  }
}

# convert total_incr and r columns to numeric type, then sort in descending order
increases.total$total_incr <- round(as.numeric(increases.total$total_incr), digits = 2)
increases.total$r <- round(as.numeric(increases.total$r), digits=3)

increases.total %>%
  arrange(desc(total_incr))

# have to manually check for statistical significance of each compound, I guess??
# replace compound name as needed.
data2 <- all_years %>%
  filter(Compound == 'OXYTETRACYCLINE')
model <- lm(Total ~ Year, data=data2)
summary(model)

# REMOVE: SPIROMESIFEN, FLUMIOXAZIN

types = c("herbicide", "herbicide", "antimicrobial", "herbicide", "insecticide", "insecticide", "fungicide", "fungicide", "fungicide", "fungicide", "herbicide", "insecticide", "herbicide", "fungicide", "insecticide", "insecticide", "herbicide", "antimicrobial")

final_results <- increases.total %>%
  filter(!row_number() %in% c(18, 9)) %>%
  arrange(desc(total_incr))

final_results$type <- types
final_results

# export final_results
write.csv(final_results, "final_results.csv", row.names=FALSE)
