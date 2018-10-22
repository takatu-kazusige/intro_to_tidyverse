library(tidyverse)
library(ggpmisc)

# RStudioの使い方----

# - 初期設定
#   - 一時データを保存しないようにする
#   - ライブラリをインストールする
# 
# - データ分析ごとに行う
#   - プロジェクトを作成する
#   - ソース作成する
#   - ライブラリをインポートする
#   - 処理を書く
# 
# - ショートカットキー
#   - 代入演算子
#   - パイプ演算子
#   - Run
#   - Redo/Undo
#
# - 他にも


# 色々なグラフを描く----

# テスト用のデータを用意する
data <- tibble(a = rnorm(1000), b = rnorm(1000), c = rnorm(1000))

# 折れ線グラフを描く（2種類ある）
data %>% ggplot(aes(x = a, y = b)) + geom_line()
data %>% ggplot(aes(x = a, y = b)) + geom_path()

# 2次元のヒストグラム、確率密度分布のようなもの
data %>% ggplot(aes(x = a, y = b)) + geom_bin2d(binwidth = 0.3) + coord_fixed()
data %>% ggplot(aes(x = a, y = b)) + geom_density2d() + coord_fixed()

# 分布の比較
data %>% gather(type, value) %>% 
  ggplot(aes(value)) + 
  geom_histogram(binwidth = 0.1) + 
  facet_wrap(~ type)

data %>% gather(type, value) %>% 
  ggplot(aes(type, value)) + 
  geom_boxplot(binwidth = 0.1)

data %>% gather(type, value) %>% 
  ggplot(aes(type, value)) + 
  geom_violin(binwidth = 0.1) +
  geom_point(alpha = 0.01)

# 棒グラフ（2種類ある）
#   統計変換について簡単に説明する
diamonds <- diamonds
diamonds %>% ggplot(aes(x = cut)) + geom_bar()

diamonds %>% group_by(cut) %>% count() %>% 
  ggplot(aes(x = cut, y = n)) + geom_col()


# 課題----
# (1) ダイヤモンドのカラットと価格に相関があるか？散布図
# (2) カット等級ごとにサブグラフを作って、階級ごとの相関も確認する。

# 回答(1)----
# そのまま描いてみる
diamonds %>% ggplot(aes(price, carat)) + geom_point()

# オーバープロット対策
p1 <- diamonds %>% ggplot(aes(price, carat)) + geom_point(alpha = 0.1)
p2 <- diamonds %>% ggplot(aes(price, carat)) + geom_bin2d()
print(p1)
print(p2)

# 両対数グラフを描いてみる（対数変換）
p1 <- p1 + scale_x_log10() + scale_y_log10()
p2 <- p2 + scale_x_log10() + scale_y_log10()
print(p1)
print(p2)

# 回答(2)----
# カット等級ごとのサブグラフを作る

# まず、１つのグラフで色分けして描いてみる
p3 <- diamonds %>% ggplot(aes(price, carat, color = cut)) + 
  geom_point(alpha = 0.1) + 
  scale_x_log10() + scale_y_log10() +
  guides(color = guide_legend(override.aes = list(alpha = 1)))
print(p3)

# サブグラフで描いてみる
p3 + facet_wrap(~ cut) + geom_smooth(method = "lm", color = "red")
p2 + facet_wrap(~ cut) + geom_smooth(method = "lm", color = "red") +
  stat_poly_eq(aes(label = paste(stat(eq.label), stat(rr.label), sep="~~~")),
               parse = T, coef.digits = 5, rr.digits = 5,
               formula = y ~ x, size = 3)

