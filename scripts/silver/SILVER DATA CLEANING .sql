-- Clearing dublicates
INSERT INTO silver.crm_cust_info (
	cst_id, 
	cst_key, 
	cst_firstname, 
	cst_lastname, 
	cst_marital_status, 
	cst_gndr,
	cst_create_date
)

--Checking for unwanted Spaces
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
--CHANGING MARITAL STATUS INTO READERABLE FORM
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'SINGLE'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'MARRIED'
	ELSE 'N/A'
END cst_material_status,
--CHANGING GENDER INTO READERABLE FORM
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
	ELSE 'N/A'
END cst_gndr,
cst_create_date
-- Clearing dublicates
FROM (
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_CREATE_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t 
WHERE flag_last= 1;




INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_num,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
Select
prd_id,
-- SLIPPING THE PRODUCT KEY INTO CAT ID AND PRODUCT KEY
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
prd_num AS prd_nm,
--REPLACING NULL WITH 0
ISNULL(prd_cost,0) AS Prd_cost,
--CHANGING PRODUCT LINE INTO READERABLE FORM
CASE WHEN TRIM(prd_line) = 'M' THEN 'MOUNTAIN'
	WHEN TRIM(prd_line) = 'R' THEN 'ROAD'
	WHEN TRIM(prd_line) = 'S' THEN 'OTHER SALES'
	WHEN TRIM(prd_line) = 'T' THEN 'TOUIRING'
	ELSE 'N/a'
END AS prd_line,
-- CLEANING THE DATE FOR IT TO ALIGN START DATE WITH END DATE
CAST(prd_start_dt AS DATE) AS prd_start_dt,
DATEADD(day,-1,CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE)) AS prd_end_dt
FROM bronze.crm_prd_info
