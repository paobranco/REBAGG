## REBAGG: REsampled BAGGing for Imbalanced Regression Tasks - LIDTA 2018

This repository has all the code used in the experiments carried out in the paper *"REBAGG: REsampled BAGGing for Imbalanced Regression"* [1].


This repository is organized as follows:

* **Code** folder - contains all the code for reproducing the experiments presented in the paper;
* **Data** folder - contains the 20 regression data sets used in the experiments carried out;


### Requirements

The experimental design was implemented in R language. Both code and data are in a format suitable for R environment.

In order to replicate these experiments you will need a working installation
  of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - DMwR
  - performaceEstimation
  - UBL
  - uba
  - randomForest
  - e1071
  - earth
  - rpart
  - gbm


All the above packages with the exception of uba, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("DMwR", "performanceEstimation", "UBL", "randomForest", "e1071", "earth", "rpart", "gbm"))
```

The package uba needs to be installed from a tar.gz file that you
  can download from http://www.dcc.fc.up.pt/~rpribeiro/uba/.
  Download the tar.gz file into your folder and then issue:

```r
install.packages("uba_0.7.8.tar.gz",repos=NULL,dependencies=T)
```

Check the other README files in each folder to see more detailed instructions on how to run the experiments.

*****

### References
[1] Branco, P. and Torgo, L. and Ribeiro, R.P. (2018) *"REBAGG: REsampled BAGGing for Imbalanced Regression"* LIDTA2018: 2nd International Workshop on Learning with Imbalanced Domains: Theory and Applications (Co-located with ECML/PKDD 2018) Dublin, Ireland (**to appear**)

