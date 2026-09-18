
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("cowplot", quietly = TRUE)) {
  install.packages("cowplot")
}
library(readr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(tidyr)
ratings <- read_csv('./data/user_ratings.csv', col_names = c("ImageNumber", "Rating"))
tags <- read_csv('./tags/tags.csv')

tags <- tags %>%
  mutate(Tags = strsplit(as.character(Tags), ",")) %>%
  unnest(Tags)
print(names(ratings))
print(names(tags)) 

data <- ratings %>%
  left_join(tags, by = "ImageNumber")
average_ratings <- data %>%
  group_by(Tags) %>%
  summarise(AverageRating = mean(Rating, na.rm = TRUE)) %>%
  arrange(desc(AverageRating))

average_image_ratings <- data %>%
  group_by(ImageNumber) %>%
  summarise(AverageImageRating = mean(Rating, na.rm = TRUE))

rating_distribution <- ggplot(ratings, aes(x = Rating)) +
  geom_histogram(binwidth = 1, fill = 'blue', color = 'black') +
  labs(title = '評価の分布', x = '評価', y = '頻度')

average_ratings_plot <- ggplot(average_ratings, aes(x = reorder(Tags, -AverageRating), y = AverageRating)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  coord_flip() +
  labs(title = 'タグごとの平均評価', x = 'タグ', y = '平均評価')
average_image_ratings_plot <- ggplot(average_image_ratings, aes(x = reorder(ImageNumber, -AverageImageRating), y = AverageImageRating)) +
  geom_bar(stat = 'identity', fill = 'coral') +
  coord_flip() +
  labs(title = '画像ごとの平均評価', x = '画像番号', y = '平均評価')

combined_plot <- plot_grid(
  rating_distribution, 
  average_ratings_plot, 
  average_image_ratings_plot, 
  labels = c('A', 'B', 'C'),
  ncol = 1
)

ggsave("combined_plots.png", plot = combined_plot, width = 12, height = 18)
