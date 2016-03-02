spec_create<-function(){
.jnew("ec/tstoolkit/information/InformationSet")
}

spec_int<-function(spec, name, obj){
names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
j_int<-.jnew("java/lang/Integer", as.integer(obj))
.jcall(spec, "Z", "set", names, .jcast(j_int, "java/lang/Object"))
}

spec_bool<-function(spec, name, obj){
	names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
	j_bool<-.jnew("java/lang/Boolean", as.logical(obj))
	.jcall(spec, "Z", "set", names, .jcast(j_bool, "java/lang/Object"))
}

spec_numeric<-function(spec, name, obj){
	names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
	j_num<-.jnew("java/lang/Double", as.double(obj))
	.jcall(spec, "Z", "set", names, .jcast(j_num, "java/lang/Object"))
}

spec_numerics<-function(spec, name, obj){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  .jcall(spec, "Z", "set", names, .jarray(obj))
}

spec_numerics<-function(spec, name, obj){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  j_nums<-.jarray(obj)
  .jcall(spec, "Z", "set", names, .jcast(j_nums, "java/lang/Object"))
}

spec_initialparams<-function(spec, name, data){
	names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
	j_params<-jd_params(data, jd_pinitial)
	.jcall(spec, "Z", "set", names, .jcast(j_params, "java/lang/Object"))
}

spec_nparams<-function(spec, name, data){
	names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
      j_params<-jd_params(array(0, as.integer(data)), jd_pundefined)
	.jcall(spec, "Z", "set", names, .jcast(j_params, "java/lang/Object"))
}

spec_str<-function(spec, name, str){
	names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
	jstr=.jnew("java/lang/String", as.character(str))      
      .jcall(spec, "Z", "set", names, .jcast(jstr, "java/lang/Object"))
}

spec_strs<-function(spec, name, str){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  jstr=.jarray(str)      
  .jcall(spec, "Z", "set", names, .jcast(jstr, "java/lang/Object"))
}

