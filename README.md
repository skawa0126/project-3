# Project Title:  Prescription Drug Price Transparency Pipeline

## Purpose:
The Prescription Drug Price Transparency Pipeline project aims to optimize the extraction, transformation, and loading (ETL) processes for prescription drug pricing data sourced from the California Health and Human Services Agency (CHHS), Food and Drug Administration (FDA) and Bureau of Labor Statistics (BLS).  By improving the efficiency and reliability of these data pipelines, we will enhance the quality of insights regarding prescription drug prices and their impact on healthcare affordability.  This project emphasizes the automation of data workflows, reducing of processing times, and maintenance of data integrity across various sources, ultimately promoting transparency in drug pricing and enabling policymakers, healthcare providers, and consumers to make well-informed decisions.

## Objectives:
- Analyze Current Data Sources: Assess the prescription drug pricing data from CHHS, FDA, and BLS to understand their structures and formats.
- Design the ETL Pipeline: Create a blueprint for the ETL process, outlining the steps for extraction, transformation, and loading of the data.
- Implement Automation: Develop automated workflows to streamline the ETL process and reduce manual work
- Enhance Data Quality: Incorporate validation checks and error-handling mechanisms to ensure accurate and reliable data
- Document the Process: Produce thorough documentation detailing the ETL workflow, tools used, and best practices for future reference.

## Target Audience:
Policymakers, healthcare providers, and consumers

## Timeline:
The project will be executed over 3 weeks, divided into phases: development, exploration and cleanup, and analysis.

## Expected Outcome:
- Streamlined ETL Process:  A fully functional ETL pipeline that efficiently extracts, transforms, and loads prescription drug pricing data from the specified sources.
- Improved Data Accuracy: Enhanced data quality through validation checks and error handling, ensuring reliable insights into drug pricing.
- Faster Processing Times: Significant reduction in data processing times, enabling quicker access to up-to-date information.
- Comprehensive Documentation: Detailed documentation of the ETL process, including workflow diagrams, to facilitate understanding and future modifications.
- Hands-On Learning Experience: Valuable practical experience in data engineering, including the application of tools and techniques relevant to ETL processes.

## Instructions on how to use and interact with the project:
1.	Extract:
    - Download the CHHS Prescription Drug WAC Increases dataset
    - Fetch data from FDA National Drug Code Directory API
    - Pull Medicare Part D formulary data
    - Retrieve CPI data for healthcare and general consumer goods
2.	Transform:
    - Clean and standardize drug names and NDC codes across datasets
3.	Load:
    - Store processed data in a PostgreSQL database with tables for:
        - Drugs: Basic drug information and NDC codes
        - PriceHistory: Historical WAC prices and increase data
        - Manufacturers: Information on drug manufacturers
        - PriceAnalysis: Calculated metrics on price increases and comparisons
4.	Analyze:
    - Calculate percentage and absolute price increases over time
    - Categorize drugs by therapeutic class and manufacturer
    - Compare drug price increases to CPI increases
    - Identify Drugs with the highest and most frequent price hikes
    - Calculate potential impact on consumer out-of-pocket costs


## Additional Components:
- Python & SQL Alchemy for ETL orchestration
- Create a Flask API to query the database for drug pricing information
- Develop a Streamlit dashboard for visualizing drug price trends and impacts

## Ethical Considerations:
This project prioritizes several key ethical considerations to ensure responsible handling of prescription drug pricing data. First, we aim to ensure data accuracy and provide context for the reasons behind price increases, highlighting their potential impacts on patient access to medications. We will address the balance between the costs of drug innovation and the need for affordability, ensuring that all perspectives are considered. Additionally, the project will include resources for consumers to identify lower-cost alternatives, promoting informed decision-making. As we handle data from multiple sources, including government datasets, we remain committed to addressing critical healthcare issues, particularly drug pricing transparency. Lastly, ethical considerations will be integral to our data presentation and interpretation, ensuring clarity and integrity in the insights we provide.


## References for the data source(s):
- California Health and Human Services Agency – Prescription Drug WAC Increases dataset
- Food and Drug Administration – National Drug Code Directory 
- Bureau of Labor Statistics – Consumer Price Index

## References for any code used:
