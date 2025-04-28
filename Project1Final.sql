CREATE TABLE agency_codes
(
    agency_code TEXT PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_abbr TEXT NOT NULL
);

CREATE TABLE loan_types
(
    loan_type TEXT PRIMARY KEY,
    loan_type_name TEXT NOT NULL
);

CREATE TABLE property_types
(
    property_type TEXT PRIMARY KEY,
    property_type_name TEXT NOT NULL
);

CREATE TABLE loan_purposes
(
    loan_purpose TEXT PRIMARY KEY,
    loan_purpose_name TEXT NOT NULL
);

CREATE TABLE owner_occupancies
(
    owner_occupancy TEXT PRIMARY KEY,
    owner_occupancy_name TEXT NOT NULL
);

CREATE TABLE preapprovals
(
    preapproval TEXT PRIMARY KEY,
    preapproval_name TEXT NOT NULL
);

CREATE TABLE action_taken
(
    action_taken TEXT PRIMARY KEY,
    action_taken_name TEXT NOT NULL
);

CREATE TABLE purchaser_types
(
    purchaser_type TEXT PRIMARY KEY,
    purchaser_type_name TEXT NOT NULL
);

CREATE TABLE denial_reasons
(
    denial_reason TEXT PRIMARY KEY,
    denial_reason_name TEXT NOT NULL
);

CREATE TABLE hoepa_statuses
(
    hoepa_status TEXT PRIMARY KEY,
    hoepa_status_name TEXT NOT NULL
);

CREATE TABLE lien_statuses
(
    lien_status TEXT PRIMARY KEY,
    lien_status_name TEXT NOT NULL
);

CREATE TABLE edit_statuses
(
    edit_status TEXT PRIMARY KEY,
    edit_status_name TEXT NOT NULL
);

CREATE TABLE ethnicities
(
    ethnicity TEXT PRIMARY KEY,
    ethnicity_name TEXT NOT NULL
);

CREATE TABLE races
(
    race TEXT PRIMARY KEY,
    race_name TEXT NOT NULL
);

CREATE TABLE sexes
(
    sex TEXT PRIMARY KEY,
    sex_name TEXT NOT NULL
);

CREATE TABLE states
(
    state_code TEXT PRIMARY KEY,
    state_name TEXT NOT NULL,
    state_abbr TEXT NOT NULL
);

CREATE TABLE counties
(
    county_code TEXT NOT NULL,
    state_code TEXT NOT NULL,
    county_name TEXT NOT NULL,
    PRIMARY KEY (county_code, state_code),
    FOREIGN KEY (state_code) REFERENCES states(state_code)
);

CREATE TABLE msamds
(
    msamd TEXT PRIMARY KEY,
    msamd_name TEXT NOT NULL
);

CREATE TABLE census_tracts
(
    census_tract_number TEXT NOT NULL,
    county_code TEXT NOT NULL,
    state_code TEXT NOT NULL,
    msamd TEXT,
    population NUMERIC,
    minority_population NUMERIC,
    hud_median_family_income NUMERIC,
    tract_to_msamd_income NUMERIC,
    number_of_owner_occupied_units NUMERIC,
    number_of_1_to_4_family_units NUMERIC,
    PRIMARY KEY (census_tract_number, county_code, state_code),
    FOREIGN KEY (county_code, state_code) REFERENCES counties(county_code, state_code),
    FOREIGN KEY (msamd) REFERENCES msamds(msamd)
);

CREATE TABLE applicants
(
    applicant_id SERIAL PRIMARY KEY,
    ethnicity TEXT,
    income NUMERIC,
    sex TEXT,
    FOREIGN KEY (ethnicity) REFERENCES ethnicities(ethnicity),
    FOREIGN KEY (sex) REFERENCES sexes(sex)
);

CREATE TABLE co_applicants
(
    co_applicant_id SERIAL PRIMARY KEY,
    ethnicity TEXT,
    sex TEXT,
    FOREIGN KEY (ethnicity) REFERENCES ethnicities(ethnicity),
    FOREIGN KEY (sex) REFERENCES sexes(sex)
);

CREATE TABLE applications
(
    application_id INTEGER PRIMARY KEY,
    as_of_year INTEGER NOT NULL,
    respondent_id TEXT NOT NULL,
    agency_code TEXT NOT NULL,
    geo_id INTEGER,
    applicant_id INTEGER NOT NULL,
    co_applicant_id INTEGER,
    edit_status TEXT,
    sequence_number TEXT,
    application_date_indicator TEXT,
    FOREIGN KEY (agency_code) REFERENCES agency_codes(agency_code),
    FOREIGN KEY (geo_id) REFERENCES geographic_locations(geo_id),
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id),
    FOREIGN KEY (co_applicant_id) REFERENCES co_applicants(co_applicant_id),
    FOREIGN KEY (edit_status) REFERENCES edit_statuses(edit_status)
);

