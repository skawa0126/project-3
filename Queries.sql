CREATE TABLE diabetes_ndcs_wac_increases_2020 (
    year INTEGER,
    oshpd_id VARCHAR(50),
    manufacturer_name VARCHAR(255),
    date_reported DATE,
    ndc_number VARCHAR(20),
    drug_product_description TEXT,
    wac_effective_date DATE,
    wac_increase_amount DECIMAL(15, 2),
    wac_after_increase DECIMAL(15, 2),
    patent_expiration_date DATE,
    drug_source_type VARCHAR(50),
    unit_sales_volume_us BIGINT,
    unit_sales_volume_non_public_indicator BOOLEAN,
    cost_increase_factors TEXT,
    cost_increase_factors_non_public_indicator BOOLEAN,
    change_improvement_description TEXT,
    change_improvement_non_public_indicator BOOLEAN,
    acquisition_date DATE,
    company_acquired_from VARCHAR(255),
    acquisition_price DECIMAL(15, 2),
    acquisition_price_non_public_indicator BOOLEAN,
    acquisition_price_comment TEXT,
    wac_at_acquisition DECIMAL(15, 2),
    wac_year_prior_to_acquisition DECIMAL(15, 2),
    year_drug_introduced_to_market INTEGER,
    wac_at_intro_to_market DECIMAL(15, 2),
    supporting_documents TEXT,
    general_comments TEXT
);

select * from diabetes_ndcs_wac_increases_2020;

ALTER TABLE diabetes_ndcs_wac_increases_2019
DROP CONSTRAINT diabetes_ndcs_wac_increases_2019_ndc_number_fkey;

DELETE FROM diabetes_ndcs_wac_increases_2019
WHERE ndc_number NOT IN (SELECT national_drug_code FROM healthcare_payments_data);


ALTER TABLE diabetes_ndcs_wac_increases_2019
ADD CONSTRAINT diabetes_ndcs_wac_increases_2019_ndc_number_fkey
FOREIGN KEY (ndc_number) REFERENCES healthcare_payments_data(national_drug_code);


ALTER TABLE diabetes_ndcs_wac_increases_2020
DROP CONSTRAINT diabetes_ndcs_wac_increases_2020_ndc_number_fkey;

DELETE FROM diabetes_ndcs_wac_increases_2020
WHERE ndc_number NOT IN (SELECT national_drug_code FROM healthcare_payments_data);


ALTER TABLE diabetes_ndcs_wac_increases_2020
ADD CONSTRAINT diabetes_ndcs_wac_increases_2020_ndc_number_fkey
FOREIGN KEY (ndc_number) REFERENCES healthcare_payments_data(national_drug_code);

CREATE TABLE MCR_D_Spending (
    brand_name VARCHAR(255),
    generic_name VARCHAR(255),
    number_of_manufacturers INT,
    year INT,
    total_spending DECIMAL(15,2),
    total_dosage_units BIGINT,
    total_claims INT,
    total_beneficiaries INT,
    avg_spending_per_dosage_unit DECIMAL(15,2),
    avg_spending_per_claim DECIMAL(15,2),
    avg_spending_per_beneficiary DECIMAL(15,2),
    outlier_flag BOOLEAN,
    change_in_avg_spending DECIMAL(5,2) NULL,
    annual_growth_rate DECIMAL(5,2)
);


select * from MCR_D_Spending;


CREATE TABLE healthcare_payments_data (
    _id INTEGER,
    top25type VARCHAR(50),
    payer_type VARCHAR(50),
    brand_generic VARCHAR(20),
    rank INTEGER,
    national_drug_code VARCHAR(20)PRIMARY KEY,
    drug_name VARCHAR(255),
    numberofprescriptions INTEGER,
    numberofindividuals INTEGER,
    totalcost DECIMAL(15, 2),
    costperprescription DECIMAL(10, 2),
    outofpocketmedian DECIMAL(10, 2)
);

select * from healthcare_payments_data;

CREATE TABLE drug_reference (
    drug_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(255),
    generic_name VARCHAR(255),
    ndc_number VARCHAR(20) UNIQUE
);


