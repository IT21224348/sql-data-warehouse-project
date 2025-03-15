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

--crm_sales_details
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

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

--analysing crm_sales_details table
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

SELECT * 
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT  cst_id FROM silver.crm_cust_info);

--Check for invalid dates
SELECT 
     NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0

SELECT 
     NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt) != 8

SELECT 
     NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > 20500101


SELECT 
     NULLIF(sls_ship_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_ship_dt) != 8 OR LEN(sls_ship_dt) != 8 OR sls_ship_dt > 20500101

SELECT *
FROM bronze.crm_sales_details
WHERE  sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT sls_sales,sls_quantity,sls_price 
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <=0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price

SELECT sls_sales AS old_sls_sales,
       sls_quantity,
       sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
          THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS new_sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=0 
          THEN sls_sales/NULLIF(sls_quantity,0)
     ELSE sls_price
END AS new_sls_price
FROM bronze.crm_sales_details
WHERE sls_price IS NULL OR sls_price <= 0 
--WHERE sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * sls_price


SELECT  * 
FROM bronze.crm_sales_details
