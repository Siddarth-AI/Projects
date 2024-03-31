For this project, I first started out by using a dataset found on Kaggle.com which included property sale prices across multiple states and regions. The dataset also lacked good categorical variables and for these reasons I decided to switch to a more relevant dataset that just looked at recent home sales prices in the Ames, IA area.
With this new dataset I put together I will attempt to predict the sale price of a home in Ames. I used https://beacon.schneidercorp.com to query for all recent home sales in the Ames area. We queried results for the last 12 months, ensuring I were working with only the most recent data and included a little over 500
different sale records. The three main questions that I hope to be able to answer using this dataset are:

1. Which feature influences the price the most?
2. What is the predicted sale price for an active listing of a home in the Ames area?
3. Which style of home has the highest average sale price?

**Part1. Data preparation: group attributes in category variables to reduce dimensionality**

1. Group attributes in variable “Condition” and create new variable "Condition 2" There are 12 attributes in the variable "Condition". We group "Excellent", "Very Good", "Good", "Above Normal" together as a new attribute as "Level1 - Good". We group "Normal", "Normal Normal" together and name this
group as " Level2 - Normal". We group "Below Normal", "Fair", "Poor", "Observed", "Very", "Very Poor" together as " Level3 - Bad". And then I test the SD between groups and they are significantly different (Figure 1), so these
new groups are workable.

2. Group attributes in variable “Style” and create new variable “Style 2”
When group style, I found 1 story style and 1 ½ story style cannot split clearly statistically, then I group these 2
as a new group “1 and 1 ½ story frame”. The new groups are “1 and 1.5 story style” “2 story style” “Mfd style”
“Split style” “Other style” and None. 


**Part2. Overview the data:**
Our dataset which I are calling “AmesHomeSales” containes 537 observations and 14 variables. The summary can be found in the screenshot below. Our top two highly correlated numerical variables are Total_Living_Area_SQFT and Year_Built. Scatter
plots of these variables' relationship with the response variable, Sale_Price, reveals that there is a significant increase in variability as both the total living area Sqft increases and the Year_Built increases, and it is affected by
Style and Condition.

Variable Selection:
For selecting which variable to use, I went with an automated process using the StepAIC function. I used backward elimination which gave us the best-fit model.

Part3. Interaction versus Linear model:
A check of the variance inflation factor reveals that all numerical variables are well below the significance threshold of 10. Vif of Year_Built is 1.04, Total_Living_Area is 1.40, Bed_Room is 1.24, Finished _Bsmt_Area is 1.15, Lot_Area is 1.07. This indicates that multicollinearity is not a concern for these variables.
Model Model description Normal Quantile Plot & Residual Plot Interaction model Overall good fitting ability

Residuals concentrate towards the X axis within a range in Residual plot. Showing constant variance of residuals. Showing good alignment especially I in
central part in normal quantiles plot meaning relatively good normality.
Based on the findings above, here is the answers for our question,
• Which feature influences the price the most? Total living area (SQFT)
• Use an active listing for a home in the Ames area: We would like to answer this question in the final report
• Which feature influences the price the least? Two story has highest price (pls see below box plot)
Variable being considered in our model include:
Bed_Rooms: Numerical variable of number of bedrooms Style: Categorical Variable grouped into 4 Styles: 1 Story, 2 Story,
MFG, Specialty
Year_Built: Numerical variable of year when house was built Bsmt_Type: Categorical variable for type of basement
Total_Living_Area_SQFT: Numerical Variable, UOM: SQFT AC: Boolean value for weather house has air conditioning or not
Finished_Bsmt_Area_SQFT: Numerical Variable, UOM: SQFT Fire_Place: Boolean value for weather house has fireplace or not
Lot_Area_SQFT: Numerical Variable, UOM: SQFT Occupancy: Categorical variable for occupancy type of home
Condition: Categorical Variable grouped into 3 categories: Bad,
Normal, good
Attic_Type: categorical variable for Attic type of home
