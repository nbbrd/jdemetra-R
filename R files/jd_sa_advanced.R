jd_pr<-J("java/lang/Class", "forName", "ec.tstoolkit.algorithm.IProcResults",TRUE,.jclassLoader())

proc_preprocessing<-function(rslts){
  .jcall(rslts, "Lec/tstoolkit/algorithm/IProcResults;", "get", "preprocessing", jd_pr)
}

proc_regarima<-function(rslts){
  pp<-proc_preprocessing(rslts)
  estimation<-.jfield(pp, "Lec/tstoolkit/modelling/arima/ModelEstimation;", "estimation")
  .jcall(estimation, "Lec/tstoolkit/arima/estimation/RegArimaModel;", "getRegArima")
}

proc_forecasting<-function(rslts, outofsample=TRUE, nfcasts=18){
  fcasttest<-.jnew("ec/tstoolkit/modelling/arima/diagnostics/OneStepAheadForecastingTest", as.integer(nfcasts))
  .jcall(fcasttest, "Z", "test", proc_regarima(rslts))
  if (outofsample){
    jtest<-.jcall(fcasttest, "Lec/tstoolkit/stats/MeanTest;", "outOfSampleMeanTest")
  }else{
    jtest<-.jcall(fcasttest, "Lec/tstoolkit/stats/MeanTest;", "inSampleMeanTest")
  }
  jdist<-.jcall(jtest, "Lec/tstoolkit/dstats/IDistribution;","getDistribution")
  desc<-.jcall(jdist, "S", "toString")
  mean<-.jcall(jtest, "D", "getMean")
  emean<-.jcall(jtest, "D", "getExpectedMean")
  if (outofsample){
    mse<-.jcall(fcasttest, "D", "getOutOfSampleMSE")
  }else{
    mse<-.jcall(fcasttest, "D", "getInSampleMSE")
  }
  pval<-.jcall(jtest, "D", "getPValue")
  all<-c(mean, emean, mse, pval)
  attr(all, "mean test")<-desc
  all
}