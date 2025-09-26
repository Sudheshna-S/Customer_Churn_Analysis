create database Customer_Churn_Prediction;

use Customer_Churn_Prediction;

create table Customers(
customerID varchar(32) not null Primary Key,
gender varchar(10),
seniorCitizen tinyint,
partner varchar(3),
dependents varchar(3),
tenure int,
phoneService varchar(5),
multipleLines varchar(20),
internetService varchar(20),
onlineSecurity varchar(20),
onlineBackup varchar(20),
deviceProtection varchar(20),
techSupport varchar(20),
streamingTV varchar(20),
streamingMovies varchar(20),
contract varchar(20),
paperlessBilling varchar(3),
paymentMethod varchar(50),
monthlyCharges decimal(8,2),
totalCharges decimal(10,2) null,
churn varchar(3)
);

-- Data Quality checks 
-- 1.1  Checking for totals & missing values

select count(*) as total_rows,
		sum(case when totalCharges is null then 1 else 0 end) as totalCharges_null,
        sum(case when monthlyCharges is null then 1 else 0 end) as monthlyCharges_null
from Customers;

-- 1.2 Checking for Duplicates

select customerID, count(*) 
from customers
group by customerID
having count(*) > 1;

-- 1. Initial Data Exploration & Churn Rate
-- 1.1 Calculate Overall Churn Rate (Aggregate Function)

select count(customerID) as total_customers,
		sum(case when churn = "Yes" then 1 else 0 end) as total_churned,
        avg(case when churn = "Yes" then 1 else 0 end) as overall_churn_rate
from customers;

-- 2. Analyzing Churn by Demographics and Services
-- 2.1 Churn Rate by Internet Service Type (GROUP BY, ORDER BY, Aggregate Function)

select internetService,
		count(customerID) as total_customers,
        avg(case when churn = 'Yes' then 1 else 0 end) as churn_rate
from customers
group by internetService
order by churn_rate DESC;

-- 2.2 Churn Rate by Contract Type (GROUP BY, ORDER BY, Aggregate Function)

select contract,
	count(customerID) as total_customers,
    avg(case when churn = 'Yes' then 1 else 0 end) as churn_rate
from customers
group by contract
order by churn_rate DESC;

-- 3. Investigating Tenure and Monthly Charges (WHERE, SUM, AVG)
-- 3.1 Average Tenure and Charges for Churned vs. Retained Customers (WHERE, AVG)

select churn,
	avg(tenure) as avg_tenure,
    avg(monthlyCharges) as avg_monthly_charges,
    avg(totalCharges) as avg_total_charges
from customers
group by churn;

-- 3.2 High-Value, Short-Term Churners (WHERE, Subquery/Conditional Logic)

select count(customerID) as high_value_short_term_churners
from customers
where churn = 'Yes' and tenure < 12 and monthlyCharges > 80;




-- To simplify subsequent queries and analysis, we'll create a view focusing on the churn segment.

create view Churned_Customers_View as 
select 
	customerID, gender, seniorCitizen, partner, dependents, tenure, phoneService, multipleLines,
	internetService, onlineSecurity, onlineBackup, deviceProtection, techSupport, streamingTV,
	streamingMovies, contract, paperlessBilling, paymentMethod , monthlyCharges, totalCharges, churn 
from customers
where churn = 'Yes';






















