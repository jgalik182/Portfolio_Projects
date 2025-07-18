-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
SELECT * FROM encounters;

SELECT Year(Start) AS yr, Count(ID) AS total_encounters
FROM encounters
GROUP BY yr
ORDER BY yr;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
SELECT Year(Start) AS yr, 
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS abulatory,
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS outpatient,
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS wellness,
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS urgent_care,
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS emergency,
       ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS inpatient
FROM encounters
GROUP BY yr
ORDER by yr;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT *
FROM encounters;

SELECT count(TIMESTAMPDIFF(HOUR, START, STOP))
FROM encounters
WHERE TIMESTAMPDIFF(HOUR, START, STOP) > 24;

SELECT count(TIMESTAMPDIFF(HOUR, START, STOP))
FROM encounters
WHERE TIMESTAMPDIFF(HOUR, START, STOP) < 24;

SELECT ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) >= 24 THEN 1 ELSE 0 END) / COUNT(*) *100,1) AS over_24_hours,
	   ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) < 24 THEN 1 ELSE 0 END)/ COUNT(*) *100,1) AS under_24_hours
FROM encounters;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT * 
FROM encounters;

SELECT COUNT*)
FROM encounters
WHERE PAYER_COVERAGE = 0;

SELECT COUNT(*)
FROM encounters;

SELECT SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) AS zero_payer_coverage,
	   COUNT(*) AS total_encounters,
       ROUND(SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) /COUNT(*)* 100, 1) AS pct_zero_payer_coverage
FROM encounters;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT * FROM encounters;
SELECT * FROM procedures;

SELECT CODE, DESCRIPTION, COUNT(*) AS num_procedures, AVG(BASE_COST) AS avg_base_cost
FROM procedures
GROUP BY CODE, DESCRIPTION
ORDER BY num_procedures DESC
LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT CODE, DESCRIPTION, AVG(BASE_COST) AS avg_base_cost, COUNT(*) AS num_procedures
FROM procedures
GROUP BY CODE, DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT * FROM encounters; -- payer
SELECT * FROM payers; -- id

SELECT P.NAME, AVG(e.TOTAL_CLAIM_COST) AS avg_total_claim_cost
FROM   payers p LEFT JOIN encounters e ON p.id = e.PAYER
GROUP BY p.NAME
ORDER BY avg_total_claim_cost DESC;


-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
SELECT * FROM encounters;

SELECT YEAR(START) AS yr, QUARTER(START) AS qrtr, COUNT(DISTINCT PATIENT) AS num_unique_patients
FROM encounters
GROUP BY yr, qrtr
ORDER BY yr, qrtr;

-- b. How many patients were readmitted within 30 days of a previous encounter?
SELECT PATIENT, START, STOP,
	   LEAD(START)OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
FROM encounters
ORDER BY PATIENT, START;

WITH cte AS (SELECT PATIENT, START, STOP,
	                LEAD(START)OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
             FROM   encounters)

SELECT COUNT(DISTINCT PATIENT) AS num_patients
FROM cte
WHERE DATEDIFF(next_start_date, STOP) <30;

-- c. Which patients had the most readmissions?
WITH cte AS (SELECT PATIENT, START, STOP,
	                LEAD(START)OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
             FROM   encounters)

SELECT PATIENT, COUNT(*) AS num_readmissions
FROM cte
WHERE DATEDIFF(next_start_date, STOP) <30
GROUP BY PATIENT
ORDER BY num_readmissions DESC;




