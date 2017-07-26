source("./R files/jd_ts.R")


jd_cholette<-function(s, t, rho=1, lambda=1, conversion="Average"){
  monitor<-.jnew("ec.benchmarking.simplets.TsCholette")
  jd_s<-ts_r2jd(s)
	jd_t<-ts_r2jd(t)
	.jcall(monitor, "V", "setRho", as.double(rho))
	.jcall(monitor, "V", "setLambda", as.double(lambda))
	jd_conversion<-.jcall("ec/tstoolkit/timeseries/TsAggregationType", "Lec/tstoolkit/timeseries/TsAggregationType;", "valueOf", conversion)
	.jcall(monitor, "V", "setAggregationType", jd_conversion)
	ts_jd2r(.jcall(monitor, "Lec/tstoolkit/timeseries/simplets/TsData;", "benchmark",jd_s, jd_t))
}

jd_denton<-function(s, t, mul=TRUE, modified=TRUE, d=1,  conversion="Average"){
  monitor<-.jnew("ec.benchmarking.simplets.TsDenton2")
  jd_s<-ts_r2jd(s)
  jd_t<-ts_r2jd(t)
  .jcall(monitor, "V", "setDifferencingOrder", as.integer(d))
  .jcall(monitor, "V", "setMultiplicative", as.logical(mul))
  .jcall(monitor, "V", "setModified", as.logical(modified))
  jd_conversion<-.jcall("ec/tstoolkit/timeseries/TsAggregationType", "Lec/tstoolkit/timeseries/TsAggregationType;", "valueOf", conversion)
  .jcall(monitor, "V", "setAggregationType", jd_conversion)
  ts_jd2r(.jcall(monitor, "Lec/tstoolkit/timeseries/simplets/TsData;", "benchmark",jd_s, jd_t))
}

