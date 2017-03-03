# My WorkingDirectory
setwd("C:\\Daten\\R\\jdemetra-R-master\\R files")

source("./jd_init.R")
source("./jd_ts.R")
source("./jd_sa.R")
source("./jd_rslts.R")
source("./jd_spec.R")

# usual R time series
data<-read.table("../Data/xm.txt")
s<-ts(data[,2], start=c(1995,1), frequency=12)
tramoseats_rslts=sa_tramoseats(s)

#SeasonalityTests
#########################

# already implemented in source code 
proc_bool(tramoseats_rslts, "decomposition.seasonality")

# Tests for functionality
proc_int(tramoseats_rslts, "seasonality.int")         # expected: 17
proc_bool(tramoseats_rslts, "seasonality.bool")       # expected: true
proc_numeric(tramoseats_rslts, "seasonality.double")  # expected: 17.1

# Data
proc_ts(tramoseats_rslts, "seasonality.data")

# 1. QS
proc_numeric(tramoseats_rslts, "seasonality.qs.value")
proc_numeric(tramoseats_rslts, "seasonality.qs.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.qs.value")
proc_numeric(tramoseats_rslts, "seasonality.log.qs.pvalue")

# 2. Friedman
proc_numeric(tramoseats_rslts, "seasonality.friedman.value")
proc_numeric(tramoseats_rslts, "seasonality.friedman.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.friedman.value")
proc_numeric(tramoseats_rslts, "seasonality.log.friedman.pvalue")

# 3. KW
proc_numeric(tramoseats_rslts, "seasonality.kw.value")
proc_numeric(tramoseats_rslts, "seasonality.kw.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.kw.value")
proc_numeric(tramoseats_rslts, "seasonality.log.kw.pvalue")

# 4. SeasonalPeaks
proc_str(tramoseats_rslts, "seasonality.peaks")
proc_str(tramoseats_rslts, "seasonality.log.peaks")

# 5. periodogram
proc_numeric(tramoseats_rslts, "seasonality.periodogram.value")
proc_numeric(tramoseats_rslts, "seasonality.periodogram.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.periodogram.value")
proc_numeric(tramoseats_rslts, "seasonality.log.periodogram.pvalue")

# 6. Dummies
proc_numeric(tramoseats_rslts, "seasonality.dummies.value")
proc_numeric(tramoseats_rslts, "seasonality.dummies.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.dummies.value")
proc_numeric(tramoseats_rslts, "seasonality.log.dummies.pvalue")

# 7. Stable
proc_numeric(tramoseats_rslts, "seasonality.stable.value")
proc_numeric(tramoseats_rslts, "seasonality.stable.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.stable.value")
proc_numeric(tramoseats_rslts, "seasonality.log.stable.pvalue")

# 8. Evolutive
proc_numeric(tramoseats_rslts, "seasonality.evolutive.value")
proc_numeric(tramoseats_rslts, "seasonality.evolutive.pvalue")

proc_numeric(tramoseats_rslts, "seasonality.log.evolutive.value")
proc_numeric(tramoseats_rslts, "seasonality.log.evolutive.pvalue")

