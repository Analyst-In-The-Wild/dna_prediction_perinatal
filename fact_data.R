db_ra <- dplyr::tbl(conn_sql_rio, dbplyr::sql(
    "SELECT
      [XXXXX] as [client_id]
      ,[XXXXX] as [ra_assessment_date]
      ,[XXXXX] as [relationship]
      ,[XXXXX] as [child_dob]
      ,[XXXXX] as [primary_care]
      ,[XXXXX] as [child_name]
  FROM [XXXXX].[XXXXX].[XXXXX]

  "
))  %>%
    filter(client_id %in% perinatal_pats) %>%
    filter(child_dob < "2008-01-01" |
               is.na(child_dob)) %>%
    collect() %>%
    tidyr::separate(child_name, c("child_name1", "child_name2"), sep = " ", extra = "merge") %>%
    arrange(child_dob) %>%
    distinct(client_id, relationship, child_name1, .keep_all = TRUE) %>%
    group_by(client_id) %>%
    summarise(children = n()) %>%
    ungroup()


db_cci <- dplyr::tbl(conn_sql_rio, dbplyr::sql(
    "SELECT
      [XXXXX] as [client_id]
      ,[XXXXX] as [cci_assessment_date]
      ,[XXXXX] as [smoking_status]
      ,[XXXXX] as [employment_status]
      ,[XXXXX] as [autism_status]
      ,[XXXXX] as [idd_status]
      ,[XXXXX] as [physical_status]
      ,[XXXXX] as [armedforces_status]
  FROM [XXXXX].[XXXXX].[XXXXX]
  "
))  %>%
    filter(client_id %in% perinatal_pats)

db_acc <- dplyr::tbl(conn_sql_rio, dbplyr::sql(
    "SELECT
      [XXXXX] as [client_id]
      ,[XXXXX] as [accom_assessment_date]
      ,[XXXXX] as [accommodation_type]
  FROM [XXXXX].[XXXXX].[XXXXX]
  "
))  %>%
    filter(client_id %in% perinatal_pats) %>%
    full_join(db_cci) %>%
    collect() %>%
    arrange(desc(cci_assessment_date)) %>%
    distinct(client_id, .keep_all = TRUE) %>%
    mutate(grouped_accom = case_when(str_detect(accommodation_type, "Homeless") ~ "Other",
                              str_detect(accommodation_type, "Rough") ~ "Other",
                              str_detect(accommodation_type, "Squat") ~ "Other",
                              str_detect(accommodation_type, "Refuge") ~ "Other",
                              str_detect(accommodation_type, "Sofa") ~ "Other",
                              str_detect(accommodation_type, "Ward") ~ "Hospital",
                              str_detect(accommodation_type, "Hospital") ~ "Hospital",
                              str_detect(accommodation_type, "Unit") ~ "Hospital",
                              str_detect(accommodation_type, "Owner") ~ "Private Paid",
                              str_detect(accommodation_type, "Supported") ~ "Supported Living",
                              str_detect(accommodation_type, "are") ~ "Supported Living",
                              str_detect(accommodation_type, "Acute") ~ "Supported Living",
                              str_detect(accommodation_type, "Bail") ~ "CJS",
                              str_detect(accommodation_type, "Detention") ~ "CJS",
                              str_detect(accommodation_type, "Prison") ~ "CJS",
                              str_detect(accommodation_type, "Housing Asso") ~ "Social",
                              str_detect(accommodation_type, "Social") ~ "Social",
                              str_detect(accommodation_type, "Sheltered") ~ "Supported Living",
                              str_detect(accommodation_type, "riend") ~ "Settled",
                              str_detect(accommodation_type, "Nursing") ~ "Supported Living",
                              str_detect(accommodation_type, "Special") ~ "Supported Living",
                              str_detect(accommodation_type, "Settled") ~ "Settled",
                              str_detect(accommodation_type, "Private") ~ "Private Paid",
                              str_detect(accommodation_type, "Not") ~ "Unknown",
                              TRUE ~ "Other"),
           employ_grouped = case_when(str_detect(employment_status, "Employed") ~ "Employed",
                                      str_detect(employment_status, "Not Stated") ~ "Unknown",
                                      str_detect(employment_status, "sick") ~ "LTS",
                                      str_detect(employment_status, "and seeking") ~ "Seeking Employment",
                                      TRUE ~ "Unemployed"),
           autism = case_when(autism_status == "Yes" ~ "Autism",
                              TRUE ~ "No/Not Declared"),
           idd = case_when(idd_status == "Yes" ~ "IDD",
                              TRUE ~ "No/Not Declared"),
           physical = case_when(physical_status == "Yes" ~ "PH Condition",
                              TRUE ~ "No/Not Declared"),
           smoking = case_when(str_detect(smoking_status, "Current") ~ "Smoker",
                               str_detect(smoking_status, "Never") ~ "Non - Smoker",
                               str_detect(smoking_status, "Non") ~ "Non - Smoker",
                               str_detect(smoking_status, "Ex") ~ "Ex - Smoker",
                               TRUE ~ "Unknown"
           ))
