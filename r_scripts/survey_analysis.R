library(googlesheets)
library(ggplot2)

results.df <- gs_read(gs_key("1ZJiwEa-tObwH0zTmWqEqwqxihwS1X0BncxzBgG75TCI"))

results.df <- results.df[-(1:4),] # trim the test rows
results.df <- results.df[-35,]
results.df$img_num <- as.factor(results.df$img_num)


summary(
  aov(score ~ img_num, data=results.df)
)

boxplot(score ~ img_num, 
        data = results.df,
        col= c("blue", "yellow","green", "pink", "red"), 
        xlab="Filter Method", 
        ylab="Quality Score from Participant",
        main="Quality Scores of Filtering Methods")

# ADD Correlation and reorder boxplot by PSNR


ggplot(data=results.df, aes(x=img_num, y =score, fill=img_num)) + geom_boxplot() + 
  stat_summary(fun.y=mean, geom="point", shape=23, size=4) +
  labs(title="Distributions of Image Quality Scores by Filter Method",x="Filter Method", y = "Quality Score") +
  theme_classic() + theme(legend.position="none") +
  scale_x_discrete(labels = c('2'='Bilateral', '3'='Nonlocal', '5'='Adobe 50%', '6'='Adobe 100%'))+
  scale_y_continuous(breaks=0:10)


ggplot(data=results.df, aes(x=score)) + 
  geom_histogram(binwidth = 1, color="black", fill="cyan3") + 
  labs(title="Distributions of Image Quality Scores",x="Quality Score", y = "Frequency") +
  scale_x_continuous(breaks=0:10) + 
  theme_classic()

freqs <- tabulate(results.df$score)

ggplot(data=results.df, aes(x=score, color=img_num)) + 
  geom_point(shape=4, size=5, stat = "count") + 
  labs(title="Filter Method Scores and their Frequencies",x="Quality Score", y = "Frequency",  color = "Filter Method") +
  scale_y_continuous(breaks=0:10) + 
  scale_x_continuous(breaks=0:10) + 
  scale_color_manual(labels = c('2'='Bilateral', '3'='Nonlocal', '5'='Adobe 50%', '6'='Adobe 100%'), values = c('#F8766D','#7CAE00','#00BFC4','#C77CFF'))+
  theme_classic() + theme(legend.position = "bottom")

summary(results.df)

table(results.df)

