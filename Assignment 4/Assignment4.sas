*Import Statement;
PROC IMPORT datafile="Bankingfull.txt" out=main_data replace; 
delimiter='09'x; 
getnames=YES; 
datarow=2;
run;

*Print the entire database;
proc print;
run;

*print scatterplots;
proc sgscatter;
title"Scatter matrix plot for banking file";
matrix Balance Age Education Income HomeVal Wealth;
run;

*Print correlation;
proc corr;
title"Correlation plot for banking file";
var Balance Age Education Income HomeVal Wealth;
run;

*Print Regression model.;
proc reg;
model Balance = Age Education Income HomeVal Wealth / vif tol;
run;

*Re run the model without the highest VIF value.;
proc reg;
title"New model without the Income Variable.";
model Balance = Age Education HomeVal Wealth / vif tol;
run;

* Residual model;
PROc reg CORR;
model Balance = Age Education HomeVal Wealth;
plot student.*( Age Education HomeVal Wealth);

plot student.*predicted.;

plot npp.*student.;
RUN;

PROC REG CORR;
MODEL Balance = Age Education Income HomeVal Wealth/stb influence r;
*Reduced model;
MODEL Balance =Age Education Income Wealth / stb influence r;
*Residual analysis;
plot residual.*(predicted. Age Education Income Wealth);
*Normal probability plot of residuals;
plot npp.* residual.;
RUN;

*Deleting observation # 38 from the dataset and naming it BankingFull;
DATA Banking;
set Bankingfull;
if _n_ = 38 then delete;
RUN;

*New model without 38th observation.;
PROC REG data=Banking;
title"New model without 38th observation";
*Reduced model;
MODEL Balance = Age Education Income Wealth  / stb influence r;
*Residual analysis;
plot residual.(predicted. Age Education Income Wealth);
*npp residual graph;
plot npp.*residual.;
RUN;



