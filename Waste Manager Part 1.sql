##Waste Manager- Part 1

##The objective of this SQL analysis is to gain actionable insights into waste patterns and trends to identify key factors influencing waste load so that we can optimizes waste management practices.

##Firstly, we will create and load the waste management database.
USE waste_management;

SET GLOBAL sql_mode = '';

LOAD DATA INFILE 'C:/Program Files/MariaDB 11.6/data/Waste_Collection.csv'
INTO TABLE waste
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

##Check if the dataset has been uploaded properly##
SELECT *
FROM waste;

## We would like to know high-load dropoff sites to prioritize and optimize waste collection routes.
SELECT 	Dropoff_Site,
		SUM(Load_Weight) AS Total_Weight
FROM 	waste
GROUP BY Dropoff_Site
Order by Total_Weight DESC;

##Understand which types of waste are most significant and prioritize strategies for reducing or recycling them
SELECT 	load_type, 
		SUM(Load_Weight) AS Total_Weight
FROM 	waste
GROUP BY load_type
Order by Total_Weight DESC;

##Track daily variations in waste collection and plan staffing or truck usage accordingly
SELECT DAYNAME(Report_Date) AS Day_Name, 
       SUM(Load_Weight) AS Total_Weight
FROM waste
GROUP BY DAYNAME(Report_Date)
ORDER BY Total_Weight;

##Day to day weight variation in top 10 dropoff site
WITH TopDropoffSites AS (
    SELECT 
        Dropoff_Site,
        SUM(Load_Weight) AS Total_Weight
    FROM 
        waste
    GROUP BY 
        Dropoff_Site
    ORDER BY 
        Total_Weight DESC
    LIMIT 10
)
SELECT 
    DAYNAME(Report_Date) AS Day_Name, 
    Dropoff_Site, 
    SUM(Load_Weight) AS Total_Weight
FROM 
    waste
WHERE 
    Dropoff_Site IN (SELECT Dropoff_Site FROM TopDropoffSites)
GROUP BY 
    DAYNAME(Report_Date), 
    Dropoff_Site
ORDER BY 
    Day_Name, 
    Total_Weight DESC;

##Identify the busiest times for waste collection to optimize route planning
SELECT CASE 
			WHEN HOUR(Load_Time) = 0 THEN '12 AM'
			WHEN HOUR(Load_Time) BETWEEN 1 AND 11 THEN CONCAT(HOUR(Load_Time), ' AM')
			WHEN HOUR(Load_Time) = 12 THEN '12 PM'
			WHEN HOUR(Load_Time) BETWEEN 13 AND 23 THEN CONCAT(HOUR(Load_Time) - 12, ' PM')
			ELSE 'Invalid Hour'
		END AS Hour, 
       SUM(Load_Weight) AS Total_Weight
FROM waste
GROUP BY HOUR(Load_Time)
ORDER BY Total_Weight DESC;

##Assess which routes are underperforming or overloaded.
SELECT Route_Number, 
       COUNT(*) AS Total_Trips, 
       AVG(Load_Weight) AS Avg_Weight
FROM waste
GROUP BY Route_Number
ORDER BY Avg_Weight DESC;

##Identify seasonal trends in waste generation
SELECT MONTHNAME(Report_Date) AS Month, 
       SUM(Load_Weight) AS Total_Weight
FROM waste
GROUP BY MONTH(Report_Date)
ORDER BY Total_Weight;

##Average and maximum load weight per trip
SELECT Route_Number, 
       AVG(Load_Weight) AS Avg_Weight, 
       MAX(Load_Weight) AS Max_Weight
FROM waste
GROUP BY Route_Number
ORDER BY Avg_Weight DESC;

##Site Contribution Percentage
SELECT Dropoff_Site, 
       (SUM(Load_Weight) / (SELECT SUM(Load_Weight) FROM waste) * 100) AS Contribution_Percentage
FROM waste
GROUP BY Dropoff_Site
ORDER BY Contribution_Percentage DESC;

##Correlation Between Waste Types and Dropoff Sites
SELECT Dropoff_Site, 
       Load_Type, 
       SUM(Load_Weight) AS Total_Weight
FROM waste
GROUP BY Dropoff_Site, Load_Type
ORDER BY Dropoff_Site, Total_Weight DESC;

##Anomalies
SELECT Dropoff_Site,
		COUNT(Load_ID) AS Anomaly_Count
FROM waste
WHERE Load_Weight > (SELECT AVG(Load_Weight) + 2 * STDDEV(Load_Weight) FROM waste)
   OR Load_Weight < (SELECT AVG(Load_Weight) - 2 * STDDEV(Load_Weight) FROM waste)
GROUP BY Dropoff_Site;

SELECT Load_Type,
		COUNT(Load_ID) AS Anomaly_Count
FROM waste
WHERE Load_Weight > (SELECT AVG(Load_Weight) + 2 * STDDEV(Load_Weight) FROM waste)
   OR Load_Weight < (SELECT AVG(Load_Weight) - 2 * STDDEV(Load_Weight) FROM waste)
GROUP BY Load_type;