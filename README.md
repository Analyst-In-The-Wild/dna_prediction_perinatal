# Did Not Attend Predictions for Perinatal Mental Health Services

Code being shared for the NHS-R Conference

There are 4 code files and 2 output files

There is also the presentation

### grouping_variable.R
Using nottshcData, a package created for our team to extract simply from the SQL warehouse. Variables from the different tables we want to gorup to produce a more manageable list with enough occurances of each to be able to do stats on. 

### fact_data.R
This contains naming created by the system provider which cannot be shared so have been replaced with XXXX where needed. This contains the manual extraction being done through the SQL integration with dplyr. This included less frequently used data sets we haven't intergrated into nottshcData

### perinatal_extraction.Rmd
This extraction contains the rest of the data manipulation, pulling in the R files, selecting the final variables for the logisitic regression and then presenting the output table using gt and a SJ plot
This also includes defining an initial appointment as per the clinical service definition. A patient cannot have a follow up appointment till they have been seen. So all appointments up to and including the first success would count as initial.
Produces the following file

### perinatal_extraction.html
Output from the previous code file which was discussed in meetings with clinical staff

### dna_monitoring_perinatal.Rmd
Team Codes are considered sensitive so have been redacted. This produces the following 4 tab html output. The first tab graphically shows the change in DNA rate for initial and follow up contacts.
The second tab shows all the women who are due an initial appointment and the risk of them being unable to attend due to the barriers identified during the extraction
The third tab was to identify the patients with a missing ethnicity as this was important to the team to try and address
The final tab shows some basic demographic information for the team caseload particularly the aspects which shows an increase challenging in attending appointments

### dna_monitoring_perinatal.html
This file is the output of the previous Rmd and has certain elements redacts to prevemt unnecessarily disclosure but aesthetically contains everything that the clinical team see and this refreshes on the server for them daily

### nhs_r_presentation.ppt
The presentation slides from NHS-R Community Conference 2023 (Wednesday 11th October)
