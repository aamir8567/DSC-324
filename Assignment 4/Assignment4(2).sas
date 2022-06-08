*import data from file;
proc import datafile="pgatour2006.csv"  out=PGATour replace;
delimiter=',';
getnames=yes;
run;

title "main Dataset";
proc print ;
run;

title "Scatterplots";
proc sgscatter ;
Matrix PrizeMoney DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
RUN;

title "Pearson Correlation";
proc corr ;
var PrizeMoney DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
RUN;

*Histogram;
title "Histogram";
PROC UNIVARIATE normal ;
var PrizeMoney;
histogram / normal (mu=est sigma=est);
INSET min max mean Q1 Q2 Q3 Range stddev/ header = 'overall'
pos=tm;
run;

*Log transformation;
data PGATour;
SET PGATour;
ln_prize=log(PrizeMoney);
run;

*printing entire dataset to make sure log worked;
title"Dataset After Log Transformation";
proc print;
run;

*Histogram after the log transformation;
title "Histogram after log transformation";
PROC UNIVARIATE normal data=PGATour;
var ln_prize;
histogram / normal (mu=est sigma=est);
INSET min max mean Q1 Q2 Q3 Range stddev/ header = 'overall'
pos=tm;
run;

*Regression Model after Log Transformation;
title"Regression Model after Log Transformation";
proc reg data=PGATour;
model ln_prize = DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
run;

title"Model 2 for regressional analysis";
proc reg data=PGATour;
model ln_prize = GIR PuttingAverage BirdieConversion PuttsPerRound;
run;

title"Model 3 for regressional analysis";
proc reg data=PGATour;
model ln_prize = GIR BirdieConversion PuttsPerRound;
plot student.*(predicted. GIR BirdieConversion PuttsPerRound);
plot npp.*student.;
run;

title"Analyzing for outliers and Influential points";
proc reg;
Model ln_prize = GIR BirdieConversion PuttsPerRound / influence r;
run;

title"Removing obeservation 185";
data PGATourNew;
set PGATour;
if _n_ = 185 then delete;
run;

title"New dataset after removing observation 185";
proc reg data=PGATourNew;
Model ln_prize = GIR BirdieConversion PuttsPerRound / influence r;
run;

title"Removing obeservation 40";
data PGATourNew2;
set PGATourNew;
if _n_ = 40 then delete;
run;

title"New dataset after removing observation 40";
proc reg data=PGATourNew2;
Model ln_prize = GIR BirdieConversion PuttsPerRound / influence r;
run;
