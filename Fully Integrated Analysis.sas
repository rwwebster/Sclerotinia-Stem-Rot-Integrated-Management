FILENAME REFFILE 'All Locations Data.csv';

PROC IMPORT DATAFILE=REFFILE REPLACE
	DBMS=CSV
	OUT=df;
	GETNAMES=YES;
RUN;

/*Subsetting for Fully Integrated Trials*/
DATA full;
	SET df;
	IF (Group=:'Partially') THEN DELETE;
RUN;

Proc glimmix data=full plots=studentpanel;
class Env rep row pop fung;
model DIX=row|pop|fung/dist=lognormal ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans fung/ilink lines adjust=tukey ADJDFE=ROW;
output out=gmxout pred=pred;
covtest homogeneity;
run; 

data gmxout1;set gmxout;
pred1=exp(pred);
resid=abs(pred1-DIX);
pct_dev=(resid*100)/DIX;
run;
proc sort data=gmxout1 out=sorted;
by descending pct_dev;
run;
proc print data=sorted (obs=100);
run;
data sorted1;set sorted;
if pct_dev gt 100 then delete;*you can change this number (% deviation) if you want to remove more or less datapoints;
run;

/* DIX */
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model DIX=row|pop|fung/dist=lognormal ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans row/ilink pdiff;
%mult(trt=row, alpha=0.05);
run; 
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model DIX=row|pop|fung/dist=lognormal ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans fung/ilink pdiff;
%mult(trt=fung, alpha=0.05);
run; 
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model DIX=row|pop|fung/dist=lognormal ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans row*fung/ilink pdiff;
%mult(trt=fung, by=row, alpha=0.05);
run; 

/* Yield */
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model Ykg=row|pop|fung/dist=n ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans row/ilink pdiff;
%mult(trt=row, alpha=0.05);
run; 
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model Ykg=row|pop|fung/dist=n ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans pop/ilink pdiff;
%mult(trt=pop, alpha=0.05);
run; 
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model Ykg=row|pop|fung/dist=n ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans fung/ilink pdiff;
%mult(trt=fung, alpha=0.05);
run;
Proc glimmix data=sorted1 plots=studentpanel;
ods output lsmeans=lsmeans diffs=diffs;
class Env rep row pop fung;
model Ykg=row|pop|fung/dist=n ddfm=kr2;
random int row pop(row)/subject=rep group=env;
lsmeans row*pop/ilink pdiff;
%mult(trt=pop, by=row, alpha=0.05);
run; 