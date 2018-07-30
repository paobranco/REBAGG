##########################################################################
# Workflows
# define several workflows for applying the different resampling strategies for regression tasks
##########################################################################
WFnone <- function(form, train, test, learner, learner.pars){
  preds <- do.call(paste('cv', learner, sep='.'),
                   list(form, train, test, learner.pars))
  res <- list(trues=responseValues(form, test), preds=preds)
  return(res)
}


WFBagg <- function(form, train, test, learner, nmodels, learner.pars){
 M <- BaggingRegress(form, train, nmodels, learner, learner.pars, aggregation = "Average")
 preds <- predict(M, test)
 res <- list(trues=responseValues(form,test),preds=preds)
 return(res)
}


WFREBaggBal <- function(form, train, test, learner, nmodels, rel,
                   thr.rel, learner.pars){
  M <- ReBagg(form, train, rel, thr.rel, learner, learner.pars, nmodels,
              samp.method="balance", aggregation = "Average")
  preds <- predict(M, test)
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}


WFREBaggNBal <- function(form, train, test, learner, nmodels, rel,
                        thr.rel, learner.pars){
  M <- ReBagg(form, train, rel, thr.rel, learner, learner.pars, nmodels,
              samp.method="balanceSMT", aggregation = "Average")
  preds <- predict(M, test)
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}

WFREBaggVar <- function(form, train, test, learner, nmodels, rel,
                         thr.rel, learner.pars){
  M <- ReBagg(form, train, rel, thr.rel, learner, learner.pars, nmodels,
              samp.method="variation", aggregation = "Average")
  preds <- predict(M, test)
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}

WFREBaggNVar <- function(form, train, test, learner, nmodels, rel,
                         thr.rel, learner.pars){
  M <- ReBagg(form, train, rel, thr.rel, learner, learner.pars, nmodels,
              samp.method="variationSMT", aggregation = "Average")
  preds <- predict(M, test)
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}


# define the learn/test functions for the systems
cv.svm <- function(form,train,test,learner.pars) {
  cost <- learner.pars$cost
  gamma <- learner.pars$gamma
  m <- svm(form,train, cost=cost, gamma=gamma)
  predict(m,test)
}
cv.randomForest <- function(form,train,test,learner.pars) {
  mtry <- learner.pars$mtry
  ntree <- learner.pars$ntree
  m <- randomForest(form,train, ntree=ntree, mtry=mtry)
  predict(m,test)
}

cv.earth <- function(form,train,test,learner.pars) {
  nk <- learner.pars$nk
  degree <- learner.pars$degree
  thresh <- learner.pars$thresh
  m <- earth(form,train,nk=nk, degree=degree, thresh=thresh)
  predict(m,test)[,1]
}

cv.lm <- function(form, train, test, learner.pars) {
 dummy <- learner.pars$dummy
 m <- lm(form, train)
 predict(m, test)
}

cv.nnet <- function(form,train,test,learner.pars){
 size <- learner.pars$size
 decay <- learner.pars$decay
 m <- nnet(form, train, size=size, decay=decay, linout=TRUE, trace=FALSE)
 predict(m, test)
}

cv.rpart <- function(form,train,test,learner.pars){
  se <- learner.pars$se
  minsplit <- learner.pars$minsplit
  m <- rpartXse(form, train, se=se, minsplit=minsplit)
  predict(m, test)
}

cv.gbm <- function(form,train,test,learner.pars) {
  distribution <- learner.pars$distribution
  n.trees <- learner.pars$n.trees
  interaction.depth <- learner.pars$interaction.depth
  shrinkage <- learner.pars$shrinkage
  m <- gbm(form, train, distribution=distribution, n.trees = n.trees,
           interaction.depth = interaction.depth, shrinkage = shrinkage)
  predict(m,test, n.trees=n.trees)
}

# ============================================================
# EVALUATION STATISTICS
# metrics definition for the estimation task
# ============================================================

eval.stats <- function(trues, preds, train, metrics,
                       thr.rel, method,npts,control.pts,
                       ymin,ymax,tloss,epsilon,p) {
  pc <- list()
  pc$method <- method
  pc$npts <- npts
  pc$control.pts <- control.pts
  lossF.args <- list()
  lossF.args$ymin <- ymin
  lossF.args$ymax <- ymax
  lossF.args$tloss <- tloss
  lossF.args$epsilon <- epsilon
  
  MU <- util(preds, trues, pc, lossF.args, util.control(umetric="MU",p=p))
  NMU <- util(preds, trues, pc, lossF.args, util.control(umetric="NMU",p=p))
  ubaprec <- util(preds,trues,pc,lossF.args,util.control(umetric="P", event.thr=thr.rel, p=p))
  ubarec  <- util(preds,trues,pc,lossF.args,util.control(umetric="R", event.thr=thr.rel, p=p))
  ubaF1   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=1, event.thr=thr.rel, p=p))
  ubaF05   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=0.5, event.thr=thr.rel, p=p))
  ubaF2   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=2, event.thr=thr.rel, p=p))
  
  c(mad = mean(abs(trues-preds)),
    mse = mean((trues-preds)^2),
    mae_phi = mean(phi(trues,phi.parms=pc)*(abs(trues-preds))),
    mse_phi = mean(phi(trues,phi.parms=pc)*(trues-preds)^2),
    rmse_phi = sqrt(mean(phi(trues,phi.parms=pc)*(trues-preds)^2)),
    ubaF1 = ubaF1,
    ubaF05 = ubaF05,
    ubaF2 = ubaF2,
    ubaprec = ubaprec,
    ubarec = ubarec,
    MU = MU,
    NMU = NMU)
}
