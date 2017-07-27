source("./R files/jd_init.R")
source("./R files/jd_ts.R")
source("./R files/jd_calendars.R")
source("./R files/jd_regression.R")
source("./R files/jd_sa.R")
source("./R files/jd_rslts.R")
source("./R files/jd_spec.R")
source("./R files/jd_cholette.R")

# usual R time series
data<-read.table("../Data/xm.txt")
s<-ts(data[,1], start=c(1995,1), frequency=12)

# results will be retrieved from the output of the sa routines
# through the proc_xxx functions

# executes TramoSeats (RSA4 by default)
tramoseats_rslts=sa_tramoseats(s)
# executes X11/X13 (pre-defined specifications)
x11_rslts<-sa_x13(s, "X11")
x13_rslts<-sa_x13(s, "RSA5c")

# advanced processing
# create a spec file that will modify an existing specification
spec<-spec_create()
spec_bool(spec, "tramo.automdl.enabled", FALSE)
spec_fixedparams(spec, "tramo.arima.btheta", -.8)
spec_nparams(spec, "tramo.arima.phi", 2)
spec_bool(spec, "tramo.regression.calendar.td.auto", TRUE)
# execute TramoSeats on the series s, using the "RSA4" specification modified by the given spec details (see above)
tramoseats_rslts2=sa_tramoseats(s,"RSA4",spec)

# retrieve the seasonally adjusted series
sa0<-proc_ts(x13_rslts, "sa")
sa1<-proc_ts(tramoseats_rslts, "sa")
#trend
t0<-proc_ts(x13_rslts, "t")
t1<-proc_ts(tramoseats_rslts, "t")
#d7 table
d7<-proc_ts(x13_rslts, "decomposition.d-tables.d7")
#series corrected for calendar effects
ycal0<-proc_ts(x13_rslts, "ycal")
ycal1<-proc_ts(tramoseats_rslts, "ycal")

# Usual R commands
ts.union(s,ycal0,sa0,t0)
ts.union(s,ycal1,sa1,t1)
ts.plot(s,sa0, t0, col=c("black", "blue", "red"))

#RegArima model
# regression variables
proc_desc(x13_rslts, "regression.description")

#regression coefficients. Value/standard deviation. See description for their meaning
proc_parameters(x13_rslts, "regression.coefficients")

#test Value/PValue
proc_test(x13_rslts, "residuals.lb")
proc_test(x13_rslts, "residuals.skewness")

#BIC
proc_numeric(tramoseats_rslts, "likelihood.bicc")
proc_numeric(tramoseats_rslts2, "likelihood.bicc")


#arima models
proc_str(x13_rslts, "arima")
proc_str(tramoseats_rslts, "arima")
proc_str(tramoseats_rslts2, "arima")

sy<-ts_aggregate(s, 1)
sy

sa0c<-jd_cholette(sa0, sy, 1, 1)
sa0cc<-jd_cholette(sa0, sy, 1, 0)
sa0ccc<-jd_denton(sa0, sy)
sa0cccc<-jd_denton(sa0, sy, mul = FALSE, d=2)
ts.union(sa0, sa0c, sa0cc, sa0ccc, sa0cccc)
