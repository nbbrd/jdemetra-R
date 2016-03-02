source("./jd_init.R")
source("./jd_ts.R")
source("./jd_regression.R")
source("./jd_calendars.R")
source("./jd_sa.R")

#calendar
jdc<-jd_calendar()
# 1 May
jd_addFixedDay(jdc, 5, 1)
# 21 July
jd_addFixedDay(jdc, 7, 21)
#Ascension
jd_addEasterRelatedDay(jdc, 39)
#White Monday
jd_addEasterRelatedDay(jdc, 50)

#register the calendar
jd_unregistercalendar("mycalendar")
jd_registercalendar("mycalendar", jdc)

jd_calendarData(jdc, c(12,1980,1, 28*12))

jdc2<-jd_getcalendar("mycalendar")
jd_calendarData(jdc2, c(4,1980,1, 28*4), "wd")

# usual R time series
data<-read.table("../Data/xm.txt")
s<-ts(data[,1], start=c(1995,1), frequency=12)

r<-sa_tramoseats(s, "RSAfull")
proc_ts(r, "sa")

spec<-spec_create()
spec_str(spec,"tramo.regression.calendar.td.holidays" ,"mycalendar")
spec_str(spec,"tramo.regression.calendar.td.holidays" ,"mycalendar")
rh<-sa_tramoseats(s, "RSAfull", spec)
proc_ts(rh, "sa")

ts.plot(proc_ts(r, "tde"), proc_ts(rh, "tde"), col=c("black", "red"))
