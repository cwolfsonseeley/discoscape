donorscape_query_template <-
    "
select
'4341' as account_id,
'Y' as screening_indicator,
##entity_id##,
first_name,
middle_name,
last_name,
prim_home_street1 as home_street_address,
prim_home_street2 as home_apt_unit_suite,
prim_home_city as home_city,
prim_home_state_code as home_state,
prim_home_zipcode5 as home_zip_code,
business_company_name_1 as employer,
business_street1 as business_street_address,
business_street2 as business_apt_unit_suite,
business_city as business_city,
business_state_code as business_state,
business_zipcode5 as business_zip_code,
birth_dt as date_of_birth,
spouse_entity_id as spouse_id,
spouse_first_name as spouse_first,
spouse_middle_name as spouse_middle,
spouse_last_name as spouse_last
from cdw.d_entity_mv
"

modify <- discoveryengine:::modify

ReName <- function(strings) {
    s <- tolower(strings)
    gsub("(_|^)(.)", "\\U\\2\\E", s, perl = TRUE)
}
