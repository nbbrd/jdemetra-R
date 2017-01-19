source("./jd_class.R")

# usual R time series
data<-read.table("../Data/xm.txt")
s<-ts(data[,1], start=c(1995,1), frequency=12)

rx13<-x13Process(s)
plot(rx13)
show(rx13)
getTs(rx13, "y_f")

rts<-tramoseatsProcess(s)
plot(rts)
show(rts)
getTs(rts, "y_f")

print(rts)
