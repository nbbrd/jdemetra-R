if(!require(rJava)){
  install.packages("rJava")
}
library("rJava")
.jinit()
.jaddClassPath("./Java/demetra-tstoolkit-2.1.0.jar")
jd_month<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Monthly")
jd_quarter<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Quarterly")
jd_year<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Yearly")
jd_undef<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Undefined")


jd_clobj<-.jcall("java/lang/Class", "Ljava/lang/Class;", "forName", "java.lang.Object")

jd_pfixed<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Fixed")
jd_pinitial<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Initial")
jd_pestimated<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Estimated")
jd_pundefined<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Undefined")

jd_td<-.jfield("ec/tstoolkit/timeseries/calendars/TradingDaysType","Lec/tstoolkit/timeseries/calendars/TradingDaysType;","TradingDays")
jd_wd<-.jfield("ec/tstoolkit/timeseries/calendars/TradingDaysType","Lec/tstoolkit/timeseries/calendars/TradingDaysType;","WorkingDays")


jd_params<-function(data, type){
	x<-list()
	len<-length(data)
	pclass<-J("java/lang/Class", "forName", "ec.tstoolkit.Parameter",TRUE,.jclassLoader())
	pobjs<-.jcall("java/lang/reflect/Array", "Ljava/lang/Object;", "newInstance", pclass, as.integer(len))
  if (len>0){
	for (i in 1:len){
      z<-as.double(data[i])
	    pobj<-.jnew("ec/tstoolkit/Parameter",z, type)
      .jcall("java/lang/reflect/Array", "V", "set", .jcast(pobjs, "java/lang/Object"), as.integer(i-1), .jcast(pobj, "java/lang/Object"))
	}
  }
	pobjs
}

jd_january<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","January")
jd_february<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","February")
jd_march<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","March")
jd_april<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","April")
jd_may<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","May")
jd_june<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","June")
jd_july<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","July")
jd_august<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","August")
jd_september<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","September")
jd_october<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","October")
jd_november<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","November")
jd_december<-.jfield("ec/tstoolkit/timeseries/Month","Lec/tstoolkit/timeseries/Month;","December")
jd_allmonths<-c(jd_january, jd_february, jd_march, jd_april, jd_may, jd_june, jd_july, jd_august, jd_september, jd_october, jd_november, jd_december)

month_r2jd<-function(s){
  .jcall("ec/tstoolkit/timeseries/Month", "Lec/tstoolkit/timeseries/Month;", "valueOf", as.integer(s-1))
}

month_jd2r<-function(jd_month){
  .jcall(jd_month, "I", "intValue")+1
}

matrix_jd2r<-function(jd_matrix){
  nrows=.jcall(jd_matrix, "I", "getRowsCount")
  ncols=.jcall(jd_matrix, "I", "getColumnsCount")
  rmat<-numeric(nrows*ncols)
  dim(rmat)<-c(nrows,ncols)
  for (i in 1:nrows){
    for (j in 1:ncols){
      rmat[i, j]=.jcall(jd_matrix, "D", "get", as.integer(i-1), as.integer(j-1))
    }
  }
  rmat
}

matrix_r2jd<-function(m){
  nd<-dim(m)
  jd_m<-.jnew("ec/tstoolkit/maths/matrices/Matrix", as.integer(nd[1]), as.integer(nd[2]))
  for (i in 1:nd[1]){
    for (j in 1:nd[2]){
      .jcall(jd_m, "V", "set", as.integer(i-1), as.integer(j-1), as.double(m[i,j]))
    }
  }
  jd_m
}


