CREATE OR ALTER PROCEDURE bronze.load_bronze AS
Begin
	TRUNCATE TABLE bronze.crm_cust_info
	BULK INSERT bronze.crm_cust_info
	FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\cust_info.CSV'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_prd_info
	BULK INSERT bronze.crm_prd_info
	FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\prd_info.CSV'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_sales_details
	BULK INSERT bronze.crm_sales_details
	FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\sales_details.CSV'
	WITH(
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
	);

	TRUNCATE TABLE bronze.erp_cust_az_12
	BULK INSERT bronze.erp_cust_az_12
	FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\CUST_AZ12.CSV'
	WITH(
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
	);

	TRUNCATE TABLE bronze.erp_loc_a101
	BULK INSERT bronze.erp_loc_a101
	FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\LOC_A101.CSV'
	WITH(
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
	);

	TRUNCATE TABLE bronze.erp_px_cat_g1v2
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\PX_CAT_G1V2.CSV'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK 
	);
END; 
