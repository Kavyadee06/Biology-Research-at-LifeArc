title: Data Analysis of MAP2 immunofluorescence data for the neuronal differentiation optimisation experiment by Kavya Krishnamurthy.

**STEP 1. Summary of the analysis task**
- Given an input table listing the proportion of cells expressing a neuronal marker MAP2 for each combination of treatments 
(a dose of NGN2 virus +/- NT3 supplement; 3 replicates per condition), select the treatment combination that yields the 
highest proportion of MAP2-expressing cells (i.e., neurons).
- will use data visualisations and a formal statistical analysis by logistic regression to decide on the best treatment combination.



**STEP 2. Getting started**
\#install Packages

>install.packages("effects")
>install.packages("dplyr")
>install.packages("ggplot2")

\#Load the libraries

>library(dplyr)
>library(ggplot2)
>library(effects)

**STEP 3. Load the data**

\#Load the dataset
>data <- read.table(" /Users/kavyadeepak/Documents/CAREER/Forage exp/Life Arc/Task 2/Input data.txt ", sep='\t', header=TRUE)

\#Print the loaded dataset
> data
   	SampleID	 NGN2_MOI 	Control_MOI 	NT3_ng 	fractMAP2
1        	 1        	0         	  5      	0    	 0.002
2      	2  	 0	 5 	0  	0.001
3        	 3      	 0          	5      	0     	0.001
4        	 4       	 0           	5     	10     	0.003
5         	5        	0           	5     	10     	0.002
6         	6        	0           	5     	10     	0.004
7         	7        	2           	0      	0     	0.021
8         	8        	2           	0      	0     	0.018
9         	9        	2           	0      	0     	0.026
10       	10        	2           	0     	10     	0.001
11       	11        	2          	 0     	10     	0.022
12       	12        	2           	0     	10     	0.019
13       	13        	5           	0      	0     	0.085
14       	14        	5          	 0      	0     	0.091
15       	15        	5           	0      	0     	0.079
16       	16        	5           	0     	10     	0.130
17       	17        	5           	0     	10     	0.143
18       	18        	5           	0     	10     	0.091
19       	19       	10           	0      	0     	0.037
20       	20       	10           	0      	0     	0.032
21       	21       	10           	0      	0     	0.043
22       	22       	10           	0     	10     	0.059
23       	23       	10           	0     	10     	0.068
24       	24       	10           	0     	10     	0.040

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Dataset shows :
	1. Col NGN2_MOI : shows this experimental design tests four doses of the NGN2 virus (0, 2, 5 and 10 MOI)
	2. Col Control_MOI : using 5 MOI of the empty virus vector as a negative control in the wells where no NGN2 virus was added.
	3. Col NT3_ng : In addition, for each dose of the NGN2 virus, the effects of the NT3 supplement were tested at 0 and 10 ng/mL.
	4. There are eight experimental conditions, with each condition replicated over three wells, giving 24 samples overall (one 24-well plate).
	
	5. Note that our experimental design is not really appropriate to assess the effect of the empty vector control itself on the outcome (*can you see why?*), so we will disregard the *CONTROL_MOI* column in our analysis.
	6. Answer: 
	A. NGN2 Virus Doses: You're testing the effects of different amounts of the NGN2 virus (0, 2, 5, and 10 MOI).
	B. Control Condition: You have a control group where you use an empty virus (with nothing in it) at a dose of 5 MOI. This is meant to be your baseline or reference point.
	C. Issue with Control: The problem is that your control group is not truly independent because it also includes the 5 MOI dose. This makes it hard to figure out if any effects you see are due to the empty virus or the dose of 5 MOI.
	D. Solution: To better understand the impact of the empty virus itself, it would be better to have a separate control group with no NGN2 virus (0 MOI) at all. This way, you can be sure that any differences you observe are specifically because of the empty virus and not influenced by the amount of virus (MOI) used.
	
	In simpler terms, your control condition should only include the empty virus without the complication of different virus amounts. This helps you accurately see the true effect of the empty virus on your experiment.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
**STEP 4. Represent treatment doses as categorical data**
	A. Currently, our treatment doses are represented as numbers.
However, we don't necessarily expect the doses to show a consistent trend with respect to the outcome (i.e., it is possible that both "too much" and "not enough" of the virus will impair differentiation efficiency).
	B. It may therefore more appropriate in our setting to treat each dose as a separate "**category**", in the same way as we would typically encode colours or genders.
(Note that categorical encoding does not mean that the underlying data must be inherently discrete!).
	1. To tell R that our treatment doses should be considered as categorical data, we need to transform the corresponding columns from the numerical into the so-called **factor** format.
	2. We will define the "**levels**" of each factor such that the dose of 0 will be considered as a "control", with the following levels corresponding to increasing doses.
	3. This will help us in data visualisation and regression analysis further down below.
	4. Note how the "\$" operator in R allows us to access specific columns in a table by their names.

