BEGIN TRY
    BEGIN TRAN
        SELECT 5 / 0
        UPDATE products SET price = 30.00 WHERE productid = 1
        SELECT 'Transaction run to the end'
    COMMIT
END		
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
    SELECT ERROR_MESSAGE() AS ErrorMessage
END CATCH

SELECT * FROM products WHERE productid = 1

-- Find the blocking transaction
SELECT * FROM sys.dm_tran_active_transactions

