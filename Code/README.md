## Reproducing the Paper Experiments

## Contents

  This folder contains  all code that is necessary to replicate the
  experiments reported in the paper *"REBAGG: REsampled BAGGing for Imbalanced Regression"* [1]

  The folder contains the following files:

  - **ExpsBagg.R** the main script for obtaining the results of the strategies for regression presented in the paper 

  - **EstTasks.R** the script with auxiliary functions for defining the estimation tasks
  
  - **WFsEval.R** the script with auxiliary functions for defining the workflows and the evaluation procedure

  - **README.md** this file

## Necessary Software

To replicate these experiments you will need a working installation
  of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - DMwR
  - performanceEstimation
  - UBL
  - uba
  - randomForest
  - e1071
  - earth
  - rpart
  - gbm


  All the above packages with exception of uba, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("DMwR","performanceEstimation", "UBL", "randomForest", "e1071", "earth", "rpart", "gbm"))
```

The implementation of REBAGG strategies described in the paper are contained in UBL package. You should install UBL with version 0.07 or higher to guarantee that these strategies are available in the pacakge.

Additionally, you will need to install uba package from a tar.gz file that you can download from [http://www.dcc.fc.up.pt/~rpribeiro/uba/]. 

For installing this package issue the following command within R:
```r
install.packages("uba_0.7.8.tar.gz",repos=NULL,dependencies=T)
```


## Running the experiences:

  Before running the experiments you need to load the data sets used in R. To obtain the 20 regression data sets and to see how you can load them, please check the README.md file in the **Data** folder. After having the necessary data sets, to run the experiments described in the paper you execute R in the folder with the code and then issue the command:
  
```r
source("ExpsBagg.R")
```

Alternatively, you may run the experiments directly from a Linux terminal
  (useful if you want to logout because some experiments take a long
  time to run):

```bash
nohup R --vanilla --quiet < ExpsBagg.R &
```

## Running a subset of the experiences:

  Given that the experiments take  long time to run, you may be interested in running only a partial set of experiments. To do this you must edit the ExpsDIBS.R file. 
  
  Lets say, for instance, that you want to run all the workflows in only one data set. To do this you can change the instruction 
  ```r 
  for(d in 1:20)
  ``` 
  in line 105 of ExpsBagg.R file. If the data set that you select is the fifth, the you need to change this instruction to 

 ```r
 for(d in 5)
 ```
  
  You can also change the number and/or the values of the learning algorithms parameters. To achieve this edit the *WFs* list in lines 101 to 104. For instance, if you only want to run the experiments for the svm learner but with more values for the cost parameter, you should comment the lines with the other learners (randomForest, earth and nnet) and add the values you want in the cost. Lines 88 to 96 could be changed as follows:
  
```r

WFs$svm <- list(learner.pars=list(cost=c(10, 50, 100, 150, 200, 300), gamma=c(0.01,0.001)))
# WFs$randomForest <- list(learner.pars=list(mtry=c(5,7),ntree=c(500,750,1500)))
# WFs$earth <- list(learner.pars=list(nk=c(10,17),degree=c(1,2),thresh=c(0.01,0.001)))
# WFs$rpart <- list(learner.pars=list(minsplit=c(20,50,100,200),cp=c(0.01,0.05)))
# WFs$gbm <- list(learner.pars=list(distribution="gaussian",
#                                   n.trees=c(300, 450, 600),
#                                   shrinkage=c(0.01, 0.1),
#                                   interaction.depth=c(1,2)))
```

  
  After making all the necessary changes run the experiments as previously explained.


*****

### References
[1] Branco, P. and Torgo, L. and Ribeiro, R.P. (2018) *"REBAGG: REsampled BAGGing for Imbalanced Regression"* LIDTA2018: 2nd International Workshop on Learning with Imbalanced Domains: Theory and Applications (Co-located with ECML/PKDD 2018) Dublin, Ireland (**to appear**)

