source("./R files/jd_ts.R")
source("./R files/jd_regression.R")
jd_td<-function(formula, model="Ar1", conversion="Sum", zeroinit=FALSE, truncated.rho=0, fixed.rho=-1, to=4){
  # This function reuse part of the code of the function "td", from the package "tempdisagg" 
  # Christoph Sax, Peter Steiner (http://journal.r-project.org/archive/2013-2/sax-steiner.pdf)
  # However, the actual computation, which is made in JDemetra+ (Java routines called through rJava), uses a completely different 
  # solution (Kalman smoother)

  # extract X (right hand side, high frequency) formula, names and data
  X.formula <- formula; X.formula[[2]] <- NULL
  X.series.names <- all.vars(X.formula)
  
  # extract y_l (left hand side, low frequency) formula, values and names
  y_l.formula <- formula[[2]]
  y_l.series <- eval(y_l.formula, envir=environment(formula))
  y_l.name <- deparse(y_l.formula)
  
  # ---- set ts.mode ----------------------------------------------------------
  # 1. is y_l.series a time series? 
  if (!is.ts(y_l.series)){
    stop("y must be a time series")
  }
  # 2. is there a X? 
  if (length(X.series.names) > 0) {
      hasX=TRUE
      if (!is.ts(get(X.series.names[1], envir=environment(X.formula)))){
        stop("x must be a time series")
      }
  }else{
    hasX=FALSE
  }
  monitor<-.jnew("ec.benchmarking.simplets.TsDisaggregation2")
  jm<-.jcall("ec/benchmarking/simplets/TsDisaggregation2$Model", "Lec/benchmarking/simplets/TsDisaggregation2$Model;", "valueOf",model)
  jc<-.jcall("ec/tstoolkit/timeseries/TsAggregationType", "Lec/tstoolkit/timeseries/TsAggregationType;", "valueOf", conversion)
  .jcall(monitor, "V", "setConstant", as.logical(attr(terms(formula), "intercept")))
  .jcall(monitor, "V", "setPrecision", as.double(1e-9))
  .jcall(monitor, "V", "setModel", jm)
  .jcall(monitor, "V", "setType", jc)
  .jcall(monitor, "V", "setTruncatedRho", as.double(truncated.rho))
  .jcall(monitor, "V", "setZeroInitialization", as.logical(zeroinit))
  jd_y=ts_r2jd(y_l.series)
  if (fixed.rho != -1){
    jp<-.jnew("ec/tstoolkit/Parameter",as.double(truncated.rho), jd_pfixed)
    .jcall(monitor, "V", "setParameter", jp)
  }
  vars<-.jnew("ec.tstoolkit.timeseries.regression.TsVariableList");
  if (hasX){
      xvar<-jd_tsvar(get(X.series.names[1], envir=environment(X.formula)), X.series.names[1])
      .jcall(vars, "V", "add", .jcast(xvar, "ec/tstoolkit/timeseries/regression/ITsVariable"))
      .jcall(monitor, "Z", "process", jd_y, vars)
  }else{
    jd_freq<-.jcall("ec/tstoolkit/timeseries/simplets/TsFrequency", "Lec/tstoolkit/timeseries/simplets/TsFrequency;", "valueOf", as.integer(to))
    .jcall(monitor, "V", "setDefaultFrequency", jd_freq)
    .jcall(monitor, "Z", "process", jd_y, vars)
  }
  
  sm<-.jcall(monitor, "Lec/tstoolkit/timeseries/simplets/TsData;", "getDisaggregatedSeries")
  ts_jd2r(sm)
}