'''R
>data$NGN2_MOI <- factor(data$NGN2_MOI, levels=c(0,2,5,10))

> data$NGN2_MOI 
 [1] 0  0  0  0  0  0  2  2  2  2  2  2  5  5  5  5  5  5  10 10
[21] 10 10 10 10
Levels: 0 2 5 10

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/#Here's a breakdown of the code:
This R code is converting the variable `data$NGN2_MOI` to a factor with specified levels.

1. `data$NGN2_MOI`: This refers to the column named `NGN2_MOI` in the data frame or data set called `data`.

2. `factor(...)`: This function is used to convert a variable into a factor in R. Factors are used to represent categorical data.

3. `levels=c(0,2,5,10)`: This part of the code is specifying the levels of the factor. In your case, it's indicating that the levels for `NGN2_MOI` should be 0, 2, 5, and 10. This is often done to explicitly define the order and presence of levels in the factor variable.

So, after running this code, the `NGN2_MOI` column in your `data` will be converted into a factor with levels 0, 2, 5, and 10. This can be useful for certain types of analyses and plotting where the order of the levels matters.

Note:
- `data$NGN2_MOI` is the variable being converted to a factor.
- `factor(data$NGN2_MOI, levels=c(0,2,5,10))` is the function call that converts `data$NGN2_MOI` into a factor with specified levels (0, 2, 5, 10).

After running this code, the `NGN2_MOI` column in your `data` will be treated as a factor with levels 0, 2, 5, and 10, and any analysis or plotting functions that use this variable as a factor will take these levels into account. This is particularly useful when you want to ensure a specific order or representation of categories in your data.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/#Similarly,

'''R
>data$NT3_ng <- factor(data$NT3_ng, levels=c(0,10))

> data$NT3_ng
 [1] 0  0  0  10 10 10 0  0  0  10 10 10 0  0  0  10 10 10 0  0 
[21] 0  10 10 10
Levels: 0 10

/#We will print just the top bit of the modified table now using the *head()* function.

> head(data)
  	SampleID 	NGN2_MOI 	Control_MOI 	NT3_ng 	fractMAP2
1        	1       	0           	5      	0     	0.002
2        	2        	0           	5      	0     	0.001
3        	3       	 0           	5      	0     	0.001
4        	4        	0           	5     	10     	0.003
5       	5        	0           	5     	10     	0.002
6       	 6        	0           	5     	10     	0.004

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| **Question:** Can you see what has changed in the output?
[Answer:]{.underline} \*\* the first few rows of the dataset is displayed using the head() function. The dataset has columns such as SampleID, NGN2_MOI, Control_MOI, NT3_ng, and fractMAP2 with first 6 row vaues.  \*\*.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 STEP 5a. Plot the data**

Let's now generate a bar plot the data.
	1. We will construct the plot such that the heights of the bars show the mean fraction of MAP2-positive cells for each treatment condition, and the error bars showing standard deviations across the three replicates.
	2. To do this, we will first generate a summary table with **conditions** in rows (8 in total), and the **means** and **standard deviations** across replicates in columns.
	3. We will call the columns *meanFractMAP2* and *sdFractMAP2*, respectively.
	4. We will use the *group_by()* and *summarise()* functions from the *dplyr* package as below.
	5.  The column name(s) supplied to *group_by()* tell this function that the rows in which the values across all of these columns are identical should be considered a single group. In our case, a single group will be all rows with the same doses of the NGN2 virus and NT3 supplement - in other words, all replicates of the same treatment condition.
	6.  *summarise()* will create a table with one row per group, where each column will correspond to some summary function applied to each group (in our case, the mean and standard deviation (*sd*) of the fractMAP column).
	7.  *%\>%* is a pipe operator used in some R packages, which works by "forwarding" the data from the left side of the operator to a function on the right side of it. This avoids the need to assign intermediate results of multiple operations to separate variables and makes the code tidier and more readable.

