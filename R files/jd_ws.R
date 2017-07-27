.jaddClassPath("./Java/jcruncher-2.1.0.jar")
.jaddClassPath("./Java/demetra-tss-2.1.0.jar")
.jaddClassPath("./Java/demetra-utils-2.1.0.jar")
.jaddClassPath("./Java/demetra-common-2.1.0.jar")
.jaddClassPath("./Java/guava-18.0.jar")
.jaddClassPath("./Java/slf4j-api-1.7.13.jar")
.jaddClassPath("./Java/slf4j-simple-1.7.13.jar")
.jaddClassPath("./Java/opencsv-2.3.jar")
.jaddClassPath("./Java/jsr305-3.0.1.jar")

source("./R files/jd_init.R")
source("./R files/jd_ts.R")
source("./R files/jd_rslts.R")

jd_ws<-function(file){
  jd_monitor<-.jnew("ec/demetra/jcruncher/Monitor")
  if (FALSE == .jcall(jd_monitor, "Z", "load", file))
    return(NULL)
  jd_monitor
}

jd_processingNames<-function(ws){
  .jcall(ws, "[S", "getProcessingNames")
}

jd_processing<-function(ws, name){
  .jcall(ws, "Lec/tss/sa/SaProcessing;", "getProcessing", name)
}

jd_items<-function(jdprocessing){
  if (is.jnull(jdprocessing))
    return(NULL)
  .jcall(jdprocessing, "[Lec/tss/sa/SaItem;", "toArray")
}

jd_processing_ts<-function(jdprocessing, item){
   all<-jd_items(jdprocessing)
   if (is.jnull((all)))
     return(NULL)
   rslt<-list()
   for (i in 1:length(all)){
     cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
     if (! is.jnull(cur))
        rslt[[i]]<-proc_ts(cur,item)
   }
  rslt
}

jd_processing_matrix<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-list()
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[[i]]<-proc_matrix(cur,item)
  }
  rslt
}

jd_processing_reg<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-list()
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[[i]]<-proc_reg(cur,item)
  }
  rslt
}

jd_processing_int<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[i]<-proc_int(cur,item)
  }
  rslt
}

jd_processing_numeric<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[i]<-proc_numeric(cur,item)
  }
  rslt
}

jd_processing_bool<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[i]<-proc_bool(cur,item)
  }
  rslt
}

jd_processing_test<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-list()
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[[i]]<-proc_test(cur,item)
  }
  rslt
}

jd_processing_testvalue<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur)){
      p<-proc_test(cur,item)
      if (! is.null(p))
        rslt[i]<-p[1]
      else
        rslt[i]<-NaN
    }else
      rslt[i]<-NaN
  }
  rslt
}

jd_processing_parametervalue<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur)){
      p<-proc_parameter(cur,item)
      if (! is.null(p))
        rslt[i]<-p[1]
      else
        rslt[i]<-NaN
    }else
      rslt[i]<-NaN
  }
  rslt
}

jd_processing_parameters<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-list()
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
    if (! is.jnull(cur))
      rslt[[i]]<-proc_parameters(cur,item)
  }
  rslt
}

jd_processing_series<-function(jdprocessing){
  all<-jd_items(jdprocessing)
  if (is.jnull((all)))
    return(NULL)
  rslt<-vector(length=length(all))
  for (i in 1:length(all)){
    cur<-.jcall(all[[i]], "Lec/tss/Ts;", "getTs")
    if (! is.jnull(cur))
      rslt[i]<-.jcall(cur, "S", "getRawName")
  }
  rslt
}

jd_processing_item<-function(jdprocessing, item){
  all<-jd_items(jdprocessing)
  if (is.jnull((all))|| is.null(all[[item]]))
    return(NULL)
  .jcall(all[[item]], "Lec/tstoolkit/algorithm/CompositeResults;", "process")
}

