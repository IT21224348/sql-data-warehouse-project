====================================================== dim_customer==========================================================
--Check for duplicate values after joining table
SELECT cst_id,COUNT(*) FROM	
	(SELECT
		 ci.cst_id,
		 ci.cst_key,
		 ci.cst_firstname,
		 ci.cst_lastname,
		 ci.cst_material_status,
		 ci.cst_gndr,
		 ci.cst_create_ddate,
		 ca.bdate,
		 ca.gen,
		 la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az_12 ca 
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*)> 1

--Integrating gender columns

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
    CASE WHEN ci.cst_gndr != 'N/A' THEN cst_gndr     -- CRM table is the master table
	     ELSE COALESCE(ca.gen,'N/A')
		 END AS new_gen
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az_12 ca 
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1,2


=======================================================dim_product========================================================================
--Check for duplicate values after joining table
SELECT prd_key, COUNT(*) FROM (
	SELECT 
		pc.prd_id,
		pc.prd_key,
		pc.prd_nm,
		pc.cat_id,
		px.cat,
		px.subcat,
		px.maintenance,
		pc.prd_cost,
		pc.prd_line,
		pc.prd_start_dt		
	FROM silver.crm_prd_info pc
	LEFT JOIN silver.erp_px_cat_g1v2 px
	ON pc.cat_id = px.id 
	WHERE pc.prd_end_dt IS NULL) T GROUP BY prd_key -- Only consider current data
HAVING COUNT(*) > 1

===========================================================fact_sales==================================================
--Check data integrity (dimensions)
SELECT *
FROM gold.fact_sales gs
LEFT JOIN gold.dim_customers gd
ON  gs.customer_key = gd.customer_key
LEFT JOIN gold.dim_products gp
ON gs.product_key = gp.product_key
WHERE gs.product_key IS NULL
--WHERE gs.customer_key IS NULL
