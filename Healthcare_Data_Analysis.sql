-- How many encounters did we have before the year 2020?

SELECT COUNT(*)
FROM [Healthcare].[dbo].[encounters]
WHERE START < '2020-01-01'

-- How many distinct patients did we treat before the year 2020?

SELECT COUNT(DISTINCT PATIENT)
FROM [Healthcare].[dbo].[encounters]
WHERE START < '2020-01-01'

-- How many distinct encounter classes are documented in the HEALTHCARE.ENCOUNTERS table?

SELECT COUNT(DISTINCT ENCOUNTERCLASS)
FROM [Healthcare].[dbo].[encounters]
-- WHERE START < '2020-01-01'

-- How many inpatient and ambulatory encounters did we have before 2020?

SELECT COUNT(*)
FROM [Healthcare].[dbo].[encounters]
WHERE START < '2020-01-01' AND ENCOUNTERCLASS IN ('inpatient', 'ambulatory')

-- What is our patient mix by gender, race and ethnicity? 

SELECT GENDER, RACE, ETHNICITY, COUNT(*) AS NUM
FROM [Healthcare].[dbo].[patients]
GROUP BY GENDER, RACE, ETHNICITY

-- What about age?

SELECT ID, BIRTHDATE, DEATHDATE,
	   CASE WHEN DEATHDATE IS NULL THEN FLOOR(DATEDIFF(DAY, BIRTHDATE, GETDATE())/365)
			ELSE FLOOR(DATEDIFF(DAY, BIRTHDATE, DEATHDATE)/365)
			END AS AGE
FROM [Healthcare].[dbo].[patients]

-- How many states and zip codes do we treat patients from?

SELECT COUNT(DISTINCT STATE)
FROM [Healthcare].[dbo].[patients]

SELECT COUNT(DISTINCT ZIP)
FROM [Healthcare].[dbo].[patients]

SELECT DISTINCT ZIP, COUNT(*)
FROM [Healthcare].[dbo].[patients]
GROUP BY ZIP

-- Which county had the highest number of patients?

SELECT DISTINCT COUNTY, COUNT(*) AS NUM
FROM [Healthcare].[dbo].[patients]
GROUP BY COUNTY
ORDER BY COUNT(*) DESC

-- What is our patient mix for patients who had an inpatient encounter in 2019?

SELECT GENDER, RACE, ETHNICITY, COUNT(*) AS NUM
FROM [Healthcare].[dbo].[encounters] E
JOIN [Healthcare].[dbo].[patients] P ON E.PATIENT = P.Id
WHERE START >= '2019-01-01' AND START < '2020-01-01' AND ENCOUNTERCLASS = 'inpatient'
GROUP BY GENDER, RACE, ETHNICITY


-- How many inpatient encounters did we have in the entire dataset where the patient was at least 21 years old at the time of the encounter start?

SELECT COUNT(*) AS NUM
FROM [Healthcare].[dbo].[encounters] E
JOIN [Healthcare].[dbo].[patients] P ON E.PATIENT = P.ID
WHERE ENCOUNTERCLASS = 'inpatient' AND FLOOR(DATEDIFF(DAY, BIRTHDATE, START)/365) >= 21


-- How many emergency encounters did we have in 2019? 

SELECT COUNT(*) AS ER_NUM
FROM [Healthcare].[dbo].[encounters]
WHERE START >= '2019-01-01' AND START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'

-- What conditions were treated in those encounters?

SELECT C.DESCRIPTION, COUNT(*) AS NUM
FROM [Healthcare].[dbo].[encounters] E
LEFT JOIN [Healthcare].[dbo].[conditions] C ON E.ID = C.ENCOUNTER
WHERE E.START >= '2019-01-01' AND E.START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'
GROUP BY C.DESCRIPTION
ORDER BY NUM DESC

-- What was the emergency throughput and how did that vary by condition treated?

