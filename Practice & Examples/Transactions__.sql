    /*
    SET IMPLICIT_TRANSACTIONS OFF
    */
    SET IMPLICIT_TRANSACTIONS ON
    
    --BEGIN TRANSACTION  --Uncomment if IMPLICIT_TRANSACTIONS is ON
    
    CREATE TABLE Test (col int)
    
    DROP TABLE Test
    
    SELECT @@TRANCOUNT
    
    BEGIN TRANSACTION
    
    SELECT @@TRANCOUNT
    
    COMMIT
    
    SELECT @@TRANCOUNT
    
    COMMIT
    
    SELECT @@TRANCOUNT
    
    --When IMPLICIT_TRANSACTIONS is ON, SQL will begin a new transaction count here, 
    --You need to explicitly end the transaction at the end
    CREATE TABLE Test (col int)
    
    DROP TABLE Test
    
    SELECT @@TRANCOUNT
    
    IF @@TRANCOUNT > 0
        COMMIT
    
    SELECT @@TRANCOUNT
