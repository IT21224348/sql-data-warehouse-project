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

INSERT INTO silver.crm_prd_info (
    prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, 
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE  UPPER(TRIM(prd_line))
     WHEN 'M' THEN 'Mountain'
     WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'N/A'
END AS prd_line,
prd_start_dt,
DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM bronze.crm_prd_info