SELECT DESCRIPTION, AVG(THROUGHPUT_IN_MIN) AS THR_AVG
FROM
(
SELECT E.ID, C.DESCRIPTION, DATEDIFF(MINUTE, E.START, E.STOP) AS THROUGHPUT_IN_MIN
FROM [Healthcare].[dbo].[encounters] E
LEFT JOIN [Healthcare].[dbo].[conditions] C ON E.ID = C.ENCOUNTER
WHERE E.START >= '2019-01-01' AND E.START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'
) T
GROUP BY DESCRIPTION


-- How many emergency encounters did we have before 2020?

SELECT COUNT(*) AS ER_NUM
FROM [Healthcare].[dbo].[encounters]
WHERE START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'

-- Other than nulls (where no condition was documented), which condition was most documented for emergency encounters before 2020?

SELECT C.DESCRIPTION, COUNT(*) AS NUM
FROM [Healthcare].[dbo].[encounters] E
LEFT JOIN [Healthcare].[dbo].[conditions] C ON E.ID = C.ENCOUNTER
WHERE E.START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'
GROUP BY C.DESCRIPTION
ORDER BY NUM DESC

-- How many conditions for emergency encounters before 2020 had average ER throughputs above 100 minutes? 

SELECT COUNT(*) AS NUM
FROM
(
SELECT DESCRIPTION, AVG(THROUGHPUT_IN_MIN) AS THR_AVG
FROM
(
SELECT E.ID, C.DESCRIPTION, DATEDIFF(MINUTE, E.START, E.STOP) AS THROUGHPUT_IN_MIN
FROM [Healthcare].[dbo].[encounters] E
LEFT JOIN [Healthcare].[dbo].[conditions] C ON E.ID = C.ENCOUNTER
WHERE E.START < '2020-01-01' AND ENCOUNTERCLASS = 'emergency'
) T1
GROUP BY DESCRIPTION
HAVING AVG(THROUGHPUT_IN_MIN) > 100
) T2


-- What is total claim cost for each encounter in 2019?

SELECT SUM(TOTAL_CLAIM_COST) AS TOTAL_FOR_2019, AVG(TOTAL_CLAIM_COST) AS AVG_FOR_2019
FROM [Healthcare].[dbo].[encounters]
WHERE START >= '2019-01-01' AND START < '2020-01-01'

-- What is total payer coverage for each encounter in 2019?

SELECT SUM(PAYER_COVERAGE) AS TOTAL_FOR_2019, AVG(PAYER_COVERAGE) AS AVG_FOR_2019
FROM [Healthcare].[dbo].[encounters]
WHERE START >= '2019-01-01' AND START < '2020-01-01'

-- Which encounter types had the highest cost?

SELECT ENCOUNTERCLASS, SUM(TOTAL_CLAIM_COST) AS TOTAL_FOR_2019, AVG(TOTAL_CLAIM_COST) AS AVG_FOR_2019
FROM [Healthcare].[dbo].[encounters]
WHERE START >= '2019-01-01' AND START < '2020-01-01'
GROUP BY ENCOUNTERCLASS
ORDER BY TOTAL_FOR_2019 DESC

-- Which encounter types had the highest cost covered by payers?

SELECT PAYER, ENCOUNTERCLASS, SUM(TOTAL_CLAIM_COST)-SUM(PAYER_COVERAGE) AS COVER_FOR_2019
FROM [Healthcare].[dbo].[encounters]
WHERE START >= '2019-01-01' AND START < '2020-01-01'
GROUP BY PAYER, ENCOUNTERCLASS
ORDER BY COVER_FOR_2019 DESC

-- Which payer had the highest claim coverage percentage (total payer coverage/ total claim cost) for encounters before 2020?

SELECT E.PAYER, P.NAME, SUM(PAYER_COVERAGE)/SUM(TOTAL_CLAIM_COST) AS COVER_PERC_FOR_2019
FROM [Healthcare].[dbo].[encounters] E
JOIN [Healthcare].[dbo].[payers] P ON E.PAYER = P.ID
WHERE START < '2020-01-01'
GROUP BY E.PAYER, P.NAME
ORDER BY COVER_PERC_FOR_2019 DESC

