jd_seasonality<-function(s, test="QS", differencing=1, mean=TRUE){
  jd_s<-ts_r2jd(s)  
  jd_seas<-.jcall("ec/tstoolkit/modelling/arima/tramo/SeasonalityTests", "Lec/tstoolkit/modelling/arima/tramo/SeasonalityTests;",
                  "seasonalityTest", jd_s, as.integer(differencing), mean, TRUE)
  if (test=="QS"){
    jd_qs<-.jcall(jd_seas, "Lec/tstoolkit/stats/StatisticalTest;","getQs")
    val<-.jcall(jd_qs, "D", "getValue")
    pval<-.jcall(jd_qs, "D", "getPValue")
    all<-c(val, pval)
    jd_dist<-.jcall(jd_qs, "Lec/tstoolkit/dstats/IDistribution;", "getDistribution")
    desc<-.jcall(jd_dist, "S", "toString")
    attr(all, "description")<-desc
    all
  }else if (test=="FRIEDMAN"){
    jd_qs<-.jcall(jd_seas, "Lec/satoolkit/diagnostics/FriedmanTest;","getNonParametricTest")
    val<-.jcall(jd_qs, "D", "getValue")
    pval<-.jcall(jd_qs, "D", "getPValue")
    all<-c(val, pval)
    jd_dist<-.jcall(jd_qs, "Lec/tstoolkit/dstats/IDistribution;", "getDistribution")
    desc<-.jcall(jd_dist, "S", "toString")
    attr(all, "description")<-desc
    all
  }else if (test=="KRUSKALWALLIS"){
    jd_diff<-.jcall(jd_seas, "Lec/tstoolkit/modelling/DifferencingResults;", "getDifferencing")
    jd_ds<-.jcall(jd_diff, "Lec/tstoolkit/timeseries/simplets/TsData;", "getDifferenced")
    jd_kw<-.jnew("ec/satoolkit/diagnostics/KruskalWallisTest", jd_ds)
    val<-.jcall(jd_kw, "D", "getValue")
    pval<-.jcall(jd_kw, "D", "getPValue")
    all<-c(val, pval)
    jd_dist<-.jcall(jd_kw, "Lec/tstoolkit/dstats/IDistribution;", "getDistribution")
    desc<-.jcall(jd_dist, "S", "toString")
    attr(all, "description")<-desc
    all
  }else if (test=="PERIODOGRAM"){
    jd_qs<-.jcall(jd_seas, "Lec/tstoolkit/stats/StatisticalTest;","getPeriodogramTest")
    val<-.jcall(jd_qs, "D", "getValue")
    pval<-.jcall(jd_qs, "D", "getPValue")
    all<-c(val, pval)
    jd_dist<-.jcall(jd_qs, "Lec/tstoolkit/dstats/IDistribution;", "getDistribution")
    desc<-.jcall(jd_dist, "S", "toString")
    attr(all, "description")<-desc
    all
  }
  
}

jd_seasftest<-function(s, ami=FALSE){
  jd_s<-ts_r2jd(s)  
  jd_f<-.jnew("ec/satoolkit/diagnostics/FTest");
  if (ami){
    .jcall(jd_f, "Z", "testAMI", jd_s)
  }else{
    .jcall(jd_f, "Z", "test", jd_s)
  }
  jd_test<-.jcall(jd_f, "Lec/tstoolkit/stats/StatisticalTest;","getFTest")
  val<-.jcall(jd_test, "D", "getValue")
  pval<-.jcall(jd_test, "D", "getPValue")
  all<-c(val, pval)
  jd_dist<-.jcall(jd_test, "Lec/tstoolkit/dstats/IDistribution;", "getDistribution")
  desc<-.jcall(jd_dist, "S", "toString")
  attr(all, "description")<-desc
  all
}