'''R
>sumdata <- data %>% 
  group_by(NGN2_MOI, NT3_ng) %>%
  summarise(meanFractMAP2=mean(fractMAP2), sdFractMAP2 = sd(fractMAP2))

> sumdata
# A tibble: 8 × 4
# Groups:   NGN2_MOI [4]

  	NGN2_MOI 	NT3_ng 	meanFractMAP2 	sdFractMAP2
 	 <fct>    	<fct>          	<dbl>       	<dbl>
1	 0       	 0           	 0.00133    	0.000577
2 	0        	10          	0.003      	0.001   
3 	2        	0            	0.0217     	0.00404 
4 	2        	10           	0.014      	0.0114  
5 	5        	0            	0.085      	0.006   
6 	5        	10           	0.121      	0.0271  
7 	10       	0           	0.0373     	0.00551 
8 	10       	10           	0.0557     	0.0143 

STEP 5b:
	1. We can now visualise the data from the summary table as a barplot.
	2. We will use the powerful *ggplot2* package for this.
	3. You don't need to understand each parameter in the code below, but note how the plot is "assembled" from a "**sum**" of different function calls:
	4. *ggplot()* defines what table should be used as **input** (in our case, *sumdata*) and which of its columns should be used for the plotting and how.
	5. Here we will ask it to plot the fraction of MAP2+ cells (*meanFractMAP2*) along the **y** axis, plot the bars for different concentrations of the NGN2 virus (*NGN2_MOI*) along the **x** axis, and use different **fill colour** for the conditions with and without NT3 (*NT3_ng*).
	6. *geom_bar()* determines that these data should be plotted as a **barplot** (i.e., with the **y** axis reflecting the height of the bars).
	7. The *position_dodge()* call inside this function determines that the two barplots for the same virus concentration (with and without NT3, respectively) should be plotted next to each other (rather than stacked).
	8. *geom_errorbar()* determines how the **error bars** should be plotted.
	9.  Here we define that the bottom and the top boundaries of the error bars should correspond to the *(mean+/-standard deviation)* for each condition, respectively.

'''R

>ggplot(sumdata, aes(x=NGN2_MOI, y=meanFractMAP2, fill=NT3_ng)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=meanFractMAP2-sdFractMAP2, ymax=meanFractMAP2+sdFractMAP2), 
                width=0.2, position=position_dodge(0.9))
 



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/#Here's a breakdown of the code:

	A. In the `ggplot` code you provided:
	
	```R
	ggplot(sumdata, aes(x = NGN2_MOI, y = meanFractMAP2, fill = NT3_ng))
	```
	
	`fill` is an aesthetic mapping in `ggplot2` that determines the color of the filled elements in a plot. In this context:
	
	- `x = NGN2_MOI`: Specifies the variable to be mapped to the x-axis.
	- `y = meanFractMAP2`: Specifies the variable to be mapped to the y-axis.
	- `fill = NT3_ng`: Specifies the variable to be mapped to the fill color.
	
	For example, if you are creating a bar plot (`geom_bar()`) and you use `fill = NT3_ng`, it means that the bars will be colored according to the values of the `NT3_ng` variable. Each unique value of `NT3_ng` will be associated with a distinct color in the plot.
	

	B. The `geom_errorbar()` code you provided is used to add error bars to a plot, and it seems to be specifically set up for a dodged bar plot. Here's a breakdown of the code:
	
	- **`aes(ymin = meanFractMAP2 - sdFractMAP2, ymax = meanFractMAP2 + sdFractMAP2)`**: This part of the code uses the `aes()` function to specify the aesthetics for the error bars. It sets the minimum (`ymin`) and maximum (`ymax`) values for each bar based on the mean (`meanFractMAP2`) and standard deviation (`sdFractMAP2`) of the `FractMAP2` variable.
	
	- **`width = 0.2`**: This parameter sets the width of the error bars. In this case, it's set to 0.2, which means the error bars will have a width of 0.2 units.
	
	- **`position = position_dodge(0.9)`**: This parameter determines the position adjustment for dodging the error bars. It uses `position_dodge()` with a value of 0.9, which means the error bars will be dodged to the right of the center of each bar.
	
	Putting it all together, this `geom_errorbar()` is likely intended for use in a dodged bar plot where the error bars represent the variability (standard deviation) around the mean of the `FractMAP2` variable. Adjust the parameters based on your specific data and visualization requirements.


	C. The `geom_bar()` function in `ggplot2` is used to create bar plots. The parameters `position`, `stat`, and `colour` in the context of your code mean the following:
	
	- **`position = position_dodge()`**: This parameter is specifying the position adjustment for dodging overlapping bars. When you have multiple groups or factors, dodging bars helps to display them side by side instead of overlapping. `position_dodge()` is a common function used for this purpose.
	
	- **`stat = "identity"`**: This parameter indicates that the heights of the bars are directly specified in the data. In other words, the height of each bar is determined by the actual values in the dataset rather than calculated by a statistical transformation (which is the default behavior for `geom_bar()`).
	
	- **`colour = 'black'`**: This parameter sets the color of the bar outlines to black. It defines the border color of the bars. You can replace `'black'` with any valid color name or code.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
