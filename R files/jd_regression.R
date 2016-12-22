jd_tsvar<-function(s, name){
  .jnew("ec.tstoolkit.timeseries.regression.TsVariable", name, ts_r2jd(s))
}

jd_registerVariable<-function(s, name, group="vars"){
  var<-jd_tsvar(s, name)
  jd_context<-.jcall("ec/tstoolkit/algorithm/ProcessingContext", "Lec/tstoolkit/algorithm/ProcessingContext;", "getActiveContext")
  jd_vars<-.jcall(jd_context, "Lec/tstoolkit/timeseries/regression/TsVariables;", "getTsVariables", group)
  if (is.null(jd_vars)){
    jd_vars<-.jnew("ec/tstoolkit/timeseries/regression/TsVariables", "", .jcast(.jnull(), "ec.tstoolkit.utilities.INameValidator"))
    jd_tsmgr<-.jcall(jd_context, "Lec/tstoolkit/utilities/NameManager;", "getTsVariableManagers")
    .jcall(jd_tsmgr, "V",  "set", group, .jcast(jd_vars, "java/lang/Object"))
  }
  .jcall(jd_vars, "V", "set", name, .jcast(var, "java/lang/Object"))
  
}

jd_getvariable<-function(name){
  jd_context<-.jcall("ec/tstoolkit/algorithm/ProcessingContext", "Lec/tstoolkit/algorithm/ProcessingContext;", "getActiveContext")
  .jcall(jd_context, "Lec/tstoolkit/timeseries/regression/ITsVariable;", "getTsVariable", name)
}

jd_data<-function(jd_var, jd_dom){
  .jcall("ec/tstoolkit/timeseries/regression/RegressionUtilities", "Lec/tstoolkit/maths/matrices/Matrix;",
         "matrix", .jcast(jd_var, "ec/tstoolkit/timeseries/regression/ITsVariable"), jd_dom)
}

jd_regressionData<-function(regname, dom){
  jdom=domain_r2jd(dom)
  jd_var<-jd_getvariable(regname)
  jd_m<-jd_data(jd_var, jdom)
  data<-matrix_jd2r(jd_m)
  ts(data,start=dom[2:3], frequency=dom[1])
}

