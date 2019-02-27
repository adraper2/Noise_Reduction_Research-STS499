library(googlesheets)
library(ggplot2)
library(gridExtra)
library(car)
library(MASS)

results.df <- gs_read(gs_key("1ZJiwEa-tObwH0zTmWqEqwqxihwS1X0BncxzBgG75TCI"))

results.df <- results.df[results.df$score!=0 & results.df$img_num!=0,]

results.df$img_num <- as.factor(results.df$img_num)

results.df$log_score <- sqrt(results.df$score+1)

length(results.df$score[results.df$img_num==1])
length(results.df$score[results.df$img_num==2])
length(results.df$score[results.df$img_num==3])
length(results.df$score[results.df$img_num==5])
length(results.df$score[results.df$img_num==6])

mean(results.df$score[results.df$img_num==1])
mean(results.df$score[results.df$img_num==2])
mean(results.df$score[results.df$img_num==3])
mean(results.df$score[results.df$img_num==5])
mean(results.df$score[results.df$img_num==6])

median(results.df$score[results.df$img_num==1])
median(results.df$score[results.df$img_num==2])
median(results.df$score[results.df$img_num==3])
median(results.df$score[results.df$img_num==5])
median(results.df$score[results.df$img_num==6])

sd(results.df$score[results.df$img_num==1])
sd(results.df$score[results.df$img_num==2])
sd(results.df$score[results.df$img_num==3])
sd(results.df$score[results.df$img_num==5])
sd(results.df$score[results.df$img_num==6])


fit <- aov(score ~ img_num, data=results.df)

summary(fit)

res.good <- aov(score ~ img_num, data=results.df)

# CHECK ASSUMPTIONS
plot(res.good,1)
plot(res.good,2)
plot(res.good,5)

# TRY LOG
res.good2 <- aov(log_score ~ img_num, data=results.df)

# CHECK ASSUMPTIONS
plot(res.good2,1)
plot(res.good2,2)
plot(res.good2,5)

# TRY LN

res.good2 <- aov(log(score) ~ img_num, data=results.df)

# CHECK ASSUMPTIONS
plot(res.good2,1)
plot(res.good2,2)
plot(res.good2,5)


summary(abs(rstudent(fit))>3) # any outliers?
summary(abs(rstudent(res.good2))>3)

abs(rstudent(fit))[which(abs(rstudent(fit))>3, TRUE)]  # yes, what is it equal to
abs(rstudent(res.good2))[which(abs(rstudent(res.good2))>3, TRUE)]  # yes, what is it equal to

##### Code from: https://www.statmethods.net/stats/rdiagnostics.html #####

leveragePlots(fit) # shows leverage

# Cook's D plot
# identify D values > 4/(n-k-1) 
cutoff <- 4/((nrow(mtcars)-length(fit$coefficients)-2)) 
plot(fit, which=4, cook.levels=cutoff)
# Influence Plot 
influencePlot(fit, id.method="identify", main="Influence Plot", sub="Circle size is proportial to Cook's Distance" )

##### END OF BORROWED CODE #####

hatvalues(fit)

plot(hatvalues(fit), type = "h")

# close!!!
fit2 <- aov(score ~ img_num, data=results.df[-which(abs(rstudent(fit))>3, TRUE) ,])
fit2

summary(fit2)

# no dice...
log_fit <- aov(log(score) ~ img_num, data=results.df[-which(abs(rstudent(res.good2))>3, TRUE) ,])
log_fit

summary(log_fit)


boxplot(score ~ img_num, 
        data = results.df,
        col= c("blue", "yellow","green", "pink", "red"), 
        xlab="Filter Method", 
        ylab="Quality Score from Participant",
        main="Quality Scores of Filtering Methods")

# ADD Correlation and reorder boxplot by PSNR


ggplot(data=results.df, aes(x=img_num, y =score, fill=img_num)) + geom_boxplot() + 
  stat_summary(fun.y=mean, geom="point", shape=23, size=4) +
  labs(x="Filter Method", y = "Image Quality Score") +
  theme_classic() + theme(legend.position="none") +
  scale_x_discrete(labels = c('1'= 'Mean', '2'='Bilateral', '3'='Nonlocal', '5'='Adobe 50%', '6'='Adobe 100%'))+
  scale_y_continuous(breaks=0:10)