CREATE TABLE geographic_locations
(
    geo_id SERIAL PRIMARY KEY,
    census_tract_number TEXT,
    county_code TEXT,
    state_code TEXT,
    msamd TEXT,
    FOREIGN KEY (census_tract_number, county_code, state_code) 
        REFERENCES census_tracts(census_tract_number, county_code, state_code),
    FOREIGN KEY (msamd) REFERENCES msamds(msamd)
);

CREATE TABLE loans
(
    loan_id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    loan_type TEXT NOT NULL,
    property_type TEXT NOT NULL,
    loan_purpose TEXT NOT NULL,
    owner_occupancy TEXT NOT NULL,
    loan_amount NUMERIC,
    preapproval TEXT,
    action_taken TEXT NOT NULL,
    purchaser_type TEXT,
    rate_spread TEXT,
    hoepa_status TEXT,
    lien_status TEXT,
    FOREIGN KEY (application_id) REFERENCES applications(application_id),
    FOREIGN KEY (loan_type) REFERENCES loan_types(loan_type),
    FOREIGN KEY (property_type) REFERENCES property_types(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES loan_purposes(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES owner_occupancies(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES preapprovals(preapproval),
    FOREIGN KEY (action_taken) REFERENCES action_taken(action_taken),
    FOREIGN KEY (purchaser_type) REFERENCES purchaser_types(purchaser_type),
    FOREIGN KEY (hoepa_status) REFERENCES hoepa_statuses(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES lien_statuses(lien_status)
);

CREATE TABLE applicant_races
(
    applicant_id INTEGER NOT NULL,
    race TEXT NOT NULL,
    PRIMARY KEY (applicant_id, race),
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id),
    FOREIGN KEY (race) REFERENCES races(race)
);

CREATE TABLE co_applicant_races
(
    co_applicant_id INTEGER NOT NULL,
    race TEXT NOT NULL,
    PRIMARY KEY (co_applicant_id, race),
    FOREIGN KEY (co_applicant_id) REFERENCES co_applicants(co_applicant_id),
    FOREIGN KEY (race) REFERENCES races(race)
);

CREATE TABLE loan_denial_reasons
(
    loan_id INTEGER NOT NULL,
    denial_reason TEXT NOT NULL,
    reason_order INTEGER NOT NULL,
    PRIMARY KEY (loan_id, reason_order),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    FOREIGN KEY (denial_reason) REFERENCES denial_reasons(denial_reason)
);

CREATE TABLE null_values
(
    edit_status_name TEXT,
    edit_status TEXT,
    sequence_number TEXT,
    application_date_indicator TEXT,
    id SERIAL PRIMARY KEY
);

INSERT INTO null_values
    (edit_status_name, edit_status, sequence_number, application_date_indicator)
VALUES
    (NULL, NULL, NULL, NULL);

INSERT INTO agency_codes
    (agency_code, agency_name, agency_abbr)
SELECT DISTINCT agency_code, agency_name, agency_abbr
FROM preliminary
WHERE agency_code != '';

INSERT INTO loan_types
    (loan_type, loan_type_name)
SELECT DISTINCT loan_type, loan_type_name
FROM preliminary
WHERE loan_type != '';

INSERT INTO property_types
    (property_type, property_type_name)
SELECT DISTINCT property_type, property_type_name
FROM preliminary
WHERE property_type != '';

INSERT INTO loan_purposes
    (loan_purpose, loan_purpose_name)
SELECT DISTINCT loan_purpose, loan_purpose_name
FROM preliminary
WHERE loan_purpose != '';

INSERT INTO owner_occupancies
    (owner_occupancy, owner_occupancy_name)
SELECT DISTINCT owner_occupancy, owner_occupancy_name
FROM preliminary
WHERE owner_occupancy != '';

INSERT INTO preapprovals
    (preapproval, preapproval_name)
SELECT DISTINCT preapproval, preapproval_name
FROM preliminary
WHERE preapproval != '';

INSERT INTO action_taken
    (action_taken, action_taken_name)
SELECT DISTINCT action_taken, action_taken_name
FROM preliminary
WHERE action_taken != '';

INSERT INTO purchaser_types
    (purchaser_type, purchaser_type_name)
SELECT DISTINCT purchaser_type, purchaser_type_name
FROM preliminary
WHERE purchaser_type != '';

INSERT INTO denial_reasons
    (denial_reason, denial_reason_name)
    SELECT DISTINCT denial_reason_1, denial_reason_name_1
    FROM preliminary
    WHERE denial_reason_1 != ''
UNION
    SELECT DISTINCT denial_reason_2, denial_reason_name_2
    FROM preliminary
    WHERE denial_reason_2 != ''
UNION
    SELECT DISTINCT denial_reason_3, denial_reason_name_3
    FROM preliminary
    WHERE denial_reason_3 != '';

INSERT INTO hoepa_statuses
    (hoepa_status, hoepa_status_name)
SELECT DISTINCT hoepa_status, hoepa_status_name
FROM preliminary
WHERE hoepa_status != '';

INSERT INTO lien_statuses
    (lien_status, lien_status_name)
SELECT DISTINCT lien_status, lien_status_name
FROM preliminary
WHERE lien_status != '';

INSERT INTO edit_statuses
    (edit_status, edit_status_name)
SELECT DISTINCT edit_status, edit_status_name
FROM preliminary
WHERE edit_status != '';

INSERT INTO ethnicities
    (ethnicity, ethnicity_name)
    SELECT DISTINCT applicant_ethnicity, applicant_ethnicity_name
    FROM preliminary
    WHERE applicant_ethnicity != ''
UNION
    SELECT DISTINCT co_applicant_ethnicity, co_applicant_ethnicity_name
    FROM preliminary
    WHERE co_applicant_ethnicity != '';

INSERT INTO races
    (race, race_name)
    SELECT DISTINCT applicant_race_1, applicant_race_name_1
    FROM preliminary
    WHERE applicant_race_1 != ''
UNION
    SELECT DISTINCT co_applicant_race_1, co_applicant_race_name_1
    FROM preliminary
    WHERE co_applicant_race_1 != '';

INSERT INTO sexes
    (sex, sex_name)
    SELECT DISTINCT applicant_sex, applicant_sex_name
    FROM preliminary
    WHERE applicant_sex != ''
UNION
    SELECT DISTINCT co_applicant_sex, co_applicant_sex_name
    FROM preliminary
    WHERE co_applicant_sex != '';

INSERT INTO states
    (state_code, state_name, state_abbr)
SELECT DISTINCT state_code, state_name, state_abbr
FROM preliminary
WHERE state_code != '';

INSERT INTO counties
    (county_code, state_code, county_name)
SELECT DISTINCT county_code, state_code, county_name
FROM preliminary
WHERE county_code != '' AND state_code != '';

INSERT INTO msamds
    (msamd, msamd_name)
SELECT DISTINCT msamd, msamd_name
FROM preliminary
WHERE msamd != '';

INSERT INTO census_tracts
    (
    census_tract_number, county_code, state_code, msamd,
    population, minority_population, hud_median_family_income,
    tract_to_msamd_income, number_of_owner_occupied_units,
    number_of_1_to_4_family_units
    )
SELECT DISTINCT
    census_tract_number, county_code, state_code, msamd,
    NULLIF(population, '')::NUMERIC,
    NULLIF(minority_population, '')::NUMERIC,
    NULLIF(hud_median_family_income, '')::NUMERIC,
    NULLIF(tract_to_msamd_income, '')::NUMERIC,
    NULLIF(number_of_owner_occupied_units, '')::NUMERIC,
    NULLIF(number_of_1_to_4_family_units, '')::NUMERIC
FROM preliminary 
WHERE
(census_tract_number != '' OR msamd != '' OR state_code != '' OR county_code != '');

INSERT INTO geographic_locations
    (census_tract_number, county_code, state_code, msamd)
SELECT DISTINCT
    NULLIF(census_tract_number, ''),
    NULLIF(county_code, ''),
    NULLIF(state_code, ''),
    NULLIF(msamd, '')
FROM preliminary
WHERE (census_tract_number != '' OR msamd != '' OR state_code != '' OR county_code != '');

INSERT INTO applicants
    (ethnicity, income, sex)
SELECT DISTINCT
    NULLIF(applicant_ethnicity, ''),
    NULLIF(applicant_income_000s, '')::NUMERIC,
    NULLIF(applicant_sex, '')
FROM preliminary
WHERE
(applicant_ethnicity != '' OR applicant_sex != '' OR applicant_income_000s != '');

INSERT INTO applicant_races
    (applicant_id, race)
SELECT a.applicant_id, p.applicant_race_1
FROM applicants a
    JOIN preliminary p ON 
    (a.ethnicity = p.applicant_ethnicity OR (a.ethnicity IS NULL AND p.applicant_ethnicity = ''))
        AND (a.sex = p.applicant_sex OR (a.sex IS NULL AND p.applicant_sex = ''))
        AND (a.income::TEXT = p.applicant_income_000s OR (a.income IS NULL AND p.applicant_income_000s = ''))
WHERE p.applicant_race_1 != '';

INSERT INTO co_applicants
    (ethnicity, sex)
SELECT DISTINCT
    NULLIF(co_applicant_ethnicity, ''),
    NULLIF(co_applicant_sex, '')
FROM preliminary
WHERE (co_applicant_ethnicity != '' OR co_applicant_sex != '');

INSERT INTO co_applicant_races
    (co_applicant_id, race)
SELECT c.co_applicant_id, p.co_applicant_race_1
FROM co_applicants c
    JOIN preliminary p ON 
    (c.ethnicity = p.co_applicant_ethnicity OR (c.ethnicity IS NULL AND p.co_applicant_ethnicity = ''))
        AND (c.sex = p.co_applicant_sex OR (c.sex IS NULL AND p.co_applicant_sex = ''))
WHERE p.co_applicant_race_1 != '';

INSERT INTO applications
    (
    application_id, as_of_year, respondent_id, agency_code, geo_id,
    applicant_id, co_applicant_id, edit_status, sequence_number, application_date_indicator
    )
SELECT
    p.id::INTEGER,
    p.as_of_year::INTEGER,
    p.respondent_id,
    p.agency_code,
    g.geo_id,
    a.applicant_id,
    c.co_applicant_id,
    NULLIF(p.edit_status, ''),
    NULLIF(p.sequence_number, ''),
    NULLIF(p.application_date_indicator, '')
FROM preliminary p
    LEFT JOIN applicants a ON 
    (a.ethnicity = p.applicant_ethnicity OR (a.ethnicity IS NULL AND p.applicant_ethnicity = ''))
        AND (a.sex = p.applicant_sex OR (a.sex IS NULL AND p.applicant_sex = ''))
        AND (a.income::TEXT = p.applicant_income_000s OR (a.income IS NULL AND p.applicant_income_000s = ''))
    LEFT JOIN co_applicants c ON 
    (c.ethnicity = p.co_applicant_ethnicity OR (c.ethnicity IS NULL AND p.co_applicant_ethnicity = ''))
        AND (c.sex = p.co_applicant_sex OR (c.sex IS NULL AND p.co_applicant_sex = ''))
    LEFT JOIN geographic_locations g ON 
    (g.census_tract_number = p.census_tract_number OR (g.census_tract_number IS NULL AND p.census_tract_number = ''))
        AND (g.county_code = p.county_code OR (g.county_code IS NULL AND p.county_code = ''))
        AND (g.state_code = p.state_code OR (g.state_code IS NULL AND p.state_code = ''))
        AND (g.msamd = p.msamd OR (g.msamd IS NULL AND p.msamd = ''));

INSERT INTO loans
    (
    application_id, loan_type, property_type, loan_purpose, owner_occupancy,
    loan_amount, preapproval, action_taken, purchaser_type, rate_spread,
    hoepa_status, lien_status
    )
SELECT
    p.id::INTEGER,
    p.loan_type,
    p.property_type,
    p.loan_purpose,
    p.owner_occupancy,
    NULLIF(p.loan_amount_000s, '')::NUMERIC,
    NULLIF(p.preapproval, ''),
    p.action_taken,
    NULLIF(p.purchaser_type, ''),
    NULLIF(p.rate_spread, ''),
    NULLIF(p.hoepa_status, ''),
    NULLIF(p.lien_status, '')
FROM preliminary p;

INSERT INTO loan_denial_reasons
    (loan_id, denial_reason, reason_order)
SELECT
    l.loan_id, p.denial_reason_1, 1
FROM loans l
    JOIN preliminary p ON l.application_id = p.id::INTEGER
WHERE p.denial_reason_1 != '';

INSERT INTO loan_denial_reasons
    (loan_id, denial_reason, reason_order)
SELECT
    l.loan_id, p.denial_reason_2, 2
FROM loans l
    JOIN preliminary p ON l.application_id = p.id::INTEGER
WHERE p.denial_reason_2 != '';

INSERT INTO loan_denial_reasons
    (loan_id, denial_reason, reason_order)
SELECT
    l.loan_id, p.denial_reason_3, 3
FROM loans l
    JOIN preliminary p ON l.application_id = p.id::INTEGER
WHERE p.denial_reason_3 != '';