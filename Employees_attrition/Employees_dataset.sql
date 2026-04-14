

create database Employee_dataset
use Employee_dataset

select top 5 * from Employee_Attrition_Dataset

-- attrition overview -- 

-- Overall Attrition --

create view attrition_overall as
select count(*) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count, 
sum(case when Attrition = 'Yes' then 1 else 0 end) * 100.0 / count(*) AS attrition_rate
from Employee_Attrition_Dataset

select * from attrition_overall

-- attrition by department -- 

create view attrition_department as
select Department, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by Department;

select * from attrition_department

-- attrition by job level --

create view attrition_joblevel as
select JobLevel, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by JobLevel;

select * from attrition_joblevel

-- root cause analysis --

-- Attrition by Salary -- 

create view attrition_salary as
select MonthlyIncome, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by MonthlyIncome;

select * from attrition_salary

-- Attrition by Job Satisfaction --

create view attrition_satisfaction as
select JobSatisfaction, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by JobSatisfaction;

select * from attrition_satisfaction

-- Attrition by Overtime --

create view attrition_overtime as
select OverTime, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by OverTime;

select * from attrition_overtime

-- Employee Insights -- 

-- Attrition by Age --

create view attrition_age as
select Age, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by Age;

select * from attrition_age

-- Attrition by Experience --

create view attrition_experience as
select YearsAtCompany, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by YearsAtCompany;

select * from attrition_experience

-- Attrition by Promotion -- 

create view attrition_promotion as
select PromotionLast5Years, count(EmployeeID) as total_employees, sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count
from Employee_Attrition_Dataset
group by PromotionLast5Years;

select * from attrition_promotion

