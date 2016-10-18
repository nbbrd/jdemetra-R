proc_numeric<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (!is.jnull(s))
    .jcall(s, "D", "doubleValue")
  else
     return (NaN)
}

proc_vector<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  
  if (is.jnull(s))
    return(NULL)
  .jevalArray(s)
}

proc_int<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(-1)
  .jcall(s, "I", "intValue")
}

proc_bool<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(FALSE)
  .jcall(s, "Z", "booleanValue")
}

proc_ts<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return (NULL)
  ts_jd2r(s)
}

proc_period<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  period_jd2r(s)
}

proc_str<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  .jcall(s, "S", "toString")
}

proc_desc<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  .jevalArray(s)
}

proc_test<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  desc<-.jfield(s, "S", "description")
  val<-.jfield(s, "D", "value")
  pval<-.jfield(s, "D", "pvalue")
  all<-c(val, pval)
  attr(all, "description")<-desc
  all
}

proc_parameter<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  val<-.jcall(s, "D", "getValue")
  e<-.jcall(s, "D", "getStde")
  c(val, e)
}

proc_parameters<-function(rslt, name){
  jd_p<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(jd_p))
    return(NULL)
  p<-.jcastToArray(jd_p)
  len<-length(p)
  all<-array(0, dim=c(len,2))
  for (i in 1:len){
    all[i, 1]<-.jcall(p[[i]], "D", "getValue")
    all[i, 2]<-.jcall(p[[i]], "D", "getStde")
  }
  all
}

proc_reg<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  desc<-.jfield(s, "S", "description")
  val<-.jfield(s, "D", "coefficient")
  e<-.jfield(s, "D", "stdError")
  all<-c(val, e)
  attr(all, "description")<-desc
  all
}

proc_matrix<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  nr<-.jcall(s, "I", "getRowsCount")
  nc<-.jcall(s, "I", "getColumnsCount")
  m<-array(0, c(nr, nc))
  for (r in 1:nr){
    for (c in 1:nc){
      m[r,c]<-.jcall(s, "D", "get", as.integer(r-1), as.integer(c-1))
    }
  }
  m
}