-- Which payer had the highest claim coverage percentage (total payer coverage / total claim cost) for ambulatory encounters before 2020?

SELECT E.PAYER, P.NAME, SUM(PAYER_COVERAGE)/SUM(TOTAL_CLAIM_COST) AS COVER_PERC_FOR_2019
FROM [Healthcare].[dbo].[encounters] E
JOIN [Healthcare].[dbo].[payers] P ON E.PAYER = P.ID
WHERE START < '2020-01-01' AND ENCOUNTERCLASS = 'ambulatory'
GROUP BY E.PAYER, P.NAME
ORDER BY COVER_PERC_FOR_2019 DESC

-- How many different types of procedures did we perform in 2019?

SELECT COUNT(DISTINCT DESCRIPTION) AS TOTAL_PROCS
FROM [Healthcare].[dbo].[procedures]
WHERE DATE >= '2019-01-01' AND DATE < '2020-01-01'
GROUP BY DESCRIPTION

SELECT COUNT(*)
FROM
(SELECT DESCRIPTION, COUNT(*) AS TOTAL_PROCS
FROM [Healthcare].[dbo].[procedures]
WHERE DATE >= '2019-01-01' AND DATE < '2020-01-01'
GROUP BY DESCRIPTION) T 
-- How many procedures were performed across each care setting (inpatient/ambulatory)?

SELECT E.ENCOUNTERCLASS, COUNT(*) AS TOTAL_PROCS_FOR_CLASS
FROM [Healthcare].[dbo].[procedures] P
JOIN [Healthcare].[dbo].[encounters] E ON P.ENCOUNTER = E.ID
WHERE DATE >= '2019-01-01' AND DATE < '2020-01-01'
GROUP BY E.ENCOUNTERCLASS

-- Which organizations performed the most inpatient procedures in 2019?

SELECT E.ORGANIZATION, COUNT(*) AS TOTAL_PROCS_FOR_ORG
FROM [Healthcare].[dbo].[procedures] P
JOIN [Healthcare].[dbo].[encounters] E ON P.ENCOUNTER = E.ID
JOIN [Healthcare].[dbo].[organizations] O ON E.ORGANIZATION = O.ID
WHERE DATE >= '2019-01-01' AND DATE < '2020-01-01' AND E.ENCOUNTERCLASS = 'inpatient'
GROUP BY E.ORGANIZATION


-- How many Colonoscopy procedures were performed before 2020?

SELECT COUNT(*) AS CNT_Colonoscopy
FROM [Healthcare].[dbo].[procedures] 
WHERE DATE < '2020-01-01' AND DESCRIPTION = 'Colonoscopy'

-- Compare our total number of procedures in 2018 to 2019. Did we perform more procedures in 2019 or less?

SELECT COUNT(*)
FROM
(SELECT DESCRIPTION, COUNT(*) AS TOTAL_PROCS
FROM [Healthcare].[dbo].[procedures]
WHERE DATE >= '2018-01-01' AND DATE < '2019-01-01'
GROUP BY DESCRIPTION) T 

-- Which organizations performed the most Auscultation of the fetal heart procedures before 2020? Give answer with Organization ID.

SELECT E.ORGANIZATION, COUNT(*)
FROM [Healthcare].[dbo].[procedures] P
JOIN [Healthcare].[dbo].[encounters] E ON P.ENCOUNTER = E.ID
JOIN [Healthcare].[dbo].[organizations] O ON E.ORGANIZATION = O.ID
WHERE DATE < '2020-01-01' AND P.DESCRIPTION = 'Auscultation of the fetal heart'
GROUP BY E.ORGANIZATION
ORDER BY COUNT(*) DESC

-- Which race had the highest number of procedures done in 2019?

