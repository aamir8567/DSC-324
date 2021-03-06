*import data from file;
proc import datafile="churn_train.csv"  out=churn_main replace;
delimiter=',';
getnames=yes;
run;

*Printing entire Dataset;
title "Printing main Dataset";
proc print data=churn_main;
run;

*For Dummy Variables Gender;
title "Dummy Variables for GENDER";
DATA churn_main;
set churn_main;
if (GENDER = 'M') then D_GENDER = 1;
else D_GENDER = 0;
education = (education = 2);
education = (education = 3);
education = (education = 4);
education = (education = 5);
education = (education = 6);

run;

*Printing entire Dataset;
title "Printing Dummy Dataset";
proc print data=churn_main;
run;


*Printing Boxplot for AGE AND CHURN;
title "Boxplot for Age and Churn Value";
proc boxplot;
	plot AGE*CHURN;
run;

*Printing Boxplot for PCT_CHNG_BILL_AMT  and CHURN ;
title "Boxplot for PCT_CHNG_BILL_AMT  and Churn Value";
proc boxplot;
	plot PCT_CHNG_BILL_AMT *CHURN;
run;

*Full Logistic Model;
title "logistic Regression with the full model.";
proc logistic;
	model CHURN (event='1') = D_GENDER EDUCATION LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT COMPLAINT / rsquare;
run;

*Reduced Model;
title "Logistic Regression with Reduced Model.";
proc logistic;
	model CHURN (event='1') = TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT / rsquare;
run;

*Inserting data for Question D ;
title "Inserting data for Question D";
data new;
	input GENDER $ EDUCATION LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT CHURN COMPLAINT;
	datalines;
	M . 0 4 43 1.04 1.19 . 1 
	;
run;
PROC PRINT;
RUN;

*Setting up dummy variables;
data predict;
set new churn_main;
if (GENDER='M') then d_gender=1;
else d_gender=0;
education2=(education=2);
education3=(education=3);
education4=(education=4);
education5=(education=5);
education6=(education=6);
RUN;

title "Printing after doing dummy variables";
proc print;
run;

title "Proc Logistic for new model";
PROC LOGISTIC data=predict;
MODEL CHURN (event='1') = d_gender LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT COMPLAINT ;
output out=predict p=phat lower=lcl upper=ucl;
RUN;

title "Printed Data after predictions";
proc print data=predict;
run;