STEP 5c: 
	1. Let's now try replotting the data by [averaging across NT3-treated and untreated wells]
	2. This way we will only have **four bars** in the bar plot, one per each NGN2 virus dose.
	3. First, we will create a different summary table for this, where we will group the data differently.

**Can you have a go at the correct parameter for this *group_by()* function in this case?**

'''R 
>sumdataNGN2 <- data %>% 
  group_by( NGN2_MOI ) %>%
  summarise(meanFracMAP2=mean(fractMAP2), sdFracMAP2 = sd(fractMAP2))

>sumdataNGN2
# A tibble: 4 × 3
  	NGN2_MOI 	meanFracMAP2 	sdFracMAP2
 	 <fct>           	<dbl>      	<dbl>
1	 0             	0.00217    	0.00117
2 	2             	0.0178     	0.00870
3 	5             	0.103      	0.0265 
4 	10            	0.0465     	0.0140 

STEP 5d: 
	1. note that we've removed the *fill* parameter from *ggplot()* as with just one parameter to plot - NGN2 virus dose - we no longer need to use the fill colour to represent the second condition.
	
'''R
ggplot(sumdataNGN2, aes(x=NGN2_MOI, y=meanFracMAP2)) +
+     geom_bar(stat="identity") +
+     geom_errorbar(aes(ymin=meanFracMAP2-sdFracMAP2, ymax=meanFracMAP2+sdFracMAP2))

>

	

STEP 5e:
	1. Let's now do the same by averaging across all NGN2 doses, such that we only have **two bars** in the bar plot, one per each NT3 dose (treated and untreated).
	2. **Please insert the correct grouping into *group_by()* for this visualisation.**

>sumdataNGN2 <- data %>% 
  group_by(NT3_ng) %>%
  summarise(meanFracMAP2=mean(fractMAP2), sdFracMAP2 = sd(fractMAP2))

> sumdataNGN2
# A tibble: 2 × 3
  	NT3_ng 	meanFracMAP2 	sdFracMAP2
  	<fct>         	<dbl>      	<dbl>
1 	0            	0.0363     	0.0325
2 	10           	0.0485     	0.0504


STEP 5f: 
	1. Visualize using ggplot

'''r
> ggplot(sumdataNGN2, aes(x=NT3_ng, y=meanFracMAP2)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=meanFracMAP2-sdFracMAP2, ymax=meanFracMAP2+sdFracMAP2), width=0.2,
                position=position_dodge(0.9))
>


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**Question**: Look at the error bars in the plot above.
 
  What do you notice and how would you interpret this result?
[Answer]{.underline}: \*\*  long Error Bar in the plot above would indicate that the values are more spread out and less reliable \*\*.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STEP 6:  Formally test the effects of treatment doses on differentiation efficiency

	1. From the plots above, we can probably have some idea already of what combination of treatment doses has worked best, and which treatment had a larger effect. However, we still need to test this formally.
	2. Importantly, the outcomes that we are comparing are given by **proportions** (of MAP2-positive cells), and proportions [are not distributed normally]
	3. Therefore, we shouldn't use standard significance tests such as the T test or ANOVA for this analysis.
	4. In addition, we have [many conditions], so rather than doing lots of pairwise comparisons (and accumulating multiple testing errors), we are going to [tie them all together into a regression model]
	5. When the outcome is given by a proportion, one suitable regression framework is **logistic regression**.
	
	6. Formally, logistic regression is a type of generalised linear models of the form:  **f(y) = k~1~x~1~ + k~2~x~2~ + ... + b**
	
	-   **y** is a binary outcome variable (such as "pass"/"fail" or "heads"/"tails");
	
	-   **f(y)** is typically the log-odds of success: *f(y)* = *logit(y) = log(y/1-y)*;
	
	-   **x~1~**, **x~2~**, ... are explanatory (predictor) variables;
	
	-   **k~1~**, **k~1~**, ... are the regression coefficients to be determined by the regression analysis;
	
	-   **b** is the intercept term that affects the outcome uniformly and does not depend on the predictor variables.
	
	7. Regression analysis can be used to assess which (if any) explanatory variables (in our case, the two treatments we have varied) affect the chances of a positive outcome (in our case, the fraction of MAP2-expressing cells generated in the differentiation experiment).
	8.  Note: The explanatory variables can be either continuous or categorical (as in our case, as we are using treatment doses as categorical variables for reasons explained above).
	9. Also note that in our case instead of single outcomes for each observation (which would be: "Is a given cell MAP2-positive?"), we will use the **fraction of MAP2-positive cells per well** as the outcome variable.
	10. One key additional piece of information that we need for this analysis is the **total number of cells scanned in each well**.
	11. *The input file you are given doesn't provide this information, so you had to check with the colleague who has performed this experiment. She told you that the data are based on roughly **10,000 cells** scanned in each well.
	
	12. We will now use R to fit our logistic regression model using the *glm()* function, which has the following key parameters:
		A.  *data -* our input table as the *data* parameter
		B.  *family* - the type of the generalised regression model (for logistic regression, it should be set to "binomial")
		C. the model *formula* in the form y \~ x1 + ... + xN.
		D. The measurements of both the outcome variable **y** and all explanatory variables **x~1~**, ..., **x~N~** should be provided in the input data table [under the corresponding column names]
		E.  [For example], if we are assessing the relationship between the chance of getting heads in a coin flip and the temperature and humidity in the room, the model formula could be: 
		isHeads \~ temp + humidity, assuming the input data table has the relevant information encoded in the columns named "isHeads", "temp" and "humidity".
		
Step 6a: Linear Regression Model

	1.  **Please think of the outcome variable and explanatory variables in our model and input them into the formula below.**
	
(model: fractMAP2 ~ NGN2_MOI + Control_MOI + NT3_ng )

'''R
>mod = glm(fractMAP2 ~ NGN2_MOI + NT3_ng , family=binomial(link="logit"), data=data,weights = rep(10000,nrow(data)))

