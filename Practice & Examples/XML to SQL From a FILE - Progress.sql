select * from expressions

select Text as Word into #Words from Expressions 

select * from #Words


-- Declare a variable to hold the XML content
DECLARE @docs XML;

-- Load the XML file content into the @docs variable using OPENROWSET and BULK
SELECT @docs = CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK 'F:\expressions.xml', SINGLE_BLOB) AS x;
select @docs 


SELECT BulkColumn FROM OPENROWSET(BULK 'F:\expressions.xml', SINGLE_BLOB) AS x;