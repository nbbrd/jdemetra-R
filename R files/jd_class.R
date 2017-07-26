source("./R files/jd_init.R")
source("./R files/jd_ts.R")
source("./R files/jd_sa.R")
source("./R files/jd_rslts.R")
source("./R files/jd_spec.R")

#initialize SA classes (S4)

setClass("JD_Output", contains = "jobjRef")
setClass("JD_SA", contains = "JD_Output")
setClass("JD_TramoSeats", contains = "JD_SA")
setClass("JD_X13", contains = "JD_SA")
setClass("JD_RegArima", contains = "jobjRef")

x13Process<-function(ts=s, method="RSA4c", details=NULL){
  jrslt<-sa_x13(s,method, details)
  rslt<-new(Class = "JD_X13", jobj=jrslt@jobj, jclass=jrslt@jclass)
  return(rslt)
}

tramoseatsProcess<-function(ts=s, method="RSAfull", details=NULL){
  jrslt<-sa_tramoseats(s,method, details)
  rslt<-new(Class = "JD_TramoSeats", jobj=jrslt@jobj, jclass=jrslt@jclass)
  return(rslt)
}

setGeneric(name = "getTs", def = function(object, name, ...){standardGeneric("getTs")})
setGeneric(name = "getRegArima", def = function(object){standardGeneric("getRegArima")})
setMethod(f="getTs", signature = c(object="JD_Output", name="character"), definition = function(object, name, ...){proc_ts(object, name)})
setMethod(f="print", signature="JD_SA",definition=function(x)
{
  y<-getTs(x,"y")
  sa<-getTs(x,"sa")
  t<-getTs(x, "t")
  s<-getTs(x,"s")
  i<-getTs(x,"i")
  print(ts.union(y, sa, t, s, i))
})

setMethod(f="print", signature="JD_X13",definition=function(x)
  {
  cat("X13 (JD+)\n")
  print(as(x, "JD_SA"))
})

setMethod(f="print", signature="JD_TramoSeats",definition=function(x)
{
  cat("Tramo-Seats (JD+)\n")
  return(print(as(x, "JD_SA")))
})

setMethod(f="show", signature="JD_X13",definition=function(object)
{
  return(print("X13 (JD+)"))
})

setMethod(f="show", signature="JD_TramoSeats",definition=function(object)
{
  return( print("Tramo-Seats (JD+)"))
})

setMethod(f="getRegArima", signature="JD_TramoSeats",definition=function(object)
{
  return(new(Class = "JD_RegArima", jobj=object@jobj, jclass=object@jclass) )
})

setMethod(f="getRegArima", signature="JD_X13",definition=function(object)
{
  return(new(Class = "JD_RegArima", jobj=object@jobj, jclass=object@jclass) )
})

setMethod(f="plot", signature=c(x="JD_SA"), definition=function(x)
  {
  s<-getTs(x,"y")
  sa<-getTs(x,"sa")
  t<-getTs(x, "t")
  ts.plot(s,sa, t, col=c("black", "blue", "red"), main=show(x))
})

setMethod(f="Summary", signature="JD_RegArima", definition=function(x)
{
  cat("RegArima model\n")
  print(proc_desc(x, "regression.description"))
  print(proc_parameters(x, "regression.coefficients"))
})