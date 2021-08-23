FILENAME REFFILE 'All Locations Data.csv';

PROC IMPORT DATAFILE=REFFILE REPLACE
	DBMS=CSV
	OUT=df;
	GETNAMES=YES;
RUN;

/* Subsetting for Partially Integrated Trials */
DATA part;
	SET df;
	IF (Group=:'Fully') THEN DELETE;
RUN;

/* DIX */
Proc glimmix data=part plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model DIX=pop|fung/dist=lognormal ddfm=kr2;
random int /sub=rep group=env;
lsmeans pop/ilink pdiff;
%mult(trt=pop, alpha=0.05);
run; 
Proc glimmix data=part plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model DIX=pop|fung/dist=lognormal ddfm=kr2;
random int /sub=rep group=env;
lsmeans fung/ilink pdiff;
%mult(trt=fung, alpha=0.1);
run; 

/* Yield */
Proc glimmix data=part plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model ykg=pop|fung/dist=normal ddfm=kr2;
random int/sub=rep group=env;
lsmeans pop/ilink pdiff;
%mult(trt=pop, alpha=0.05);
run;
Proc glimmix data=part plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model ykg=pop|fung/dist=normal ddfm=kr2;
random int /sub=rep group=env;
lsmeans fung/ilink pdiff;
%mult(trt=fung, alpha=0.05);
run;