/*Loading All Data*/
FILENAME REFFILE 'All Locations Data.csv';

PROC IMPORT DATAFILE=REFFILE REPLACE
	DBMS=CSV
	OUT=df;
	GETNAMES=YES;
RUN;

DATA DIS_Pres;
	SET df;
	IF (DIS=0) THEN DELETE;
RUN;

DATA DIS_Abs;
	SET df;
	IF (DIS=1) THEN DELETE;
RUN;

/* Disease Present Locations */
	/* Seeding Rates */
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit9=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit12=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit15=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	/* Fungicides */
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit9=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit12=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit15=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 

	/* Predicted Return Sclerotinia Sclerotiorum Inoculum */
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model PredSclerkg=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Pres plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model PredSclerkg=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 

/* Disease Absent Locations */
	/* Seeding Rates */
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit9=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit12=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit15=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans pop/ilink pdiff;
	%mult(trt=pop, alpha=0.05);
	run; 
	/* Fungicides */
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit9=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit12=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 
	Proc glimmix data=Dis_Abs plots=studentpanel;
	ods output lsmeans=lsmeans diffs=diffs;
	class Env rep pop fung;
	model Profit15=pop|fung/dist=n ddfm=kr2;
	random int /subject=rep group=env;
	lsmeans fung/ilink pdiff;
	%mult(trt=fung, alpha=0.05);
	run; 
