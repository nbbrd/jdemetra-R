source("./R files/jd_init.R")
source("./R files/jd_ts.R")
source("./R files/jd_calendars.R")
source("./R files/jd_regression.R")
source("./R files/jd_sa.R")
source("./R files/jd_sa_advanced.R")
source("./R files/jd_rslts.R")
source("./R files/jd_spec.R")
source("./R files/jd_cholette.R")

# usual R time series
data<-read.table("../Data/xm.txt")
s<-ts(data[,1], start=c(1995,1), frequency=12)

# get the default calendar to create (long enough) user-defined regression variables
jdc_def<-jd_getcalendar("Default")
deftd<-jd_calendarData(jdc_def, c(12, 1960, 1, 900))

# register the regression variables. any R timeseries could be used
jd_registerVariable(deftd[,1], "td1", "mytd")
jd_registerVariable(deftd[,2], "td2", "mytd")
jd_registerVariable(deftd[,3], "td3", "mytd")
jd_registerVariable(deftd[,4], "td4", "mytd")
# default group is "vars". See below
jd_registerVariable(deftd[,5], "td5")
jd_registerVariable(deftd[,6], "td6")

#test
#jd_regressionData("mytd.td1", c(12, 2000, 1, 24))

#creation of a specification that uses user-defined variables
spec<-spec_create()
spec_str(spec, "tramo.regression.calendar.td.mauto","Unused")
spec_strs(spec,"tramo.regression.calendar.td.user" ,c("mytd.td1", "mytd.td2", "mytd.td3", "mytd.td4"))

#user-defined variables. They are not considered as calendar effects.
spec_str(spec,"tramo.regression.user1.name" ,"vars.td5")

# effect can be: "Undefined", "Series", "Trend", "Seasonal", "Irregular", "SeasonallyAdjusted"
# see the documentation of JD+ for further information
spec_str(spec,"tramo.regression.user1.effect" ,"Seasonal")
spec_str(spec,"tramo.regression.user2.name" ,"vars.td6")
# firstlag, lastlag are 0 by default
spec_int(spec,"tramo.regression.user2.lastlag" ,5)
spec_str(spec,"tramo.regression.user2.effect" ,"Seasonal")

rh<-sa_tramoseats(s, "RSAfull", spec)
proc_desc(rh, "regression.description")
proc_parameters(rh, "regression.coefficients")

# more or less the same for X13. mauto should not be used. "calendar.td" replaced by "tradingdays"
#creation of a specification that uses user-defined variables
xspec<-spec_create()
spec_strs(xspec,"regarima.regression.tradingdays.user" ,c("mytd.td1", "mytd.td2", "mytd.td3", "mytd.td4"))

#user-defined variables. They are not considered as calendar effects.
spec_str(xspec,"regarima.regression.user1.name" ,"vars.td5")

# effect can be: "Undefined", "Series", "Trend", "Seasonal", "Irregular", "SeasonallyAdjusted"
# see the documentation of JD+ for further information
spec_str(xspec,"regarima.regression.user1.effect" ,"Seasonal")
spec_str(xspec,"regarima.regression.user2.name" ,"vars.td6")
# firstlag, lastlag are 0 by default
spec_int(xspec,"regarima.regression.user2.lastlag" ,5)
spec_str(xspec,"regarima.regression.user2.effect" ,"Seasonal")

xrh<-sa_x13(s, "RSA5c", xspec)
proc_desc(xrh, "regression.description")
proc_parameters(xrh, "regression.coefficients")
