library(readxl)
library(readr)

library(tidyverse)
library(cowplot)
library(colorspace)
library(ggrepel)

#Exp <- read_excel("Exp.xlsx")

#dftest <- read_csv("IDI_last version.csv")

#data = left_join(dftest,Exp, by = "country")

#write.csv(data,file = "exp.csv")

data <- read_csv("HDI-B.csv")

test <- data %>%
  mutate(
    region = case_when(
      region == "Middle East and North Africa" ~ "Middle East\nand North Africa",
      region == "Europe and Central Asia" ~ "Europe and\nCentral Asia",
      region == "East Asia and Pacific" ~ "East Asia and\n Pacific",
      region == "Latin America and The Caribbean" ~ "Latin America and\n The Caribbean",
      region == "North America" ~ "North America",
      region == "South Asia" ~ "South Asia",
      region == "Sub-Saharan Arica" ~ "Sub-Saharan Arica",
      TRUE ~ region # All the other remain the same
    )
  )

country_highlight <- c(
  "Senegal","Tajikistan","Jordan","Norway",
  "Chad","Namibia","Gabon","Mauritius",
  "United States of America","China","Germany",
  "Sudan","Russia","Iraq"
)

test <- test %>%
  mutate(
    label = ifelse(country %in% country_highlight, country, "")
  )


expohi = ggplot(test, aes(HDI, B)) +
  geom_smooth(method="lm", formula = 'y ~ poly(x,2)' , col="black") +
  geom_point(
    aes(color = region, fill = region),
    size = 2.5, alpha = 0.5, 
    shape = 21 # This is a dot with both border (color) and fill.
  ) +
  # Add auto-positioned text
  geom_text_repel(
    aes(label = label),
    color = "black",
    size = 10/.pt, # font size 9 pt
    point.padding = 0.1, 
    box.padding = 0.6,
    min.segment.length = 0,
    max.overlaps = 1000,
    seed = 7654 # For reproducibility reasons
  ) +
  xlab("HDI") +
  ylab("Global One Health Intrinsic Drivers Index scores")+
  theme_test() 

ggsave("HDI-IDI-region.pdf", width=8, height=4, dpi=600)

