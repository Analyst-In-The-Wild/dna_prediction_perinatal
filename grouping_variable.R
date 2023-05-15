teams <- get_rio_team_spec(team_status = TRUE,
                           return = "tbl_df") %>%
    tidy_rio_team_spec() %>%
    filter(service_desc == "Perinatal") %>%
    pull(team_code)

start_date <- "2019-01-01"

end_date <- "2022-09-01"

appt_method <- get_rio_contacts() %>%
    tidy_rio_contacts() %>%
    filter(team_code %in% teams) %>%
    distinct(appt_type_desc) %>%
    collect() %>%
    mutate(appt_method = case_when(str_detect(appt_type_desc, "hone") ~ "Phone",
                                   str_detect(appt_type_desc, "Video") ~ "Video",
                                   str_detect(appt_type_desc, "Group") ~ "Face to Face",
                                   str_detect(appt_type_desc, "Present") ~ "EXCLUDE",
                                   TRUE ~ "Face to Face"))

appt_attendance <- get_rio_contacts() %>%
    tidy_rio_contacts() %>%
    filter(team_code %in% teams) %>%
    distinct(appt_type_desc) %>%
    collect() %>%
    mutate(appt_attendance = case_when(str_detect(appt_type_desc, "Group") ~ "Group",
                                       str_detect(appt_type_desc, "Present") ~ "EXCLUDE",
                                       TRUE ~ "Individual"))

appt_location <- get_rio_contacts() %>%
    tidy_rio_contacts() %>%
    filter(team_code %in% teams) %>%
    distinct(location_desc) %>%
    collect() %>%
    mutate(appt_location = case_when(str_detect(location_desc, "Home") ~ "Residence",
                                     str_detect(location_desc, "Hospital") ~ "Hospital",
                                     str_detect(location_desc, "Dep") ~ "Hospital",
                                     str_detect(location_desc, "Day") ~ "Hospital",
                                     str_detect(location_desc, "Hopewood") ~ "Hospital",
                                     str_detect(location_desc, "MHU") ~ "Hospital",
                                     str_detect(location_desc, "Clinic") ~ "Hospital",
                                     str_detect(location_desc, "Ward") ~ "Hospital",
                                     str_detect(location_desc, "NHS") ~ "Hospital",
                                     TRUE ~ "Community Location"))

hcp_job <- get_rio_hcp_details() %>%
    tidy_rio_hcp_details()

hcp_role <- get_rio_contacts() %>%
    tidy_rio_contacts() %>%
    filter(team_code %in% teams) %>%
    filter(lead_hcp_yes_no == "Yes") %>%
    left_join(hcp_job) %>%
    distinct(hcp_desc) %>%
    collect() %>%
    mutate(hcp_role = case_when(str_detect(hcp_desc, "CPN") ~ "Nurse",
                                str_detect(hcp_desc, "Nursery") ~ "Nursery Nurse",
                                str_detect(hcp_desc, "Nurse") ~ "Nurse",
                                str_detect(hcp_desc, "Psycho") ~ "Psychologist",
                                str_detect(hcp_desc, "Medic") ~ "Medic",
                                str_detect(hcp_desc, "Support") ~ "Support Worker",
                                TRUE ~ "AHP"
    ))

referrer <- get_rio_referrals() %>%
    tidy_rio_referrals() %>%
    filter(team_code %in% teams) %>%
    distinct(referral_source_desc) %>%
    collect() %>%
    mutate(referrer = case_when(str_detect(referral_source_desc, "General") ~ "GP",
                                str_detect(referral_source_desc, "Maternity") ~ "Health Service",
                                str_detect(referral_source_desc, "A&E") ~ "Health Service",
                                str_detect(referral_source_desc, "Health") ~ "Health Service",
                                str_detect(referral_source_desc, "(?i)Internal") ~ "NottsHC",
                                str_detect(referral_source_desc, "non-NHS") ~ "Other",
                                str_detect(referral_source_desc, "NHS") ~ "Health Service",
                                str_detect(referral_source_desc, "Clinical") ~ "Health Service",
                                str_detect(referral_source_desc, "General") ~ "GP",
                                TRUE ~ "Other"
    ))