SELECT PA.RACE, COUNT(*)
FROM [Healthcare].[dbo].[procedures] P
JOIN [Healthcare].[dbo].[patients] PA ON P.PATIENT = PA.Id
WHERE DATE >= '2019-01-01' AND DATE < '2020-01-01'
GROUP BY PA.RACE
ORDER BY COUNT(*) DESC


-- Which race had the highest number of Colonoscopy procedures performed before 2020?

SELECT PA.RACE, COUNT(*)
FROM [Healthcare].[dbo].[procedures] P
JOIN [Healthcare].[dbo].[patients] PA ON P.PATIENT = PA.Id
WHERE DATE < '2020-01-01' AND P.DESCRIPTION = 'Colonoscopy'
GROUP BY PA.RACE
ORDER BY COUNT(*) DESC

-- How many patients had documented uncontrolled hypertension at any time in 2018 and 2019? (140/90 is cutoff)

SELECT DISTINCT PATIENT
FROM [Healthcare].[dbo].[observations]
WHERE ((DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE > 90) 
	OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE > 140))
	AND DATE >= '2018-01-01' AND DATE < '2020-01-01'

-- Which providers treated patients with uncontrolled hypertension in 2018 and 2019?

SELECT DISTINCT O.PATIENT, P.NAME, P.SPECIALITY
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[encounters] E ON O.PATIENT = E.PATIENT AND E.START >= O.DATE--E.ID = O.ENCOUNTER
JOIN [Healthcare].[dbo].[providers] P ON E.PROVIDER = P.ID
WHERE ((O.DESCRIPTION = 'Diastolic Blood Pressure' AND O.VALUE > 90) 
	OR (O.DESCRIPTION = 'Systolic Blood Pressure' AND O.VALUE > 140))
	AND O.DATE >= '2018-01-01' AND O.DATE < '2020-01-01'

-- What medications were given to patients with uncontrolled hypertension?

SELECT DISTINCT O.PATIENT, M.DESCRIPTION AS MEDICATION
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[medications] M ON O.PATIENT = M.PATIENT AND M.START >= O.DATE
WHERE ((O.DESCRIPTION = 'Diastolic Blood Pressure' AND O.VALUE > 90) 
	OR (O.DESCRIPTION = 'Systolic Blood Pressure' AND O.VALUE > 140))
	AND O.DATE >= '2018-01-01' AND O.DATE < '2020-01-01'


-- If we used a lower cut off of 135/85 for hypertension than the 140/90 discussed in the lecture, how many patients would have been documented hypertension at any time across 2018 or 2019?

SELECT DISTINCT PATIENT
FROM [Healthcare].[dbo].[observations]
WHERE ((DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE > 85) 
	OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE > 135))
	AND DATE >= '2018-01-01' AND DATE < '2020-01-01'

-- What was the most commonly prescribed medication to the patients with hypertension (as identified as having a BP over 140/90 at any point in 2018 or 2019)?

SELECT M.DESCRIPTION, COUNT(*) AS CNT_MEDICATION
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[medications] M ON O.PATIENT = M.PATIENT AND M.START >= O.DATE
WHERE ((O.DESCRIPTION = 'Diastolic Blood Pressure' AND O.VALUE > 90) 
	OR (O.DESCRIPTION = 'Systolic Blood Pressure' AND O.VALUE > 140))
	AND O.DATE >= '2018-01-01' AND O.DATE < '2020-01-01'
GROUP BY M.DESCRIPTION
ORDER BY COUNT(*) DESC

-- Which race had the highest total number of patients with a BP of 140/90 before 2020?

SELECT PA.RACE, COUNT(*) AS CNT_RACE
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[patients] PA ON O.PATIENT = PA.Id
WHERE ((DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE > 90) 
	OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE > 140))
	AND DATE < '2020-01-01'
GROUP BY PA.RACE
ORDER BY COUNT(*) DESC

