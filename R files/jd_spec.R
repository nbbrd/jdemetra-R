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

spec_jobj<-function(spec, name, jobj){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  .jcall(spec, "Z", "set", names, jobj)
}

spec_numerics<-function(spec, name, obj){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  .jcall(spec, "Z", "set", names, .jarray(obj))
}

spec_initialparams<-function(spec, name, data){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  j_params<-jd_params(data, jd_pinitial)
  .jcall(spec, "Z", "set", names, j_params)
}

spec_fixedparams<-function(spec, name, data){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  j_params<-jd_params(data, jd_pfixed)
  .jcall(spec, "Z", "set", names, j_params)
}

spec_nparams<-function(spec, name, data){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  j_params<-jd_params(array(0, dim=data), jd_pundefined)
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

spec_update<-function(spec, details){
  jdic<-.jcall(details, "Ljava/util/List;", "getDictionary")
  size<-as.numeric(.jcall(jdic, "I", "size"))
  if (size>0){
    for (i in 1:size){
      jitem<-.jcall(jdic, "Ljava/lang/Object;", "get", as.integer(i-1))
      item<-.jsimplify(jitem)
      jobj<-.jcall(details, "Ljava/lang/Object;", "search", item, jd_clobj)
      spec_jobj(spec, item, jobj)
    }
  }
  
}

spec_span<-function(spec, name, type="all", date0=NULL, date1=NULL, n0=0, n1=0){
  names<-.jcall("ec/tstoolkit/information/InformationSet", "[S", "split", name)
  jspan<-.jnew("ec/tstoolkit/timeseries/TsPeriodSelector")
  if (type == "last"){
    .jcall(jspan, "V", "last", as.integer(n1))
  }
  else if (type == "first"){
    .jcall(jspan, "V", "first", as.integer(n0))
  }else if (type == "from"){
    jday<-.jcall("ec.tstoolkit.timeseries.Day", "Lec/tstoolkit/timeseries/Day;", "fromString", date0)
    .jcall(jspan, "V", "from", jday)
  }else if (type == "to"){
    jday<-.jcall("ec.tstoolkit.timeseries.Day", "Lec/tstoolkit/timeseries/Day;", "fromString", date1)
    .jcall(jspan, "V", "to", jday)
  }else if (type == "between"){
    jday0<-.jcall("ec.tstoolkit.timeseries.Day", "Lec/tstoolkit/timeseries/Day;", "fromString", date0)
    jday1<-.jcall("ec.tstoolkit.timeseries.Day", "Lec/tstoolkit/timeseries/Day;", "fromString", date1)
    .jcall(jspan, "V", "between", jday0, jday1)
  }else if (type == "excluding"){
    .jcall(jspan, "V", "excluding", as.integer(n0), as.integer(n1))
  }
  .jcall(spec, "Z", "set", names, .jcast(jspan, "java/lang/Object"))
}

