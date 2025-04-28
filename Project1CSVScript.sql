CREATE OR REPLACE VIEW hmda_recreated_csv AS
SELECT
    a.as_of_year,
    a.respondent_id,
    ac.agency_name,
    ac.agency_abbr,
    ac.agency_code,
    lt.loan_type_name,
    lt.loan_type,
    pt.property_type_name,
    pt.property_type,
    lp.loan_purpose_name,
    lp.loan_purpose,
    oo.owner_occupancy_name,
    oo.owner_occupancy,
    COALESCE(l.loan_amount_000s::TEXT, '') AS loan_amount_000s,
    pr.preapproval_name,
    COALESCE(pr.preapproval, '') AS preapproval,
    at.action_taken_name,
    at.action_taken,
    COALESCE(g.msamd_name, '') AS msamd_name,
    COALESCE(g.msamd, '') AS msamd,
    COALESCE(g.state_name, '') AS state_name,
    COALESCE(g.state_abbr, '') AS state_abbr,
    COALESCE(g.state_code, '') AS state_code,
    COALESCE(g.county_name, '') AS county_name,
    COALESCE(g.county_code, '') AS county_code,
    COALESCE(g.census_tract_number, '') AS census_tract_number,
    COALESCE(ap.applicant_ethnicity_name, '') AS applicant_ethnicity_name,
    COALESCE(ap.applicant_ethnicity, '') AS applicant_ethnicity,
    COALESCE(ap.co_applicant_ethnicity_name, '') AS co_applicant_ethnicity_name,
    COALESCE(ap.co_applicant_ethnicity, '') AS co_applicant_ethnicity,
    COALESCE(ap.applicant_race_name_1, '') AS applicant_race_name_1,
    COALESCE(ap.applicant_race_1, '') AS applicant_race_1,
    '' AS applicant_race_name_2,
    '' AS applicant_race_2,
    '' AS applicant_race_name_3,
    '' AS applicant_race_3,
    '' AS applicant_race_name_4,
    '' AS applicant_race_4,
    '' AS applicant_race_name_5,
    '' AS applicant_race_5,
    COALESCE(ap.co_applicant_race_name_1, '') AS co_applicant_race_name_1,
    COALESCE(ap.co_applicant_race_1, '') AS co_applicant_race_1,
    '' AS co_applicant_race_name_2,
    '' AS co_applicant_race_2,
    '' AS co_applicant_race_name_3,
    '' AS co_applicant_race_3,
    '' AS co_applicant_race_name_4,
    '' AS co_applicant_race_4,
    '' AS co_applicant_race_name_5,
    '' AS co_applicant_race_5,
    COALESCE(ap.applicant_sex_name, '') AS applicant_sex_name,
    COALESCE(ap.applicant_sex, '') AS applicant_sex,
    COALESCE(ap.co_applicant_sex_name, '') AS co_applicant_sex_name,
    COALESCE(ap.co_applicant_sex, '') AS co_applicant_sex,
    COALESCE(ap.applicant_income_000s::TEXT, '') AS applicant_income_000s,
    ptype.purchaser_type_name,
    COALESCE(l.purchaser_type, '') AS purchaser_type,
    dr1.denial_reason_name AS denial_reason_name_1,
    COALESCE(l.denial_reason_1, '') AS denial_reason_1,
    dr2.denial_reason_name AS denial_reason_name_2,
    COALESCE(l.denial_reason_2, '') AS denial_reason_2,
    dr3.denial_reason_name AS denial_reason_name_3,
    COALESCE(l.denial_reason_3, '') AS denial_reason_3,
    COALESCE(l.rate_spread, '') AS rate_spread,
    hs.hoepa_status_name,
    COALESCE(l.hoepa_status, '') AS hoepa_status,
    ls.lien_status_name,
    COALESCE(l.lien_status, '') AS lien_status,
    COALESCE(a.edit_status_name, '') AS edit_status_name,
    COALESCE(a.edit_status, '') AS edit_status,
    COALESCE(a.sequence_number, '') AS sequence_number,
    COALESCE(g.population::TEXT, '') AS population,
    COALESCE(g.minority_population::TEXT, '') AS minority_population,
    COALESCE(g.hud_median_family_income::TEXT, '') AS hud_median_family_income,
    COALESCE(g.tract_to_msamd_income::TEXT, '') AS tract_to_msamd_income,
    COALESCE(g.number_of_owner_occupied_units::TEXT, '') AS number_of_owner_occupied_units,
    COALESCE(g.number_of_1_to_4_family_units::TEXT, '') AS number_of_1_to_4_family_units,
    COALESCE(a.application_date_indicator, '') AS application_date_indicator
FROM
    applications a
    JOIN agencies ac ON a.agency_id = ac.agency_id
    LEFT JOIN loan_details l ON a.loan_id = l.loan_id
    LEFT JOIN loan_types lt ON l.loan_type = lt.loan_type
    LEFT JOIN property_types pt ON l.property_type = pt.property_type
    LEFT JOIN loan_purposes lp ON l.loan_purpose = lp.loan_purpose
    LEFT JOIN owner_occupancies oo ON l.owner_occupancy = oo.owner_occupancy
    LEFT JOIN preapprovals pr ON l.preapproval = pr.preapproval
    LEFT JOIN action_taken at ON l.action_taken = at.action_taken
    LEFT JOIN purchaser_types ptype ON l.purchaser_type = ptype.purchaser_type
    LEFT JOIN hoepa_statuses hs ON l.hoepa_status = hs.hoepa_status
    LEFT JOIN lien_statuses ls ON l.lien_status = ls.lien_status
    LEFT JOIN geographic_data g ON a.geo_id = g.geo_id
    LEFT JOIN applicants ap ON a.applicant_id = ap.applicant_id
    LEFT JOIN denial_reasons dr1 ON l.denial_reason_1 = dr1.denial_reason
    LEFT JOIN denial_reasons dr2 ON l.denial_reason_2 = dr2.denial_reason
    LEFT JOIN denial_reasons dr3 ON l.denial_reason_3 = dr3.denial_reason
ORDER BY
    a.application_id;

\copy (SELECT * FROM hmda_recreated_csv) TO 'hmda_data.csv' WITH CSV HEADER;