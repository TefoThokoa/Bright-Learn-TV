-------Checking the columns and if data was loaded correctly 
Select *
from workspace.default.bright_tv_viewership
limit 10;

Select *
from workspace.default.bright_tv_user_profiles
where gender is not null

------------The start time and end time of data collection -----2016-01-01 till 2016-03-31--
Select min(RecordDate2) as Start_Date, max(RecordDate2) as End_Date
from workspace.default.bright_tv_viewership;

Select min(RecordDate2) as Start_Date, max(RecordDate2) as End_Date
from workspace.default.bright_tv_viewership;

--------------Trying to ascertian the races in the data----
Select distinct (Race)
from workspace.default.bright_tv_user_profiles;



--------------Trying to ascertian the provinces in the data----All 9 provinces are covered 

Select distinct (Province)
from workspace.default.bright_tv_user_profiles;

------Number of males----3918

Select count(Gender) as Number_of_males
from workspace.default.bright_tv_user_profiles
where Gender = 'male';

------Number of females----537

Select count(Gender)as Number_of_females
from workspace.default.bright_tv_user_profiles
where Gender = 'female';

------Number of cases where gender is not specified ----920

Select count(Gender)as Number_of_unknown
from workspace.default.bright_tv_user_profiles
where Gender = 'None' or Gender =' ';

----Breakdown of viewership by province
Select Province, count(Province) as viewership_by_province
from workspace.default.bright_tv_user_profiles
group by Province
order by viewership_by_province desc;



------Join the 2 tables--- 


 Select A.UserID0,
A.Channel2, 
A.RecordDate2 , 
date_format(RecordDate2, 'yyyy/MM/dd') AS SouthAfricanDate,
Date_Format(RecordDate2 + Interval '2 hour','HH:mm:ss') as MzansiTime,
dayname (RecordDate2) as Day_name,
monthname(RecordDate2) as Month_name,
dayofmonth(RecordDate2) as day_of_month,
CASE 
WHEN Dayname(RecordDate2) IN ('Sun','Sat') THEN 'Weekend'
ELSE 'Weekday'
END as day_classification,

 CASE 
 WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '06:00:00' AND '08:59:59' THEN '01. Early Morning'
WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '09:00:00' AND '15:59:59' THEN '02. Daytime'
WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '16:00:00' AND '18:59:59' THEN '03. EarlyEvening'
WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '19:00:00' AND '22:59:59' THEN '04. PrimeTime'
ELSE 'Late Night'
END as ViewingTimes,

A.`Duration 2`,
B.Gender,     
B.Race,

B.Age,

CASE 
 WHEN Age BETWEEN 0 AND 3 THEN 'Toddler'
 WHEN Age BETWEEN 3 AND 12 THEN 'Child'
 WHEN Age BETWEEN 13 AND 19 THEN 'Teenager'
 WHEN Age BETWEEN 20 AND 64 THEN 'Adult'
 WHEN Age BETWEEN 65 AND 120 THEN 'Senior'
 ELSE 'Unknown'
 END as Age_Group,

B.Province,    ------Null needed---
COALESCE(NULLIF(TRIM(B.Province), ''), 'Unknown') AS Province2
From workspace.default.bright_tv_viewership AS A
FULL JOIN workspace.default.bright_tv_user_profiles AS B
ON A.UserID0 = B.UserID;
