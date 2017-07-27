source("./R files/jd_init.R")
source("./R files/jd_ts.R")
source("./R files/jd_rslts.R")
source("./R files/jd_ws.R")

# reads a workspace of JD+
ws<-jd_ws(file = "../Data/test.xml")

# gets the multi-processing names
jd_processingNames(ws)

# read a multi-processing
proc1<-jd_processing(ws,"SAProcessing-5")

# series names
names<-jd_processing_series(jdprocessing = proc1)
names
# displays some results
jd_processing_numeric(proc1, "likelihood.bicc")
jd_processing_test(proc1, "residuals.lb")
y<-jd_processing_ts(proc1, "y")
t<-jd_processing_ts(proc1, "t")
sa<-jd_processing_ts(proc1, "sa")
i<-1
ts.plot(y[[i]], t[[i]], sa[[i]], col=c("black", "red", "blue"))

# retrieves a specific item
i<-117
item<-jd_processing_item(proc1, i)
ts.plot(proc_ts(item, "s"), proc_ts(item, "i"),col=c("black", "red"))
title(main=names[i])

# use R facilities
plot(density(jd_processing_testvalue(proc1, "residuals.lb")))

