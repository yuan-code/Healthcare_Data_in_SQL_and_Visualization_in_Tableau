# Healthcare Data in SQL and Visualization in Tableau

This healthcare analytics project uses SQL queries to explore various use cases such as patient volumes, emergency room throughput, and procedures.

The sample data is generated from Synthea and not associated with a specific electronic healthcare record platform. This data is not reflective of any current or past performance or clinical data for any patient, health system, insurance provider, or any other entity. All data is fake and made available for educational purposes only. 

In this project first of all I look at volumes, which give an idea of how much activity is going on with the healthcare system and help identify opportunities for growth or where further support might be needed. 

  Sample questions:
  
  - How many encounters did we have before the year 2020?
  - How many distinct patients did we treat before the year 2020?
  - How many distinct encounter classes are documented?
  - How many inpatient/ ambulatory encounters did we have before the year 2020?
    
Then I look at who our patients are. 

  Sample questions:

  - What is our patient mix by gender, race and ethnicity?
  - What about age?
  - How many states and zip codes do we treat patients from?
  - Which state, zip, and county do we treat the most patients from?
  - What is our patient mix for patients who had an inpatient encounter in 2019?
  - How many inpatient encounters did we have in the entire dataset where the patient was at least 21 years old at the time of the encounter start?

Next, I'd like to know what is happening in the ER. I check ER throughput (a key indicator of volume, patient access, and system’s ability to support its community).

  Sample questions:

  - How many emergency encounters did we have in 2019?
  - What conditions were treated in those encounters?
  - What was the emergency throughput and how did that vary by condition treated?
  - How many emergency encounters did we have before 2020?
  - Which condition was most documented for emergency encounters before 2020?
  - How many conditions for emergency encounters before 2020 had average ER throughputs above 100 minutes? 

Next, I want to see what cost of care looks like for our patients. Because cost of care varies by many factors including care received and healthcare insurance coverage. The financial impact of these costs can significantly affect each patient.

  Sample questions:

  - What is total claim cost for each encounter in 2019?
  - What is total payer coverage for each encounter in 2019?
  - Which encounter types had the highest cost?
  - Which encounter types had the highest cost covered by payers?
  - Which payer had the highest claim coverage percentage (total payer coverage/ total claim cost) for ambulatory encounters before 2020?

Then I look at what procedures we are performing. Many patient treatments may involve various procedures. Analyzing this information can help us identify what procedures are needed most to guide further expansion of support to meet evolving healthcare needs.

  Sample questions:

  - How many different types of procedures did we perform in 2019?
  - How many procedures were performed across each care setting (inpatient/ambulatory)?
  - Which organizations performed the most inpatient procedures in 2019?
  - How many Colonoscopy procedures were performed before 2020?
  - Compare our total number of procedures in 2018 to 2019. Did we perform more procedures in 2019 or less?
  - Which organizations performed the most Auscultation of the fetal heart procedures before 2020?
  - Which race had the highest number of procedures done in 2019?
  - Which race had the highest number of Colonoscopy procedures performed before 2020?
    
Finally I want to look at blood pressure management. Blood pressure is a key indicator of cardiovascular health. 

  Sample questions:

  - How many patients had documented uncontrolled hypertension at any time in 2018 and 2019?
  - Which providers treated patients with uncontrolled hypertension in 2018 and 2019?
  - What medications were given to patients with uncontrolled hypertension?
  - If we used a lower cut off of 135/85 for hypertension than the 140/90 discussed in the lecture, how many patients would have been documented hypertension at any time across 2018 or 2019?
  - What was the most commonly prescribed medication to the patients with hypertension (as identified as having a BP over 140/90 at any point in 2018 or 2019)?
  - Which race had the highest total number of patients with a BP of 140/90 before 2020?
  - Which race had the highest percentage of blood pressure readings that were above 140/90 and taken before 2020?

In this healthcare analytics project, I build some dashoboards in tableau for flu shots, emergency room visits, and encounters.

[View Flu Shot Dashboard](https://public.tableau.com/app/profile/yuan.hong1407/viz/ImmunizationDashboard_17059437063380/Dashboard1)

[View Emergency Room Visit Dashboard](https://public.tableau.com/app/profile/yuan.hong1407/viz/ERDashboard_17056878215500/Dashboard1)

[View Encounter Dashboard 1](https://public.tableau.com/app/profile/yuan.hong1407/viz/EncounterDashboard1/Dashboard2)

[View Encounter Dashboard 2](https://public.tableau.com/app/profile/yuan.hong1407/viz/EncounterDashboard2/Dashboard1)







