

create database banking_data_project1;
show databases;
use banking_data_project1;


					               -- BANKING DATA ANALYSIS-- 
                    
	-- PROJECT DESCRIPTION--
    
-- The Bank Client Attributes and Marketing Outcomes dataset offers a comprehensive insight into the attributes of bank clients and the outcomes of marketing campaigns. 
-- It includes details such as client demographics, employment status, financial history, and contact methods.
-- Additionally, the dataset encompasses the results of marketing campaigns, including the duration, success rates, and previous interactions with clients. 
-- This dataset serves as a valuable resource for analyzing customer behavior, optimizing marketing strategies, and enhancing client engagement in the banking sector.
                    
	-- PROJECT OBJECTIVE --
    
-- Improve loan approval strategies
-- Target marketing to high-value clients and reducing the fraud losses
-- Data Cleaning: Handling nulls, duplicates
-- Window Functions: Ranking, running totals, time-based analysis
-- Aggregations: Summarizing inflows/outflows, loan performance

select*from bankingData;

drop table bankingdata;

-- 1) short out the null valued customer details in bankingdata

select * FROM bankingData WHERE CustomerID=" "; 
select * FROM bankingData WHERE Name=''; 
select * FROM bankingData WHERE  Age='';  
select * FROM bankingData WHERE  Gender=''; 
select * FROM bankingData WHERE  Address='';
select * FROM bankingData WHERE  PhoneNumber=''; 
select * FROM bankingData WHERE  Email='';    --
select * FROM bankingData WHERE  AccountType='';    --
select * FROM bankingData WHERE  Balance='';
select * FROM bankingData WHERE  OpenDate='';    --
select * FROM bankingData WHERE  Status='';      --
select * FROM bankingData WHERE  LoanID='';	
select * FROM bankingData WHERE  LoanType='';     --
select * FROM bankingData WHERE  loanAmount='';
select * FROM bankingData WHERE  LoanStartDate='';     --
select * FROM bankingData WHERE  loanEndDate='';       --
select * FROM bankingData WHERE  interestRate='';
select * FROM bankingData WHERE  LoanStatus='';

-- 2) set the values to null valued column in bankingdata

set sql_safe_updates=0;

UPDATE bankingdata SET Email='no comment' where email is  null; 

UPDATE bankingdata SET AccountType=ifnull(AccountType,'no comment'); 

UPDATE bankingdata SET OpenDate=ifnull(OpenDate,'no_comment');  

UPDATE bankingdata SET Status=ifnull(Status,'no comment');  

UPDATE bankingdata SET LoanType=ifnull(LoanType,'no comment');  

UPDATE bankingdata SET Status='no comment' where status is null; 
  
UPDATE bankingdata SET LoanStartDate=ifnull(LoanStartDate,'no comment');  

UPDATE bankingdata SET loanEndDate=ifnull(loanEndDate,'no comment');  


-- 3) find all accounts in 16th jan 2024

    select * from bankingdata where opendate>"2020-01-16";


-- 4) find loans with interest rate above 10.00

select customerid,name,loanid,interestrate 
from bankingdata
 where interestrate>10.00;
    
    
-- 5) find all active accounts and all inactive accounts

select*from bankingdata 
where status='active';

select*from bankingdata 
where status='inactive';


-- 6) print the first 5 characters of name from bankingdata

select customerid,substring(name,1,5)
as first_five_letter_of_name 
from bankingdata;


-- 7) find total amount of balance in all acoounts

select sum(balance)as totalamount 
from bankingdata;


 -- 8) FIND THE find the maximun loan amount of 5 customers 

SELECT customerid,name,loanamount AS MaxLoanAmount 
FROM bankingData 
order by loanamount desc limit 5;


-- 9) SQL QUERY TO SHOW THE SECOND HIGHEST LOAN  USING SUB-QUERY

SELECT MAX(loanAmount) As SecondHighestLoan 
FROM bankingdata
WHERE loanAmount<
(SELECT MAX(loanAmount)FROM bankingdata);


-- 10) find the maximun and minimum balance of customers from all account types

select accounttype,
min(balance),
max(balance) 
from bankingdata group by accounttype;


-- 11) TOP 10 CUSTOMER WITH HIGHEST LOAN AMOUNT

select customerID,name,loanAmount from bankingdata
 order by LoanAmount desc limit 10 ;


-- 12) Show how to execute the procedure with customer id     **stored procedure** cus_id

delimiter $$
create procedure customerId(in c_id int)
begin
select*from bankingdata where customerid=c_id;
end$$
delimiter ;

call customerid(25);


-- 13) Create a view named active_customers to show customerID,name,status.        **view for active accounts

create view active_customers as
select customerID,name,status as activecustomers 
from bankingdata 
where status='active';

select * from active_customers;

drop view active_customers;


-- 14) Write a query to fetch customers whose *Email domain is 'yahoo.com'*.

select customerID,name,email 
from bankingdata 
where email like '%yahoo.com';


-- 15) fech the all customers details from bankingdata

select*from bankingData;


-- 16)display high valued loan amount to low value loan amount and give row number to that list    ** windows function

select customerid,name,status,loanamount,
row_number() over (partition by status order by loanamount) 
from bankingdata;


-- 17 CATEGORIZE CUSTOMERS INTO THREE AGE GROUPS (when case)           

SELECT Name, Age, 
CASE
   WHEN Age <30 THEN 'BELOW 30'
   WHEN Age BETWEEN 30 AND 60 THEN '30 to 60'
  ELSE 'Above 60'
 END As age_group 
 FROM  bankingdata ;
 
 -- 18) find the count of different loan type in bankingdata

select loantype,count(*)
from bankingdata group by loantype;
 

 -- 19) find loans that are currently active         

 select customerid,name,loanstatus,loanenddate from bankingdata
 where loanenddate<current_date() 
 and loanstatus='active';

-- 20) DELETE INACTIVE ACCOUNTS

SET SQL_SAFE_UPDATES=0;
DELETE FROM bankingdata
WHERE Status = 'Inactive';

-- 21) FIND THE balance OF customers for loanstardate in june 2023    ***

SELECT name,status,balance,loanenddate
FROM bankingdata
WHERE MONTH(loanstartdate)=2
AND YEAR (loanstartDate)=2020;

-- 22) SQL QUERY TO CALCULATE HOW MANY DAYS ARE REMAINING FOR CUSTOMERS TO PAY OFF THE LOANS        **
       
SELECT CustomerID,loanenddate,DATEDIFF(loanEndDate, CURDATE()) 
AS DaysRemaining FROM bankingdata
where loanenddate>curdate();

select curdate();

select* from bankingdata;

