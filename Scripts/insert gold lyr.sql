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

CREATE VIEW gold.dim_products AS
SELECT 
        ROW_NUMBER() OVER (ORDER BY pc.prd_start_dt,pc.prd_key) AS product_key,
		pc.prd_id AS product_id,
		pc.prd_key AS product_number,
		pc.prd_nm AS product_name,
		pc.cat_id AS category_id,
		px.cat AS category,
		px.subcat AS subcategory,
		px.maintenance,
		pc.prd_cost AS cost,
		pc.prd_line AS product_line,
		pc.prd_start_dt AS start_date		
	FROM silver.crm_prd_info pc
	LEFT JOIN silver.erp_px_cat_g1v2 px
	ON pc.cat_id = px.id 
	WHERE pc.prd_end_dt IS NULL

CREATE VIEW gold.fact_sales AS
SELECT 
      sd.sls_ord_num AS order_number,
	  pr.product_key,
	  cu.customer_key,
	  sd.sls_order_dt AS order_date,
	  sd.sls_ship_dt AS shipping_date,
	  sd.sls_due_dt AS due_date,
	  sd.sls_sales AS sales_amount,
	  sd.sls_quantity AS quantity,
	  sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id


SELECT * FROM gold.fact_sales