ggplot(data=results.df, aes(x=score)) + 
  geom_histogram(binwidth = 1, color="black", fill="cyan3") + 
  labs(x="Image Quality Score", y = "Frequency") +
  scale_x_continuous(breaks=0:10) + 
  theme_classic()

freqs <- tabulate(results.df$score)

ggplot(data=results.df, aes(x=score, color=img_num)) + 
  geom_point(shape=4, size=5, stat = "count") + 
  labs(title="Filter Method Scores and their Frequencies",x="Quality Score", y = "Frequency",  color = "Filter Method") +
  scale_y_continuous(breaks=0:10) + 
  scale_x_continuous(breaks=0:10) + 
  scale_color_manual(labels = c('1'= 'Mean', '2'='Bilateral', '3'='Nonlocal', '5'='Adobe 50%', '6'='Adobe 100%'), values = c('#FCE300', '#F8766D','#7CAE00','#00BFC4','#C77CFF'))+
  theme_classic() + theme(legend.position = "bottom")

summary(results.df)

table(results.df)

ggplot(data=results.df, aes(x=img_num, y =log_score, fill=img_num)) + geom_boxplot() + 
  stat_summary(fun.y=mean, geom="point", shape=23, size=4) +
  labs(title="Distributions of Image Quality Log Scores by Filter Method",x="Filter Method", y = "Log Quality Score") +
  theme_classic() + theme(legend.position="none") +
  scale_x_discrete(labels = c('1'= 'Mean', '2'='Bilateral', '3'='Nonlocal', '5'='Adobe 50%', '6'='Adobe 100%'))+
  scale_y_continuous(breaks=0:10)


aggregate(log_score~img_num,data=results.df,FUN=var)

aggregate(score~img_num,data=results.df,FUN=var)


# ANOVA visual for research paper

results.df <- results.df[!is.na(results.df$training3),] # remove 0 scores now

results.df$train_score <- (results.df$training1 + results.df$training2 + results.df$training3)/3

sp1 <- ggplot(results.df[results.df$img_num==1,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 1.777469, slope = 0.3942976, color = "purple") +
  labs(title="Mean Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
sp1

sp2 <- ggplot(results.df[results.df$img_num==2,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 3.370607, slope = 0.08466454, color = "green") + 
  labs(title="Bilateral Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
sp2

sp3 <- ggplot(results.df[results.df$img_num==3,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = -2.052575, slope = 1.148204, color = "blue") +
  labs(title="Nonlocal Means Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
sp3

sp5 <- ggplot(results.df[results.df$img_num==5,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 1.873777, slope = 0.523834, color = "orange") +
  labs(title="Adobe 50% Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
sp5

sp6 <- ggplot(results.df[results.df$img_num==6,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = -1.203703704, slope= 1.240310078, color = "red") +
  labs(title="Adobe 100% Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
sp6

grid.arrange(sp1, sp3, sp2, sp5, sp6,nrow = 2)

# equal variance model

scp1 <- ggplot(results.df[results.df$img_num==1,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 0.5866275, slope = 0.651931549, color = "purple") +
  labs(title="Mean Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
scp1

scp2 <- ggplot(results.df[results.df$img_num==2,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 0.5641281, slope = 0.651931549, color = "green") + 
  labs(title="Bilateral Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
scp2

scp3 <- ggplot(results.df[results.df$img_num==3,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 0.4871738, slope = 0.651931549, color = "blue") +
  labs(title="Nonlocal Means Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
scp3

scp5 <- ggplot(results.df[results.df$img_num==5,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 1.245151, slope = 0.651931549, color = "orange") +
  labs(title="Adobe 50% Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
scp5

scp6 <- ggplot(results.df[results.df$img_num==6,], aes(x=train_score, y=score)) + 
  geom_point() + geom_abline(intercept = 1.607438154, slope= 0.651931549, color = "red") +
  labs(title="Adobe 100% Filter",x="Mean Training Score", y = "Quality Score") +
  theme_classic() +
  scale_x_continuous(expand = c(0, 0), limits = c(0,10.5)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,10.5))
scp6

grid.arrange(scp1, scp3, scp2, scp5, scp6, nrow = 2)


