CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_material_status AS maritial_status,
CASE WHEN ci.cst_gndr != 'N/A' THEN cst_gndr     -- CRM table is the master table
	 ELSE COALESCE(ca.gen,'N/A')
END AS gender,
     ca.bdate AS birthdate,
     ci.dwh_create_date AS create_date	
FROM  silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az_12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid  
