CREATE TABLE diabetes_ndcs_wac_increases_2019 (
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
    general_comments TEXT,
    FOREIGN KEY (ndc_number) REFERENCES healthcare_payments_data(national_drug_code)
);

ALTER TABLE diabetes_ndcs_wac_increases_2019
DROP CONSTRAINT diabetes_ndcs_wac_increases_2019_ndc_number_fkey;

DELETE FROM diabetes_ndcs_wac_increases_2020
WHERE ndc_number NOT IN (SELECT national_drug_code FROM healthcare_payments_data);


ALTER TABLE diabetes_ndcs_wac_increases_2020
ADD CONSTRAINT diabetes_ndcs_wac_increases_2020_ndc_number_fkey
FOREIGN KEY (ndc_number) REFERENCES healthcare_payments_data(national_drug_code);




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

select