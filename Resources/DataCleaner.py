import pandas as pd

# Load your dataset (adjust the file path or method as needed)
df = pd.read_csv('HealthcarePaymentsData.csv')

# Drop duplicate rows based on 'national_drug_code' and keep only the first occurrence
df_cleaned = df.drop_duplicates(subset=['national_drug_code'], keep=False)

# Save the cleaned dataset back to a CSV file
df_cleaned.to_csv('HealthcarePaymentsData_cleaned.csv', index=False)

print("Cleaning complete. Duplicate rows have been removed.")
