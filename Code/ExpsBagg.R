
library(e1071)                 # where the svm is
library(performanceEstimation) # exps framework
library(DMwR)                  
library(randomForest)          # randomForest
library(earth)                 # MARS reimplementation
library(UBL)                   # bagging ensemble UBL VERSION 0.0.7
library(uba)                   # utility-based evaluation framework
library(nnet)                  # neural networks
library(rpart)                 # tree models
library(gbm)                   # for gbm models

source("WFsEval.R")
##############################################################
# THE USED DATA SETS
# ============================================================
load("All20DataSets.RData")
#########################################################################
# to generate information about the data sets for a given threshold
#########################################################################
PCSall <- list()

for(d in 1:20)
{
  y <- resp(DSs[[d]]@formula,DSs[[d]]@data)
  pc <- UBL::phi.control(y, method="extremes")
  lossF.args <- loss.control(y)
  PCSall[[d]] <- list(pc, lossF.args)
}

thr.rel <- 0.8
for(d in 1:20){
  form <- DSs[[d]]@formula
  data <- DSs[[d]]@data
  y <- resp(form,data)
  pc <- list()
  pc$method <- PCSall[[d]][[1]][[1]]
  pc$npts <- PCSall[[d]][[1]][[2]]
  pc$control.pts <- PCSall[[d]][[1]][[3]]
  both <- all(pc$control.pts[c(2,8)] == c(1,1))
  y.relev <- phi(y,pc)
  total <- 0
  if (both) {  # we have both low and high extrs
    rare.low <- which(y.relev > thr.rel & y < pc$control.pts[4])
    rare.high <- which(y.relev > thr.rel & y > pc$control.pts[4])
    rare.cases <- c(rare.low,rare.high)
    total <- length(rare.cases)
  } else {
    # the indexes of the cases with rare target variable values
    rare.cases <- if (pc$control.pts[2] == 1)  which(y.relev > thr.rel & y < pc$control.pts[4]) else which(y.relev > thr.rel & y > pc$control.pts[4])
    total <- length(rare.cases)
    
  }
  cat(DSs[[d]]@name, "Nrare:", total, "%rare", round(total/length(y),3), "\n")
}


PCS <- list(PCSall[[1]], PCSall[[2]],PCSall[[3]], PCSall[[4]],PCSall[[5]],
            PCSall[[6]],PCSall[[7]],PCSall[[8]], PCSall[[9]], PCSall[[10]], 
            PCSall[[11]], PCSall[[12]], PCSall[[13]], PCSall[[14]], PCSall[[15]],
            PCSall[[16]], PCSall[[17]], PCSall[[18]], PCSall[[19]], PCSall[[20]])

myDSs <- list(PredTask(a1~., DSs[[1]]@data, "a1"), PredTask(a2~., DSs[[2]]@data, "a2"),
              PredTask(a3~., DSs[[3]]@data, "a3"), PredTask(a4~., DSs[[4]]@data, "a4"),
              PredTask(a5~., DSs[[5]]@data, "a5"),
              PredTask(a6~., DSs[[6]]@data, "a6"), PredTask(a7~., DSs[[7]]@data, "a7"),
              PredTask(Rings~., DSs[[8]]@data, "Abalone"),
              PredTask(acceleration~., DSs[[9]]@data, "acceleration"),
              PredTask(available.power~., DSs[[10]]@data, "availPwr"),
              PredTask(rej~., DSs[[11]]@data, "bank8FM"), 
              PredTask(usr~., DSs[[12]]@data, "cpuSm"),
              PredTask(fuel.consumption.country~., DSs[[13]]@data, "fuelCons"),
              PredTask(Sa~., DSs[[14]]@data, "dAiler"),
              PredTask(HousValue~., DSs[[15]]@data, "boston"),
              PredTask(maximal.torque~.,DSs[[16]]@data, "maxTorque"),
              PredTask(class~.,DSs[[17]]@data, "machineCpu"),
              PredTask(class~.,DSs[[18]]@data, "servo"),
              PredTask(ScaledSoundPressure~.,DSs[[19]]@data, "airfoild"),
              PredTask(ConcreteCompressiveStrength~.,DSs[[20]]@data, "concreteStrength"))

# weight for penalizing FP ot FN
#p <- 0.5
##########################################################################
# learners and estimation procedure
##########################################################################

WFs <- list()

WFs$svm <- list(learner.pars=list(cost=c(10,150,300), gamma=c(0.01,0.001)))
WFs$randomForest <- list(learner.pars=list(mtry=c(5,7),ntree=c(500,750,1500)))
WFs$earth <- list(learner.pars=list(nk=c(10,17),degree=c(1,2),thresh=c(0.01,0.001)))
WFs$nnet <- list(learner.pars=list(size=c(1,2,5,10), decay=c(0, 0.01)))
WFs$rpart <- list(learner.pars=list(minsplit=c(20,50,100,200),cp=c(0.01,0.05)))
# exps with 2 times 10 fold CV


source("EstTasks.R")
##########################################################################
# exps
##########################################################################

for(d in 1:20){
  for(w in names(WFs)) {
    resObj <- paste(myDSs[[d]]@taskName,w,'Res',sep='')
    assign(resObj,
           try(
             performanceEstimation(
               myDSs[d],         
               c(
                 do.call('workflowVariants',
                         c(list('WFnone', learner=w),
                           WFs[[w]],
                           varsRootName=paste('WFnone',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFBagg',learner=w, nmodels=c(10,40)),
                           WFs[[w]],
                           varsRootName=paste('WFBagg',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFREBaggBal',learner=w, nmodels=c(10,40),
                                rel=matrix(PCS[[d]][[1]][[3]],ncol=3, byrow=TRUE),
                                thr.rel=thr.rel),
                           WFs[[w]],
                           varsRootName=paste('WFREBaggBal',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFREBaggNBal',learner=w, nmodels=c(10,40),
                                rel=matrix(PCS[[d]][[1]][[3]],ncol=3, byrow=TRUE),
                                thr.rel=thr.rel),
                           WFs[[w]],
                           varsRootName=paste('WFREBaggNBal',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFREBaggVar',learner=w, nmodels=c(10,40),
                                rel=matrix(PCS[[d]][[1]][[3]],ncol=3, byrow=TRUE),
                                thr.rel=thr.rel),
                           WFs[[w]],
                           varsRootName=paste('WFREBaggVar',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFREBaggNVar',learner=w, nmodels=c(10,40),
                                rel=matrix(PCS[[d]][[1]][[3]],ncol=3, byrow=TRUE),
                                thr.rel=thr.rel),
                           WFs[[w]],
                           varsRootName=paste('WFREBaggNVar',w,sep='.'),
                           as.is="rel"
                         ))
               ),
               CVsetts[[d]])
           )
    )
    if (class(get(resObj)) != 'try-error') save(list=resObj,file=paste(myDSs[[d]]@taskName,w,'Rdata',sep='.'))
  }
}


