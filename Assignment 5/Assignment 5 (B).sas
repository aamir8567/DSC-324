*Importing Dataset;
DATA college;
Infile "College.csv" firstobs = 2
delimiter = ',';
input school$ Private$ Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend GradRate;

*Setting Local Variables;
if(Private = 'Yes') then num_private = 1;
else num_private = 0;

RUN;

*Printing out the DATASET;
PROC PRINT data = college;
run;

*Printing Histogram;
title "Printing Histogram without any changes";
PROC UNIVARIATE normal ;
var GradRate;
histogram / normal (mu=est sigma=est);
INSET min max mean Q1 Q2 Q3 Range stddev/ header = 'overall'
pos=tm;
run;


*Removing Observaion 96 to get a better visual on Histogram.;
title "Removing Observaion 96 to get a better visual on Histogram.";
data college;
set college;
if _n_ = 96 then delete;
run;
PROC UNIVARIATE normal ;
var GradRate;
histogram / normal (mu=est sigma=est);
INSET min max mean Q1 Q2 Q3 Range stddev/ header = 'overall'
pos=tm;
run;

*Creating scatter plots;
proc sgscatter;
title"Scatterplots 1";
matrix GradRate Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books ;
run;
proc sgscatter;
title"Scatterplots 2";
matrix GradRate  Personal PhD Terminal SFRatio PercAlumni Expend num_private;
run;

*proc reg;
proc reg;
title"Regression model";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend num_private;
run;
*Correlation;
proc corr;
title "Correlation";
var GradRate  Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend num_private;
run;

*Box plots;
proc sgplot data= college;
title "Box plot";
vbox GradRate / category = num_private;
run;
*Box plots wioth elite;
proc sgplot data= college;
title "Box plot with Elite10";
vbox GradRate / category = Elite10;
run;

*For Multicollinearity;
proc reg;
title "Multicolinearity";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend num_private / vif tol;
run;

*For Adjusted R^2 Model selection;
proc reg;
title "For Adjusted R^2 Model selection";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend num_private / selection=adjrsq;
run;

*For CP Model selection;
proc reg;
title "For CP Model selection";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal SFRatio PercAlumni Expend num_private / selection=CP;
run;

*For Selected selection;
proc reg;
title "For Model 1";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal PercAlumni Expend num_private;
plot student.*predicted.;
plot npp.*residual.;
plot npp.*student.;
run;

*For Finding outliers;
proc reg;
title "Model 1 For finding outliers";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal PercAlumni Expend num_private / influence r;
run;

*Removing outliers and Influential points;
data college;
set college;
if _n_ in (70 ,64, 5, 47,  67, 98, 113, 126, 134, 142, 152, 169, 197, 201, 238, 215, 264, 284, 317, 319, 377, 394, 506, 640, 728) then delete;
run;

*For Finding outliers;
proc reg;
title "Model 2 For finding outliers";
model GradRate = Acceptpct Elite10 FUndergrad PUndergrad Outstate RoomBoard Books Personal PhD Terminal PercAlumni Expend num_private / stb;
run;
