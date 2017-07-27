source("./R files/jd_regression.R")

jd_BEG<-.jfield("ec/tstoolkit/timeseries/Day", "Lec/tstoolkit/timeseries/Day;", "BEG")
jd_END<-.jfield("ec/tstoolkit/timeseries/Day", "Lec/tstoolkit/timeseries/Day;", "END")

jd_calendar<-function(julianEaster=FALSE){
  .jnew("ec/tstoolkit/timeseries/calendars/NationalCalendar", as.logical(TRUE), as.logical(julianEaster))
}

jd_day<-function(day){
  .jnew("ec/tstoolkit/timeseries/Day", as.integer(day))
}

jd_validityperiod<-function(start, end){
  validity<-.jnew("ec/tstoolkit/timeseries/ValidityPeriod")
  if (! is.null(start)){
    .jcall(validity, "V", "setStart", jd_day(start))
  }else{
    .jcall(validity, "V", "setStart", jd_BEG)
  }
  if (! is.null(end)){
    .jcall(validity, "V", "setEnd", jd_day(end))
  }else{
    .jcall(validity, "V", "setEnd", jd_END)
  }
  return(validity)
}

jd_addFixedDay<-function(jdcal, month, day, start=NULL, end=NULL){
  jdmonth<-month_r2jd(month)
  fday<-.jnew("ec/tstoolkit/timeseries/calendars/FixedDay", as.integer(day-1), jdmonth)
  devent<-.jnew("ec/tstoolkit/timeseries/calendars/SpecialDayEvent", .jcast(fday, "ec/tstoolkit/timeseries/calendars/ISpecialDay"))
  if ( ! (is.null(start) && is.null(end))){
    .jcall(devent, "V", "setValidityPeriod", jd_validityperiod(start, end))
  }
  .jcall(jdcal, "Z", "add", devent)
}

jd_addEasterRelatedDay<-function(jdcal, offset, start=NULL, end=NULL, julianEaster=FALSE){
  
  fday<-.jnew("ec/tstoolkit/timeseries/calendars/EasterRelatedDay", as.integer(offset), as.logical(julianEaster))
  devent<-.jnew("ec/tstoolkit/timeseries/calendars/SpecialDayEvent", .jcast(fday, "ec/tstoolkit/timeseries/calendars/ISpecialDay"))
  if ( ! (is.null(start) && is.null(end))){
    .jcall(devent, "V", "setValidityPeriod", jd_validityperiod(start, end))
  }
  .jcall(jdcal, "Z", "add", .jcast(devent, "ec/tstoolkit/timeseries/calendars/SpecialDayEvent"))
}

jd_calendarData<-function(jcal, dom, type="td"){
  jdom=domain_r2jd(dom)
  if (.jinstanceof(jcal, "ec/tstoolkit/timeseries/calendars/NationalCalendarProvider"))
    cprovider=jcal
  else if (.jinstanceof(jcal, "ec/tstoolkit/timeseries/calendars/DefaultGregorianCalendarProvider"))
    cprovider=jcal
  else
    cprovider<-.jnew("ec/tstoolkit/timeseries/calendars/NationalCalendarProvider", jcal)
  if (type == "td")
    jd_type=jd_td
  else if (type == "wd")
    jd_type=jd_wd

  
  jd_var<-.jnew("ec/tstoolkit/timeseries/regression/GregorianCalendarVariables",.jcast(cprovider, "ec/tstoolkit/timeseries/calendars/IGregorianCalendarProvider"), jd_type)
  jd_m<-.jcall("ec/tstoolkit/timeseries/regression/RegressionUtilities", "Lec/tstoolkit/maths/matrices/Matrix;",
         "matrix", .jcast(jd_var, "ec/tstoolkit/timeseries/regression/ITsVariable"), jdom)
  data<-matrix_jd2r(jd_m)
  ts(data,start=dom[2:3], frequency=dom[1])
}

# ProcessingContext.getActiveContext().getGregorianCalendars().set("belgium", ncal);
jd_registercalendar<-function(name, jdcal){
  if (.jinstanceof(jdcal, "ec/tstoolkit/timeseries/calendars/NationalCalendarProvider"))
    cprovider=jdcal
  else
    cprovider<-.jnew("ec/tstoolkit/timeseries/calendars/NationalCalendarProvider", jdcal)
  jd_context<-.jcall("ec/tstoolkit/algorithm/ProcessingContext", "Lec/tstoolkit/algorithm/ProcessingContext;", "getActiveContext")
  jd_cmgr<-.jcall(jd_context, "Lec/tstoolkit/timeseries/calendars/GregorianCalendarManager;", "getGregorianCalendars")
  .jcall(jd_cmgr, "V", "set", name, .jcast(cprovider, "java/lang/Object"))
}

jd_unregistercalendar<-function(name){
  jd_context<-.jcall("ec/tstoolkit/algorithm/ProcessingContext", "Lec/tstoolkit/algorithm/ProcessingContext;", "getActiveContext")
  jd_cmgr<-.jcall(jd_context, "Lec/tstoolkit/timeseries/calendars/GregorianCalendarManager;", "getGregorianCalendars")
  .jcall(jd_cmgr, "Z", "remove", name)
}

jd_getcalendar<-function(name){
  jd_context<-.jcall("ec/tstoolkit/algorithm/ProcessingContext", "Lec/tstoolkit/algorithm/ProcessingContext;", "getActiveContext")
  jd_cmgr<-.jcall(jd_context, "Lec/tstoolkit/timeseries/calendars/GregorianCalendarManager;", "getGregorianCalendars")
  .jcall(jd_cmgr, "Ljava/lang/Object;", "get", name)
  
}