Note : 
	1. how we have entered the number of cells tested in each row as the *weights* parameter.
	2. In our case, they are the same for each well, so we are just repeating the same number for each row, but they could also be different.
	3. Also note that in this model we are assuming that the effects of virus concentration and NT3 treatment are fully independent.
	4. If we aren't sure about it, it may make sense to test their **interaction effects** as well.
	If you are interested, you can read up on how to do this in R very straightforwardly - for example, here: <https://www.theanalysisfactor.com/generalized-linear-models-glm-r-part4/>.
	    Feel free to try this analysis in a separate chunk below.
	
\#inspect the summary of this model generated by R.
>summary(mod)

Call:
glm(formula = fractMAP2 ~ NGN2_MOI + NT3_ng, family = binomial(link = "logit"), 
    data = data, weights = rep(10000, nrow(data)))

Coefficients:
            	Estimate 	Std. Error 	z value 	Pr(>|z|)    
(Intercept) 	-6.30098    	0.08862  	-71.10   	<2e-16 ***
NGN2_MOI2    	2.12408    	0.09307   	22.82   	<2e-16 ***
NGN2_MOI5    	3.97231    	0.08883   	44.72   	<2e-16 ***
NGN2_MOI10   	3.11278    	0.08992   	34.62   	<2e-16 ***
NT3_ng10     	0.31290    	0.02084   	15.02   	<2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 10204.34  on 23  degrees of freedom
Residual deviance:   712.97  on 19  degrees of freedom
AIC: 890.95

Number of Fisher Scoring iterations: 5

\#Next:
This command prints a few things, but we will focus on the following:
	1. The **values** of each regression coefficient given in the *Estimate* column.
	2. For our purposes, it is sufficient to know that the sign of the regression coefficient corresponds to whether increasing the value of the predictor results in either increasing (+) or decreasing (-) the chances of success (in our case, on MAP2 expression).
	3. Also, the higher is the absolute value of the coefficient, the stronger is the effect of the predictor on the chances of success.
	4. If you'd like to learn more about interpreting logistic regression coefficients, you can check, for example, this page for details: <https://stats.oarc.ucla.edu/r/dae/logit-regression/>.
	5. The **significance** of the coefficients' difference from zero (with a coefficient of zero corresponding to the predictor not affecting the outcome).
	6. The p-values for this significance are given in the *Pr(\>\|z\|)* column.
	7. You have also probably noticed that the names of explanatory variables listed in the summary have changed a little from what we have provided originally.
	8. This is because for categorical variables defined this way, R is testing **the effect of each level separately** compared with the first one.
	9. This way, each treatment level becomes a separate independent explanatory variable, which R names by adding the treatment level (in our case, concentration) to the original variable name.
	10.  If you are interested in more details about regression analysis with categorical predictor variables, you can refer, e.g., to this page: <http://www.sthda.com/english/articles/40-regression-analysis/163-regression-with-categorical-variables-dummy-coding-essentials-in-r/>.
	11. We can now **plot the predictions** of this model by using just one line of code in R.


Step 7 : Plot the predictions

>plot(allEffects(mod))
>






-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Questions:**
| - What treatments/doses have a **significant** effect on the outcome compared with the no-treatment control?

[Answer:]

	1. In the logistic regression model, the `NGN2_MOI` and `NT3_ng` variables represent different treatments or doses. 
	2. The summary output indicates that all levels of `NGN2_MOI` and `NT3_ng10` have highly significant effects on the log-odds of `fractMAP2` compared to their respective reference levels. 
	3. The `Pr(>|z|)` values for all these variables are less than 0.001.

