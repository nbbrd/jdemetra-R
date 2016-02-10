source("./jd_regression.R")

jd_calendar<-function(julianEaster=FALSE){
  .jnew("ec/tstoolkit/timeseries/calendars/NationalCalendar", as.logical(TRUE), as.logical(julianEaster))
}

jd_addFixedDay<-function(jdcal, month, day){
  jdmonth<-month_r2jd(month)
  fday<-.jnew("ec/tstoolkit/timeseries/calendars/FixedDay", as.integer(day-1), jdmonth)
  .jcall(jdcal, "Z", "add", .jcast(fday, "ec/tstoolkit/timeseries/calendars/ISpecialDay"))
}

jd_addEasterRelatedDay<-function(jdcal, offset, julianEaster=FALSE){
  
  fday<-.jnew("ec/tstoolkit/timeseries/calendars/EasterRelatedDay", as.integer(offset), as.logical(julianEaster))
  .jcall(jdcal, "Z", "add", .jcast(fday, "ec/tstoolkit/timeseries/calendars/ISpecialDay"))
}

jd_calendarData<-function(jcal, jdom){
  if (.jinstanceof(jcal, "ec/tstoolkit/timeseries/calendars/NationalCalendarProvider"))
    cprovider=jcal
  else
    cprovider<-.jnew("ec/tstoolkit/timeseries/calendars/NationalCalendarProvider", jcal)
  jd_var<-.jnew("ec/tstoolkit/timeseries/regression/GregorianCalendarVariables",.jcast(cprovider, "ec/tstoolkit/timeseries/calendars/IGregorianCalendarProvider"), jd_td)
  jd_m<-.jcall("ec/tstoolkit/timeseries/regression/RegressionUtilities", "Lec/tstoolkit/maths/matrices/Matrix;",
         "matrix", .jcast(jd_var, "ec/tstoolkit/timeseries/regression/ITsVariable"), jdom)
  matrix_jd2r(jd_m)
}

jd_calendarData2<-function(jcal, jdom){
  jd_var<-.jnew("ec/tstoolkit/timeseries/regression/GregorianCalendarVariables",.jcast(jcal, "ec/tstoolkit/timeseries/calendars/IGregorianCalendarProvider"), jd_td)
  jd_m<-.jcall("ec/tstoolkit/timeseries/regression/RegressionUtilities", "Lec/tstoolkit/maths/matrices/Matrix;",
               "matrix", .jcast(jd_var, "ec/tstoolkit/timeseries/regression/ITsVariable"), jdom)
  matrix_jd2r(jd_m)
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
