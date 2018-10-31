library(googlesheets)

results.df <- gs_read(gs_key("1ZJiwEa-tObwH0zTmWqEqwqxihwS1X0BncxzBgG75TCI"))

results.df <- results.df[-(1:4),] # trim the test rows
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