Interpretation based on the summary:

1. NGN2_MOI:
	- Levels 2, 5, and 10 of  NGN2_MOI  all have highly significant effects compared to the reference level (`NGN2_MOI0` or the baseline level). 
	- The coefficients for these levels are significantly different from zero.
	- Therefore, the model is tells that all these levels (2, 5, 10) have a very strong and significant effect on the outcome compared to the reference level (probably no treatment).

2. NT3_ng:
	- Level 10 of NT3_ng has a highly significant effect compared to the reference level. The coefficient for NT3_ng10 is significantly different from zero.
	- This could represent a different treatment or dosage of another substance.

Overall Interpretation:
   - For both  NGN2_MOI and NT3_ng, when the values are not zero (2, 5, 10), they significantly impact the outcome compared to when these values are zero (probably no treatment).
   - The p-values (< 0.001) tell us how certain we are about these effects, and in this case, we're very confident.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 - What treatment/dose has the **strongest** **positve** effect on the outcome compared with the control?

[Answer:]{.underline} \*\* PROVIDE YOUR ANSWER HERE \*\*

In this logistic regression model, the strength of the positive effect is typically indicated by the magnitude of the coefficient associated with a particular treatment or dose. The larger the coefficient, the stronger the positive effect on the log-odds of the outcome. In this case, I look at the coefficients for the different levels of `NGN2_MOI` and `NT3_ng`.

From the summary output you provided:

1. **NGN2_MOI:**
   - The coefficients for `NGN2_MOI2`, `NGN2_MOI5`, and `NGN2_MOI10` represent the positive effect of each level compared to the reference level (probably `NGN2_MOI0` or the baseline level).
   - Among these, the largest coefficient is associated with `NGN2_MOI5`, which suggests that the treatment or dose represented by `NGN2_MOI5` has the strongest positive effect on the log-odds of the outcome.

2. **NT3_ng:**
   - The coefficient for `NT3_ng10` represents the positive effect of `NT3_ng` when its value is 10 compared to the reference level (probably 0).
   - This coefficient is smaller than the coefficients for `NGN2_MOI5`, indicating that the effect of `NGN2_MOI5` is stronger.

So, based on the coefficients in your model, it seems that the treatment or dose associated with `NGN2_MOI5` has the strongest positive effect on the outcome compared to the control or reference level.



\#Relevel

>levels(data$NGN2_MOI) # the original level order
[1] "0"  "2"  "5"  "10"

>data$NGN2_MOI = relevel(data$NGN2_MOI, ref=3) 
> levels(data$NGN2_MOI) # the new level order
[1] "5"  "0"  "2"  "10"

> mod3 = glm(fractMAP2 ~ NGN2_MOI + NT3_ng,family=binomial(link="logit"), data=data, weights = rep(10000,nrow(data)))
> summary(mod3)

Call:
glm(formula = fractMAP2 ~ NGN2_MOI + NT3_ng, family = binomial(link = "logit"), 
    data = data, weights = rep(10000, nrow(data)))

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -2.32867    0.01782 -130.66   <2e-16 ***
NGN2_MOI0   -3.97231    0.08883  -44.72   <2e-16 ***
NGN2_MOI2   -1.84823    0.03365  -54.92   <2e-16 ***
NGN2_MOI10  -0.85953    0.02360  -36.42   <2e-16 ***
NT3_ng10     0.31290    0.02084   15.02   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 10204.34  on 23  degrees of freedom
Residual deviance:   712.97  on 19  degrees of freedom
AIC: 890.95

Number of Fisher Scoring iterations: 5

\## Restore the original order - note that relevel() won't work as it will put 5 before 2 
> data$NGN2_MOI = factor(data$NGN2_MOI, levels = c("0", "2", "5", "10"))
> levels(data$NGN2_MOI)
[1] "0"  "2"  "5"  "10"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 **Question:** Did 5 MOI of the NGN2 virus perform significantly better than 2 and 10 MOI?

[Answer:]
To compare 5 MOI to 2 MOI or 10 MOI specifically, we can look at their individual coefficients:
So, from the summary output:
	- The coefficient for NGN2_MOI5 is 3.97231.
	- The coefficient for `NGN2_MOI2` is -1.84823.
	- The coefficient for `NGN2_MOI10` is -0.85953.

These coefficients represent the log-odds change compared to the reference level. The positive coefficient for `NGN2_MOI5` (3.97231) suggests a stronger positive effect compared to the negative coefficients for `NGN2_MOI2` and `NGN2_MOI10`. The difference in magnitude indicates that 5 MOI has a larger positive effect on the log-odds compared to 2 MOI and 10 MOI.

