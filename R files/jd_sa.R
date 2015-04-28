sa_tramoseats<-function(s, method="RSAfull", details=NULL){
	jd_s<-ts_r2jd(s)
	spec<-.jcall("ec/satoolkit/tramoseats/TramoSeatsSpecification","Lec/satoolkit/tramoseats/TramoSeatsSpecification;", "fromString", method)
	if (! is.null(details)){
		dspec<-.jcall(spec, "Lec/tstoolkit/information/InformationSet;", "write", FALSE)
		.jcall(dspec, "Z", "update", details)
		spec<-.jnew("ec/satoolkit/tramoseats/TramoSeatsSpecification")
		.jcall(spec, "Z", "read",dspec)
	}
	.jcall(jd_tramoseats, "Lec/tstoolkit/algorithm/CompositeResults;", "process", jd_s, spec)
}

sa_x13<-function(s, method="RSA4c", details=NULL){
	jd_s<-ts_r2jd(s)
	spec<-.jcall("ec/satoolkit/x13/X13Specification","Lec/satoolkit/x13/X13Specification;", "fromString", method)
	if (! is.null(details)){
		dspec<-.jcall(spec, "Lec/tstoolkit/information/InformationSet;", "write", FALSE)
		.jcall(dspec, "Z", "update", details)
		spec<-.jnew("ec/satoolkit/x13/X13Specification")
		.jcall(spec, "Z", "read",dspec)
	}
	.jcall(jd_x13, "Lec/tstoolkit/algorithm/CompositeResults;", "process", jd_s, spec)
}

