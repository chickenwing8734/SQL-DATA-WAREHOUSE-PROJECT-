-- Clearing dublicates
SELECT *
FROM (
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_CREATE_date DESC) as flag_last
FROM bronze.crm_cust_info
)t WHERE flag_last= 1

--Checking for unwanted Spaces
SELECT 
cst_id,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_material_status,
cst_gndr,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
	ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM bronze.crm_cust_info
