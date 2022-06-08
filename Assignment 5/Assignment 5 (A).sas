
DATA BankingFull;
PROC IMPORT datafile="Bankingfull.txt" 
out=Bankingfull replace;
delimiter='09'x;
getnames=yes;
datarow=2;
run;
Title "Regression Model";
PROC REG;
model Balance = Age Education HomeVal Wealth / influence r;
plot student.*(Age Education HomeVal Wealth predicted.);
plot npp.*student.;
run;



TITLE " New Regression Model with requirements";
DATA NEW;
INPUT Age Education HomeVal Wealth;
DATALINES;
34 13 160000 140000;
proc print;
run;


title"Regression Model for Full Model";
PROC REG CORR;
MODEL Balance = Age Education Income HomeVal Wealth/stb influence r;

title "Reduced Mode";
MODEL Balance =Age Education Income Wealth / stb influence r;

title "Residual Analysis";
plot residual.*(predicted.Age Education Income Wealth
plot npp.*residual;

RUN;

