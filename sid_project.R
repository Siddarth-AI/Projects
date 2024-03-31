library(MASS)
library(car)
library(ggplot2)
setwd("/Users/apple/Desktop/Fall 2023/526 Applied Statistics/Project")
df <- read.csv(file.choose(), header=T,sep=",",quote="\"")
df
class(df)

str(df)


sum(is.na(df))

#select only numeric columns
numeric_df <- df[sapply(df, is.numeric)]

#correlation
corr <- round(cor(numeric_df),4)
corr
plot(numeric_df,pch = 19,cex = .5)
round(cor(numeric_df),3)
num_mod<-lm(Sale_Price~.,data=numeric_df)
summary(num_mod)
vif(num_mod)

df$age <- (2023 - df$Year_Built)
#df$Occupancy <- as.factor(df$Occupancy)

# Convert the Condition to a factor if it's not already
df$Condition <- as.factor(df$Condition)
# Assuming 'df' is your dfframe and 'column_name' is the name of your categorical column
# Convert the column to a factor if it's not already
df$Condition <- as.factor(df$Condition)
# Get the levels of the column
levels_column = levels(df$Condition)
# Number of levels
num_levels = length(levels_column)
# Print the number of levels
print(num_levels)
# Grouping less frequent categories into a single category
df$Condition <- as.character(df$Condition)
df$Condition[df$Condition %in% c("Excellent", "Very Good", "Good", "Above Normal")] <- "Good"
df$Condition[df$Condition %in% c("Normal", "Normal Normal")] <- "Normal"
df$Condition[df$Condition %in% c("Below Normal", "Fair", "Poor", "Observed", "Very", "Very Poor","")] <- "Bad"
df$Condition <- as.factor(df$Condition)

# Convert the Condition to a factor if it's not already
#df$Occupancy <- as.factor(df$Occupancy)
# Convert the column to a factor if it's not already
df$Occupancy <- as.factor(df$Occupancy)
# Get the levels of the column
levels_column = levels(df$Occupancy)
# Number of levels
num_levels = length(levels_column)
# Print the number of levels
print(num_levels)
# Grouping more frequent categories into a less frequent category
df$Occupancy <- as.character(df$Occupancy)
df$Occupancy[df$Occupancy %in% c("","Condominium","Detached Structures\nOnly","Detached Structures Only","Townhouse")] <-"others"
df$Occupancy[df$Occupancy %in% c("Single-Family / Owner","Single-Family", "Single-Family\n/ Owner Occupied","Single-Family / Owner\nOccupied / Owner Occupied",
                                 "Single-Family / Owner Occupied","Single-Family / Owner Occupied Single-Family / Owner Occupied",
                                 "Single-Family / Owner Occupied Structures\nOnly","Single-Family / Rental Unit")] <- "single"
df$Occupancy[df$Occupancy %in% c("Two-Family Conversion", "Two-Family Conversion Duplex", "Two-Family Conversion Two-Family Conversion",
                                 "Two-Family Duplex")] <- "two"
df$Occupancy <- as.factor(df$Occupancy)
#income$Race <- as.factor(income$Race, levels = c(1, 2, 3),labels = c("Hispanic", "Black", "Non-hispanic non-black"))
#df$Occupancy <- as.factor(df$Occupancy, levels = c(1,2,3,), labels = c("others","single","two"))
# Convert the Style to a factor if it's not already
df$Style <- as.factor(df$Style)
# Get the levels of the column
levels_column = levels(df$Style)
# Number of levels
num_levels = length(levels_column)
# Print the number of levels
print(num_levels)
# Grouping less frequent categories into a single category
df$Style <- as.character(df$Style)
df$Style[df$Style %in% c( "","1 1/2 Story\nFrame","1 1/2 Story Brick","1 1/2 Story Frame","1 Story Brick",
                          "1 Story Condo","1 Story Frame", "1 Story Frame 1 Story Frame","1 Story Townhouse")] <- "1story"
df$Style[df$Style %in% c("2 Story Brick","2 Story Frame","2 Story Townhouse")] <- "2story"
df$Style[df$Style %in% c("Mfd Home","Mfd Home (Multi-Section)","Mfd Home (Single)")] <- "manufactured"
df$Style[df$Style %in% c("None", "Salvage","Split Foyer Frame","Split Level Frame")] <- "specialty"
df$Style <- as.factor(df$Style)
#df$Style <- as.factor(df$Style, levels = c(1,2,3,4), labels = c("1story","2story","manufactured","specialty"))
#EDA
ggplot(df, aes(x = Style, y = Sale_Price)) + 
  geom_boxplot() +
  ggtitle("Boxplot by Category") +
  xlab("Category") +
  ylab("Values")


