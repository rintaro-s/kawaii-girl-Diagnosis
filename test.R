# app.R

# 必要なパッケージの読み込み
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
)

library(readr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(tidyr)  # `unnest` 関数を使用するため

# データの読み込み
ratings <- read_csv('./data/user_ratings.csv', col_names = c("ImageNumber", "Rating"))
tags <- read_csv('./tags/tags.csv')

# タグの分解
tags <- tags %>%
  mutate(Tags = strsplit(as.character(Tags), ",")) %>%
  unnest(Tags)

# 列名の確認
print(names(ratings))  # ImageNumber, Rating
print(names(tags))     # ImageNumber, Tags

# 評価データとタグの結合
data <- ratings %>%
  left_join(tags, by = "ImageNumber")

# 平均評価の計算
average_ratings <- data %>%
  group_by(Tags) %>%
  summarise(AverageRating = mean(Rating, na.rm = TRUE)) %>%
  arrange(desc(AverageRating))

# 各画像の平均評価
average_image_ratings <- data %>%
  group_by(ImageNumber) %>%
  summarise(AverageImageRating = mean(Rating, na.rm = TRUE))

# 評価の分布
rating_distribution <- ggplot(ratings, aes(x = Rating)) +
  geom_histogram(binwidth = 1, fill = 'blue', color = 'black') +
  labs(title = '評価の分布', x = '評価', y = '頻度')

# タグごとの平均評価の棒グラフ
average_ratings_plot <- ggplot(average_ratings, aes(x = reorder(Tags, -AverageRating), y = AverageRating)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  coord_flip() +
  labs(title = 'タグごとの平均評価', x = 'タグ', y = '平均評価')

# 画像ごとの平均評価の棒グラフ
average_image_ratings_plot <- ggplot(average_image_ratings, aes(x = reorder(ImageNumber, -AverageImageRating), y = AverageImageRating)) +
  geom_bar(stat = 'identity', fill = 'coral') +
  coord_flip() +
  labs(title = '画像ごとの平均評価', x = '画像番号', y = '平均評価')

# グラフをまとめて表示
combined_plot <- plot_grid(
  rating_distribution, 
  average_ratings_plot, 
  average_image_ratings_plot, 
  labels = c('A', 'B', 'C'),
  ncol = 1
)

# 画像ファイルとして保存
ggsave("combined_plots.png", plot = combined_plot, width = 12, height = 18)
