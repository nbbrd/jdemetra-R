jd_pr<-J("java/lang/Class", "forName", "ec.tstoolkit.algorithm.IProcResults",TRUE,.jclassLoader())

proc_preprocessing<-function(rslts){
  .jcall(rslts, "Lec/tstoolkit/algorithm/IProcResults;", "get", "preprocessing", jd_pr)
}

proc_regarima<-function(rslts){
  pp<-proc_preprocessing(rslts)
  estimation<-.jfield(pp, "Lec/tstoolkit/modelling/arima/ModelEstimation;", "estimation")
  .jcall(estimation, "Lec/tstoolkit/arima/estimation/RegArimaModel;", "getRegArima")
}

# Forecasting tests computed on a regarima model (java object given by proc_regarima, for instance)
# The output is an array with successively
# mean of the residuals, expected mean (usually 0), mean squared error, P-value of the mean test (<.01 for "abnormal" means)
# The statistics are computed on the last residuals (given by nfcasts)
# The coefficients of the model are computed either in (all the series)
# or out of sample (all the series but the nfcasts last observations).
proc_forecasting<-function(regarima, outofsample=TRUE, nfcasts=18){
  fcasttest<-.jnew("ec/tstoolkit/modelling/arima/diagnostics/OneStepAheadForecastingTest", as.integer(nfcasts))
  .jcall(fcasttest, "Z", "test", regarima)
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

# Retrieve the outliers of a regarima model (java object given by proc_preprocessing, for instance)
# The output is an array of strings. May be null.
proc_outliers<-function(preprocessing, all=TRUE, fixed=TRUE){
  #description of the pre-processing  
  jdesc<-.jfield(preprocessing, "Lec/tstoolkit/modelling/arima/ModelDescription;", "description")
  # gets the estimated outliers 
  jout<-.jcall(jdesc, "Ljava/util/List;", "getOutliers")
  nout<-.jcall(jout, "I", "size")
  # gets the pre-specified outliers 
  if (all){
    jpout<-.jcall(jdesc, "Ljava/util/List;", "getPrespecifiedOutliers")
    npout<-.jcall(jpout, "I", "size")
  }else{
    jpout<-NULL
    npout<-0
  }
  if (nout+npout == 0){
    return(NULL)
  }
  idx<-1
  outs<-array(dim=nout+npout)
  if (nout>0){
    for (i in 1:nout){
      jcur<-.jcast(.jcall(jout, "Ljava/lang/Object;", "get", as.integer(i-1)), "ec/tstoolkit/timeseries/regression/IOutlierVariable")
      code<-.jcall(.jcall(jcur, "Lec/tstoolkit/timeseries/regression/OutlierType;", "getOutlierType"), "S", "toString")
      jperiod<-.jcall(jcur, "Lec/tstoolkit/timeseries/simplets/TsPeriod;", "getPosition")
      jday<-.jcall(jperiod, "Lec/tstoolkit/timeseries/Day;", "firstday")
      if (fixed){
        code<-paste(code,.jcall(jday, "S", "toString"), 'f', sep='.')
      }else{
        code<-paste(code,.jcall(jday, "S", "toString"), sep='.')
      }
      outs[idx]<-code
      idx=idx+1
    }
  } 
  if (npout>0){
    for (i in 1:npout){
      jcur<-.jcast(.jcall(jpout, "Ljava/lang/Object;", "get", as.integer(i-1)), "ec/tstoolkit/timeseries/regression/IOutlierVariable")
      code<-.jcall(.jcall(jcur, "Lec/tstoolkit/timeseries/regression/OutlierType;", "getOutlierType"), "S", "toString")
      jperiod<-.jcall(jcur, "Lec/tstoolkit/timeseries/simplets/TsPeriod;", "getPosition")
      jday<-.jcall(jperiod, "Lec/tstoolkit/timeseries/Day;", "firstday")
      code<-paste(code,.jcall(jday, "S", "toString"), 'f', sep='.')
      outs[idx]<-code
      idx=idx+1
    }
  } 
  return(outs)
}