#Age vs SalesPrice
ggplot(df, aes(x=age,y=Sale_Price, color=Condition))+
  geom_point()+
  scale_shape_manual(values=1:nlevels(df$Condition))+ 
  labs(title = "Relationship between Age and Sales Price based on Condition", x = "Building Age", y = "Housing Price")


ggplot(df, aes(x=age,y=Sale_Price, color=Style))+
  geom_point()+
  scale_shape_manual(values=1:nlevels(df$Style))+ 
  labs(title = "Relationship between Age and Sales Price based on style", x = "Building Age", y = "Housing Price")

ggplot(df, aes(x=age,y=Sale_Price, color=Occupancy))+
  geom_point()+
  scale_shape_manual(values=1:nlevels(df$Occupancy)) 

# Area vs SalesPrice
ggplot(df, aes(x=Total_Living_Area_SQFT,y=Sale_Price,color=Condition))+
  geom_point() +
  scale_shape_manual(values=1:nlevels(df$Condition))+ 
  labs(title = "Relationship between Area and Sales Price based on Condition", x = "Living Area sqft", y = "Housing Price")

ggplot(df, aes(x=Total_Living_Area_SQFT,y=Sale_Price,color=Style))+
  geom_point() +
  scale_shape_manual(values=1:nlevels(df$Style))+ 
  labs(title = "Relationship between Area and Sales Price based on Style", x = "Living Area sqft", y = "Housing Price")
  
#Model building
#simple linear model
mod1<-lm(Sale_Price~Total_Living_Area_SQFT,data=df)
#mod1 <- summary(mod1)
summary(mod1)

df$area_residuals1 <- residuals(mod1)
df$area_predicted1 <- predict(mod1)

#residual plot analysis
ggplot(df,aes(x=area_predicted1,y=area_residuals1))+
  geom_point()+
  labs(title = "Residual Plot") +
  xlab("Predicted Values") +
  ylab("Residuals") +
  geom_abline(intercept = 0, slope=0)
#Check Normality Assumption
ggplot(data =df, aes(sample = area_residuals1))+
  stat_qq()+
  stat_qq_line()+
  labs(title = "Normal Quantile Plot of Residuals")+
  xlab("Theoretical Normal Quantiles")+
  ylab("Residuals")

#selecting  variables
df1 <- df[, c("Sale_Price", "age", "Total_Living_Area_SQFT","Bed_Rooms","Finished_Bsmt_Area_SQFT","Lot_Area_SQFT",
              "Style","Occupancy","Condition")]
#Full Model
modelFullpbf<-lm(Sale_Price~.,data=df1)
summary(modelFullpbf)
vif(modelFullpbf)
##Simple Model  
modelSimplepbfpbf<-lm(Sale_Price~1,data=df1)
summary(modelSimplepbfpbf)
#Stepwise AIC, forward selection
stepAICfor<-stepAIC(modelSimplepbfpbf,
                    scope=list(upper=modelFullpbf,
                               lower=modelSimplepbfpbf),
                    direction="forward")
stepAICfor$anova
summary(stepAICfor)
vif(stepAICfor)
AIC(stepAICfor)

#Stepwise AIC, backward selection
stepAICback<-stepAIC(modelFullpbf,
                     scope=list(upper=modelFullpbf,
                                lower=modelSimplepbfpbf),
                     direction="backward")
stepAICback$anova
summary(stepAICback)
vif(stepAICback)
AIC(stepAICback)


library("leaps")
best <- regsubsets(Sale_Price~.,data=df1,nbest=1,nvmax=10) 
summary(best)
plot(best,scale ="bic",main= "Model Selection Using BIC")
summary(best)$bic #to show bic values and choose model with lowest values

best_mod<-lm(Sale_Price ~ Total_Living_Area_SQFT + age + Lot_Area_SQFT + Occupancy + Bed_Rooms + ConditionGood +ConditionNormal+ Finished_Bsmt_Area_SQFT + StyleSalvage+Style2StoryBrick,data=df)
summary(best_mod)
vif(best_mod)
