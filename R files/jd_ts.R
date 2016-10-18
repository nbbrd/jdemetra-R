
period_r2jd<-function(s){
	freq<-s[1]
	jd_freq<-.jcall("ec/tstoolkit/timeseries/simplets/TsFrequency", "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "valueOf", as.integer(freq))
	.jnew("ec/tstoolkit/timeseries/simplets/TsPeriod", jd_freq, as.integer(s[2]), as.integer(s[3]-1))
}

period_jd2r<-function(jd_p){
  if (is.null(jd_p))
    return (NULL)
  jd_freq<-.jcall(jd_p, "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "getFrequency")
	frequency<-.jcall(jd_freq, "I", "intValue")
year<-.jcall(jd_p, "I", "getYear")
	position<-.jcall(jd_p, "I", "getPosition")
	c(frequency, year, position+1)
}

domain_r2jd<-function(s){
  freq<-s[1]
  jd_freq<-.jcall("ec/tstoolkit/timeseries/simplets/TsFrequency", "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "valueOf", as.integer(freq))
  .jnew("ec/tstoolkit/timeseries/simplets/TsDomain", jd_freq, as.integer(s[2]), as.integer(s[3]-1), as.integer(s[4]))
}

domain_jd2r<-function(jd_d){
  if (is.null(jd_d))
    return (NULL)
  jd_start<-.jcall(jd_d, "Lec/tstoolkit/timeseries/simplets/TsPeriod;", "getStart")
  jd_freq<-.jcall(jd_start, "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "getFrequency")
  frequency<-.jcall(jd_freq, "I", "intValue")
  year<-.jcall(jd_start, "I", "getYear")
  position<-.jcall(jd_start, "I", "getPosition")
  len<-.jcall(jd_d, "I", "getLength")
  c(frequency, year, position+1, len)
}

ts_r2jd<-function(s){
	freq<-frequency(s)
	start<-start(s)
	jd_freq<-.jcall("ec/tstoolkit/timeseries/simplets/TsFrequency", "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "valueOf", as.integer(freq))
	ts<-.jnew("ec/tstoolkit/timeseries/simplets/TsData", jd_freq, as.integer(start[1]), as.integer(start[2]-1), as.integer(length(s)))
	for (i in 1:length(s)){
  		v=s[i]
  		.jcall(ts, "V", "set", as.integer(i-1), as.double(v))
	}
	ts
}

ts_jd2r<-function(s){
  if (is.null(s)){
    return (NULL)
  }
  jd_start<-.jcall(s, "Lec/tstoolkit/timeseries/simplets/TsPeriod;", "getStart")
	pstart<-period_jd2r(jd_start)
	len<-.jcall(s, "I", "getLength")
	x<-numeric(length=len)
	for (i in 1:length(x)){
  		x[i]=.jcall(s, "D", "get", as.integer(i-1))
	}
	ts(x,start=pstart[2:3], frequency=pstart[1])
}

ts_airline<-function(len){
	factory<-.jnew("ec/tstoolkit/sarima/SarimaModelBuilder")
	arima<-.jcall(factory, "Lec/tstoolkit/sarima/SarimaModel;", "createAirlineModel", as.integer(12), as.double(-.6), as.double(-.8))
	arima<-.jcall(factory, "Lec/tstoolkit/sarima/SarimaModel;", "randomize", arima, as.double(-.1))
	factory2<-.jnew("ec/tstoolkit/arima/ArimaModelBuilder")
	data<-.jcall(factory2, "[D", "generate", .jcast(arima, "ec/tstoolkit/arima/IArimaModel"), as.integer(len))
	ts(data, start=c(2000, 1), frequency=12)
}

ts_aggregate<-function(s, newfreq, mode="Sum"){
	jd_s<-ts_r2jd(s)
	jd_freq<-.jcall("ec/tstoolkit/timeseries/simplets/TsFrequency", "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "valueOf", as.integer(newfreq))
	jd_mode<-.jcall("ec/tstoolkit/timeseries/TsAggregationType", "Lec/tstoolkit/timeseries/TsAggregationType;", "valueOf", mode)
	jd_agg<-.jcall(jd_s, "Lec/tstoolkit/timeseries/simplets/TsData;", "changeFrequency", jd_freq, jd_mode, TRUE)
	ts_jd2r(jd_agg)
}