-- Populate drug_reference with unique drug names and NDC numbers
INSERT INTO drug_reference (brand_name, generic_name, ndc_number)
SELECT DISTINCT NULL AS brand_name, NULL AS generic_name, ndc_number
FROM diabetes_ndcs_wac_increases_2020;

-- Add brand_name and generic_name from MCR_D_Spending
INSERT INTO drug_reference (brand_name, generic_name)
SELECT DISTINCT brand_name, generic_name
FROM MCR_D_Spending;

ALTER TABLE diabetes_ndcs_wac_increases_2020
ADD COLUMN drug_id INT,
ADD FOREIGN KEY (drug_id) REFERENCES drug_reference(drug_id);

-- Update the foreign key based on NDC number
UPDATE diabetes_ndcs_wac_increases_2020 dn
SET drug_id = (SELECT dr.drug_id FROM drug_reference dr WHERE dn.ndc_number = dr.ndc_number);

--Add drug_id to MCR_D_Spending
ALTER TABLE MCR_D_Spending
ADD COLUMN drug_id INT,
ADD FOREIGN KEY (drug_id) REFERENCES drug_reference(drug_id);

-- Update the foreign key based on brand_name and generic_name
UPDATE MCR_D_Spending ms
SET drug_id = (SELECT dr.drug_id FROM drug_reference dr 
               WHERE ms.brand_name = dr.brand_name AND ms.generic_name = dr.generic_name);

SELECT 
    ms.year, 
    ms.brand_name, 
    dn.ndc_number, 
    dn.drug_product_description, 
    ms.total_spending, 
    dn.wac_increase_amount
FROM 
    MCR_D_Spending ms
JOIN 
    diabetes_ndcs_wac_increases_2020 dn ON ms.drug_id = dn.drug_id
WHERE 
    ms.year BETWEEN 2019 AND 2023;

SELECT 
    ms.year, 
    ms.brand_name, 
    dn.ndc_number, 
    dn.drug_product_description, 
    ms.total_spending, 
    dn.wac_increase_amount
FROM 
    MCR_D_Spending ms
JOIN 
    diabetes_ndcs_wac_increases_2020 dn ON ms.drug_id = dn.drug_id
WHERE 
    ms.year BETWEEN 2019 AND 2023;

select * from drug_reference;

WITH spending_aggregated AS (
    SELECT 
        ms.brand_name,
        SUM(ms.total_spending) AS total_spending_5_years,  -- Aggregate total spending
        SUM(ms.total_dosage_units) AS total_dosage_units_5_years
    FROM 
        MCR_D_Spending ms
    WHERE 
        ms.year BETWEEN 2018 AND 2022  -- Filter for 5-year span
    GROUP BY 
        ms.brand_name
),
spending_per_year AS (
    SELECT 
        ms.brand_name,
        ms.year,
        SUM(ms.total_spending) AS total_spending_per_year,
        SUM(ms.total_dosage_units) AS total_dosage_units_per_year
    FROM 
        MCR_D_Spending ms
    WHERE 
        ms.year BETWEEN 2018 AND 2022
    GROUP BY 
        ms.brand_name, ms.year
)
SELECT 
    sp.brand_name,
	dn.drug_product_description, 
    s_per_year.year AS spending_year,
    dn.year AS wac_year,
    dn.wac_increase_amount,
    dn.wac_after_increase,
    dn.unit_sales_volume_us,
    sp.total_spending_5_years,        -- Aggregated spending for 5 years
    sp.total_dosage_units_5_years,
    s_per_year.total_spending_per_year,  -- Spending for 2020
    s_per_year.total_dosage_units_per_year
FROM 
    spending_per_year s_per_year
LEFT JOIN 
    spending_aggregated sp ON s_per_year.brand_name = sp.brand_name
LEFT JOIN 
    diabetes_ndcs_wac_increases_2020 dn ON 
        dn.drug_product_description ILIKE '%' || sp.brand_name || '%' AND 
        s_per_year.year = 2020   -- Match spending for the specific year
ORDER BY 
    sp.brand_name,                 -- Order by brand_name
    s_per_year.year;              -- Order by year to get instances across years


