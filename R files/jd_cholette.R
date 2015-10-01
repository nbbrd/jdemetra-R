jd_cholette<-.jnew("ec.benchmarking.simplets.TsCholette")

cholette<-function(s, t, rho=-.9991, lambda=1){
	jd_s<-ts_r2jd(s)
	jd_t<-ts_r2jd(t)
	.jcall(jd_cholette, "V", "setRho", as.double(rho))
	.jcall(jd_cholette, "V", "setLambda", as.double(lambda))
	ts_jd2r(.jcall(jd_cholette, "Lec/tstoolkit/timeseries/simplets/TsData;", "benchmark",jd_s, jd_t))
}