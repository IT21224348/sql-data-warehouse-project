INSERT INTO silver.crm_cust_info(
   cst_id,
   cst_key,
   cst_firstname,
   cst_lastname,
   cst_material_status,
   cst_gndr,
   cst_create_ddate)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Married'
	 ELSE 'N/A'
END cst_material_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'N/A'
END cst_gndr,
cst_create_ddate
FROM (
    SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_ddate DESC) AS Flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) t
WHERE Flag_last = 1;