In summary, based on this logistic regression model, 5 MOI of the NGN2 virus performs significantly better than 2 MOI and 10 MOI in terms of the log-odds of the outcome.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Question**: Can you see what condition it is?
[Answer]
The condition with a large standard deviation is:
# Condition with large standard deviation
NGN2_MOI = 5, NT3_ng = 10
meanFractMAP2: 0.121
sdFractMAP2: 0.0271
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Note: If you locate this condition in the experimental table, you'll see that it's likely to do with one of the three replicates for this condition being a "dropout", in which either the differentiation or the immunostaining hasn't really worked for some technical reasons.

Let's **remove this dropout replicate** and rerun the analysis.
For this, we will locate the row in the original table corresponding to this replicate and create a new data table with this row filtered out.

\#To identify the rows to dropout:
> dropout_rows = data[data$NGN2_MOI == 5 & data$NT3_ng == 10,]
> dropout_rows

   	SampleID 	NGN2_MOI 	Control_MOI 	NT3_ng 	fractMAP2
16       	16        	5           	0     	10     	0.130
17       	17        	5          	 0     	10     	0.143
18       	18       	 5          	 0     	10    	 0.091


\# Filtering out the thr rows 16, 17, 18 which are three replicates.
dataFilt = data[-16,-17,-18]
> dataFilt
   	SampleID 	NGN2_MOI 	Control_MOI 	NT3_ng 	fractMAP2
1        	 1       	 0           	5      	0     	0.002
2         	2        	0           	5      	0     	0.001
3         	3        	0           	5      	0     	0.001
4        	 4        	0           	5     	10     	0.003
5         	5       	 0           	5     	10     	0.002
6         	6        	0           	5     	10     	0.004
7         	7        	2           	0      	0     	0.021
8         	8        	2           	0      	0     	0.018
9         	9        	2           	0     	 0     	0.026
10       	10        	2           	0     	10     	0.001
11       	11        	2           	0     	10    	 0.022
12       	12        	2           	0     	10     	0.019
13       	13        	5           	0      	0     	0.085
14       	14        	5           	0      	0     	0.091
15       	15        	5           	0     	 0     	0.079
17       	17        	5           	0     	10     	0.143
18       	18        	5           	0     	10     	0.091
19       	19       	10          	 0     	 0    	 0.037
20       	20       	10           	0     	 0     	0.032
21       	21       	10           	0      	0     	0.043
22       	22       	10           	0     	10     	0.059
23       	23       	10           	0     	10     	0.068
24       	24       	10          	 0     	10    	 0.040

We can now rerun the analysis.

First, let's **regenerate the summary table** and **replot** **the data**.
You can see that the error bar for the affected condition is now much smaller.


>sumdataFilt <- dataFilt %>% 
  group_by(NGN2_MOI, NT3_ng) %>%
  summarise(meanFractMAP2=mean(fractMAP2), sdFractMAP2 = sd(fractMAP2))

>ggplot(sumdataFilt, aes(x=NGN2_MOI, y=meanFractMAP2, fill=NT3_ng)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=meanFractMAP2-sdFractMAP2, ymax=meanFractMAP2+sdFractMAP2), 
                width=0.2,position=position_dodge(0.9))




Let's **rerun the logistic regression model** and compare the results with those run on unfiltered data.

| **Enter the model formula in the glm() function below.**

> mod2 = glm(fractMAP2 ~ NGN2_MOI + NT3_ng , family=binomial(link="logit"), data=dataFilt,  weights = rep(10000,nrow(dataFilt)))

> message("With the outlier:")
With the outlier:
> summary(mod)

Call:
glm(formula = fractMAP2 ~ NGN2_MOI + NT3_ng, family = binomial(link = "logit"), 
    data = data, weights = rep(10000, nrow(data)))

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -6.30098    0.08862  -71.10   <2e-16 ***
NGN2_MOI2    2.12408    0.09307   22.82   <2e-16 ***
NGN2_MOI5    3.97231    0.08883   44.72   <2e-16 ***
NGN2_MOI10   3.11278    0.08992   34.62   <2e-16 ***
NT3_ng10     0.31290    0.02084   15.02   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 10204.34  on 23  degrees of freedom
Residual deviance:   712.97  on 19  degrees of freedom
AIC: 890.95

Number of Fisher Scoring iterations: 5

> message("Without the outlier:")
Without the outlier:
> summary(mod2) 

Call:
glm(formula = fractMAP2 ~ NGN2_MOI + NT3_ng, family = binomial(link = "logit"), 
    data = dataFilt, weights = rep(10000, nrow(dataFilt)))

