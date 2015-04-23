library("rJava")
.jinit()
.jaddClassPath("../java/demetra-tstoolkit-2.0.0.jar")
jd_month<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Monthly")
jd_quarter<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Quarterly")
jd_year<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Yearly")
jd_undef<-.jfield("ec/tstoolkit/timeseries/simplets/TsFrequency","Lec/tstoolkit/timeseries/simplets/TsFrequency;","Undefined")

jd_tramoseats<-.jnew("ec/satoolkit/algorithm/implementation/TramoSeatsProcessingFactory")
jd_x13<-.jnew("ec/satoolkit/algorithm/implementation/X13ProcessingFactory")
jd_stm<-.jnew("ec/satoolkit/algorithm/implementation/StmProcessingFactory")

jd_clobj<-.jcall("java/lang/Class", "Ljava/lang/Class;", "forName", "java.lang.Object")

jd_pfixed<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Fixed")
jd_pinitial<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Initial")
jd_pestimated<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Estimated")
jd_pundefined<-.jfield("ec/tstoolkit/ParameterType","Lec/tstoolkit/ParameterType;","Undefined")

jd_params<-function(data, type){
	x<-list()
	len<-length(data)
      for (i in 1:len){
            z<-as.double(data[i])
		x[[i]]<-.jnew("ec/tstoolkit/Parameter",z, type)
	}
	.jarray(x)
}