-- Which race had the highest percentage of blood pressure readings that were above 140/90 and taken before 2020?

WITH T1 AS
(
SELECT PA.RACE, COUNT(*) AS CNT_RACE
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[patients] PA ON O.PATIENT = PA.Id
WHERE ((DESCRIPTION = 'Diastolic Blood Pressure' AND VALUE > 90) 
	OR (DESCRIPTION = 'Systolic Blood Pressure' AND VALUE > 140))
	AND DATE < '2020-01-01'
GROUP BY PA.RACE
),
T2 AS (
SELECT PA.RACE, COUNT(*) AS CNT_RACE
FROM [Healthcare].[dbo].[observations] O
JOIN [Healthcare].[dbo].[patients] PA ON O.PATIENT = PA.Id
WHERE (DESCRIPTION = 'Diastolic Blood Pressure' 
	OR DESCRIPTION = 'Systolic Blood Pressure')
	AND DATE < '2020-01-01'
GROUP BY PA.RACE
)

SELECT T2.RACE, T1.CNT_RACE, T2.CNT_RACE, CAST(T1.CNT_RACE*100.0/T2.CNT_RACE AS DECIMAL(10,2)) AS Perct
FROM T2
LEFT JOIN T1 ON T2.RACE = T1.RACE
ORDER BY Perct DESC


SELECT *
FROM [Healthcare].[dbo].[encounters]

SELECT distinct DESCRIPTION
FROM [Healthcare].[dbo].[immunizations]

SELECT * --distinct DESCRIPTION
FROM [Healthcare].[dbo].allergies

/*
Come up with flu shots dashboard for 2019 that does the following

1.) Total % of patients getting flu shots stratified by
   a.) Age
   b.) Race
   c.) County (On a Map)
   d.) Overall
2.) Running Total of Flu Shots over the course of 2019
3.) Total number of Flu shots given in 2019
4.) A list of Patients that show whether or not they received the flu shots
   
Requirements:

Patients must have been "Active at our hospital"
*/

WITH active_patients AS
(
SELECT DISTINCT E.PATIENT
FROM [Healthcare].[dbo].[encounters] E
JOIN [Healthcare].[dbo].[patients] PA
ON E.PATIENT = PA.Id
WHERE START >= '2019-01-01' AND STOP < '2020-01-01'
	  AND PA.DEATHDATE IS NULL
	  AND DATEDIFF(MONTH, PA.BIRTHDATE, GETDATE()) >= 6
),
flu_shot_2019 AS
(
SELECT PATIENT, SUBSTRING(MIN(DATE), 1, 10) AS EARLIEST_FLU_2019
FROM [Healthcare].[dbo].[immunizations]
WHERE CODE = 140 AND DATE < '2020-01-01' AND DATE >= '2019-01-01'
GROUP BY PATIENT
)

SELECT PA.BIRTHDATE,
		PA.RACE,
		PA.COUNTY,
		PA.Id,
		substring(PA.FIRST, 1, patindex('%[0-9]%',PA.FIRST)-1) AS FIRSTNAME, 
		substring(PA.LAST, 1, patindex('%[0-9]%',PA.LAST)-1) AS LASTNAME,
		PA.GENDER,
		CASE WHEN PA.DEATHDATE IS NULL THEN FLOOR(DATEDIFF(DAY, PA.BIRTHDATE, GETDATE())/365)
			ELSE FLOOR(DATEDIFF(DAY, PA.BIRTHDATE, PA.DEATHDATE)/365)
			END AS AGE,
		FLU.EARLIEST_FLU_2019,
		FLU.PATIENT,
		CASE WHEN FLU.PATIENT IS NULL THEN 0
			ELSE 1
			END AS GET_FLU_SHOT_2019		
FROM [Healthcare].[dbo].[patients] PA
LEFT JOIN flu_shot_2019 FLU ON PA.Id = FLU.PATIENT
WHERE PA.Id IN (SELECT PATIENT FROM active_patients)



