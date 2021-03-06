* TEST CODE - to test the data upload to server process is working;

*Import Statement;
PROC IMPORT datafile="voting_1992.txt" out=voting replace; 
delimiter='09'x; 
getnames=YES; 
datarow=2;
RUN; 

*Print dataset voting;
TITLE 'Dataset of voting_1992.txt File';
PROC PRINT; 
RUN; 

* Print Histogram and 5Num Summary;
title "Histogram and 5Num Summary for pct_Voted and medianAge";
PROC univariate DATA=voting normal;
	var Pct_Voted MedianAge;
	histogram / normal (mu = est sigma = est);
RUN;

* Print Boxplot for Pct_voted and Gender;
title "Boxplot for pct_Voted and medianAge";
PROC boxplot data=voting;
	plot Pct_Voted*Gender;
RUN;

*Print Gender Frequency;
title "Frequency for Gender";
PROC FREQ data=voting;
	TABLE Gender;
RUN;

