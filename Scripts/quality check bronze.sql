--Check for duplicate values in cst_id field
-- Expectation : No result
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


SELECT
     prd_id,
	 prd_key,
	 REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, 
	 prd_nm,
	 prd_cost,
	 prd_line,
	 prd_start_dt,
	 prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_')  NOT IN
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)

SELECT * FROM bronze.erp_px_cat_g1v2 WHERE id = 'CO_PE';

--Check for Unwanted Spaces
--Expectation : No result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

--crm_prd_info table
SELECT *
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Data Standardization and Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_material_status
FROM bronze.crm_cust_info

SELECT * 
FROM bronze.crm_cust_info;


--crm_prd_info
SELECT * 
FROM bronze.crm_prd_info;

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

--Check for null and negagive number
--Expectation: No result
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0;

--Check for invalid date order
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--Optimizing the invalid date order
SELECT 
prd_id,
prd_key,
prd_nm,
prd_line,
prd_start_dt,
prd_end_dt,
DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS calculated_prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509-B')
