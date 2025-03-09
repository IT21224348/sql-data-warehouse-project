CREATE OR ALTER PROCEDURE bronze.load_bronze AS
Begin
    DECLARE @Start_time DATETIME, @End_time DATETIME
    BEGIN TRY
		PRINT '==================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==================================================================';

		PRINT '------------------------------------------------------------------';
		PRINT 'Loading CRM System';
		PRINT '------------------------------------------------------------------';

		SET @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\cust_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------'

        SET @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\prd_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	    SET @End_time = GETDATE();
		PRINT'Load Duration: '+ CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------';

		SET @Start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\datasets\source_crm\sales_details.CSV'
		WITH(
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
		);
		SET @End_time = GETDATE()
		PRINT 'Load Duration ' + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------';




		PRINT '------------------------------------------------------------------';
		PRINT 'Loading CRM System';
		PRINT '------------------------------------------------------------------';

	    SET @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az_12';
		TRUNCATE TABLE bronze.erp_cust_az_12
		PRINT '>> Inserting Data Into: bronze.erp_cust_az_12';
		BULK INSERT bronze.erp_cust_az_12
		FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\CUST_AZ12.CSV'
		WITH(
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
		);
		SET @End_time = GETDATE()
		PRINT 'Load Duration ' + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------';

        SET @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\LOC_A101.CSV'
		WITH(
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
		);
		SET @End_time = GETDATE()
		PRINT 'Load Duration ' + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------';

		SET @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM'D:\Data Engineering Projects\Data Warehouse Projects\Project 2\Datasets\source_erp\PX_CAT_G1V2.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @End_time = GETDATE()
		PRINT 'Load Duration ' + CAST(DATEDIFF(SECOND,@Start_time,@End_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------';
    END TRY
	BEGIN CATCH
	   PRINT '==================================================================';
	   PRINT 'Error Occured during loading bronze layer';
	   PRINT 'Error Message' + Error_Message();
	   PRINT 'Error Message' + CAST (Error_Number() AS NVARCHAR);
       PRINT 'Error Message' + CAST (Error_State () AS NVARCHAR);
	   PRINT '==================================================================';
	END CATCH
END; 