Coefficients: (1 not defined because of singularities)
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -6.28209    0.08870  -70.82   <2e-16 ***
NGN2_MOI2    2.12401    0.09307   22.82   <2e-16 ***
NGN2_MOI5    3.94057    0.08912   44.22   <2e-16 ***
NGN2_MOI10   3.11257    0.08992   34.62   <2e-16 ***
NT3_ng10     0.27994    0.02216   12.63   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 8876.8  on 22  degrees of freedom
Residual deviance:  692.8  on 18  degrees of freedom
AIC: 861.92

Number of Fisher Scoring iterations: 5

And let's now do the same using 5 MOI of NGN2 virus as reference.

| **Enter the model formula in the glm() function call below.**


>levels(dataFilt$NGN2_MOI)            # the original level order
>dataFilt$NGN2_MOI = relevel(dataFilt$NGN2_MOI, ref=3) 
>levels(dataFilt$NGN2_MOI)             # the new level order

\# Linear Regression model
>modFilt5MOI = glm(fractMAP2 ~ NGN2_MOI + NT3_ng, family=binomial(link="logit"), 
                   data=dataFilt, weights = rep(10000,nrow(dataFilt)))

> summary(modFilt5MOI)

Call:
glm(formula = fractMAP2 ~ NGN2_MOI + NT3_ng, family = binomial(link = "logit"), 
    data = dataFilt, weights = rep(10000, nrow(dataFilt)))

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -2.34153    0.01813 -129.16   <2e-16 ***
NGN2_MOI0   -3.94057    0.08912  -44.22   <2e-16 ***
NGN2_MOI2   -1.81656    0.03443  -52.77   <2e-16 ***
NGN2_MOI10  -0.82800    0.02468  -33.55   <2e-16 ***
NT3_ng10     0.27994    0.02216   12.63   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 8876.8  on 22  degrees of freedom
Residual deviance:  692.8  on 18  degrees of freedom
AIC: 861.92

Number of Fisher Scoring iterations: 5


# Restore the original order - note that relevel() won't work as it will put 5 before 2 
dataFilt$NGN2_MOI = factor(dataFilt$NGN2_MOI, levels = c("0", "2", "5", "10"))

> dataFilt$NGN2_MOI 
 [1] 0  0  0  0  0  0  2  2  2  2  2  2  5  5  5  5  5  10 10 10 10 10 10
Levels: 0 2 5 10

> levels(dataFilt$NGN2_MOI) # back to how they were originally
[1] "0"  "2"  "5"  "10"




To identify the changes in regression coefficients, let's compare the coefficients between the original logistic regression model (`mod`) and the logistic regression model after removing the outlier (`mod2`). The key change occurred in the row corresponding to `NGN2_MOI5`, which had an outlier.

Let's look at the coefficients for `NGN2_MOI5` in both models:

### Original Model (`mod`):
```R
# Coefficient for NGN2_MOI5 in the original model
NGN2_MOI5 in mod:
   Estimate    Std. Error    z value    Pr(>|z|)
3.97231        0.08883        44.72       <2e-16
```

### Model without Outlier (`mod2`):
```R
# Coefficient for NGN2_MOI5 in the model without the outlier
NGN2_MOI5 in mod2:
   Estimate    Std. Error    z value    Pr(>|z|)
3.94057        0.08912        44.22       <2e-16
```

| **Questions:** What regression coefficients have changed?
[Answer] To identify the changes in regression coefficients, let's compare the coefficients between the original logistic regression model (`mod`) 
and the logistic regression model after removing the outlier (`mod2`). The key change occurred in the row corresponding to `NGN2_MOI5`, which had an outlier.

Let's look at the coefficients for `NGN2_MOI5` in both models:

### Original Model (`mod`):
```R
# Coefficient for NGN2_MOI5 in the original model
NGN2_MOI5 in mod:
   Estimate    Std. Error    z value    Pr(>|z|)
3.97231        0.08883        44.72       <2e-16
```

### Model without Outlier (`mod2`):
```R
# Coefficient for NGN2_MOI5 in the model without the outlier
NGN2_MOI5 in mod2:
   Estimate    Std. Error    z value    Pr(>|z|)
3.94057        0.08912        44.22       <2e-16
```

The coefficient for `NGN2_MOI5` has changed slightly after removing the outlier. In the model without the outlier (`mod2`), 
the estimate is `3.94057` compared to `3.97231` in the original model (`mod`). The standard error and significance values also changed slightly.

The changes in coefficients are generally small, but they can occur when influential data points (like outliers) are removed. 
It's essential to interpret these changes in the context of your specific analysis and the impact of the outlier on the model.



