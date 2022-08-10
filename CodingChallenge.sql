
/* Lesson 4: Putting It All Together */

--4.1. Stacking Table Rows With UNION

/* Exercise 4.1.1
Write a query that selects all rows from the "Purchasing.PurchaseOrderDetail" table where the line total is greater than $10,000. Include the following columns in your output:
	PurchaseOrderID
	PurchaseOrderDetailID
	OrderQty
	LineTotal
*/

SELECT 
	PurchaseOrderID,
	PurchaseOrderDetailID,
	OrderQty,
	LineTotal
FROM Purchasing.PurchaseOrderDetail 
WHERE LineTotal > 10000


/* Exercise 4.1.2
Write a similar query that selects all rows from the "Sales.SalesOrderDetail" table where the line total is greater than $10,000. Include the following columns in your output:

	SalesOrderID
	SalesOrderDetailID
	OrderQty
	LineTotal
*/

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	LineTotal
FROM Sales.SalesOrderDetail
WHERE LineTotal > 10000



/* Exercise 4.1.3
Combine the rows from your Exercise 1 and Exercise 2 queries by "stacking" them vertically. Make sure the similar fields from each table align. Alias the first two columns as "OrderID" and "OrderDetailID", respectively.
*/

SELECT 
	[OrderID] = PurchaseOrderID,
	[OrderDetailID] = PurchaseOrderDetailID,
	OrderQty,
	LineTotal
FROM Purchasing.PurchaseOrderDetail 
WHERE LineTotal > 10000

UNION

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	LineTotal
FROM Sales.SalesOrderDetail
WHERE LineTotal > 10000


/* Exercise 4.1.4

Add the following derived fields to your query; remember , you'll need to add them to both components of your query. Sort the output of your query by line total in descending order.

"RunDate" - displays the current date

"OrderType" - this should display the string "Purchase" for purchase orders, and "Sale" for sales orders.
*/

SELECT 
	[RunDate] = GETDATE(),
	[OrderType] = 'Purchase',
	[OrderID] = PurchaseOrderID,
	[OrderDetailID] = PurchaseOrderDetailID,
	OrderQty,
	LineTotal
FROM Purchasing.PurchaseOrderDetail 
WHERE LineTotal > 10000

UNION

SELECT
	[RunDate] = GETDATE(),
	[OrderType] = 'Sales',
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	LineTotal
FROM Sales.SalesOrderDetail
WHERE LineTotal > 10000



--4.2. Relationships and Normalization



--4.3. JOINs


/* Exercise  4.3.1
Write a query that combines the "FirstName" and "LastName" columns from the "Person.Person" table, with the "EmailAddress" column from the "Person.EmailAddress" table. HINT - these tables have the "BusinessEntityID" field in common.
*/

SELECT 
A.FirstName,
A.LastName,
B.EmailAddress
FROM
Person.Person A
JOIN Person.EmailAddress B
ON A.BusinessEntityID = B.BusinessEntityID


/* Exercise 4.3.2
Write a query that combines the "Name" and "ListPrice" columns from the "Production.Product" table, with the "ReviewerName" and "Comments" columns from the "Production.ProductReview" table. HINT - these tables have the "ProductID" field in common.
*/

SELECT
[Name],
[ListPrice],
ReviewerName,
Comments
FROM
Production.Product A
JOIN Production.ProductReview B
ON A.ProductID = B.ProductID


--4.4. Going Deeper With JOINs

/* Exercise 4.4.1
Write a query that combines the "FirstName" and "LastName" columns from the "Person.Person" table, with the "EmailAddress" column from the "Person.EmailAddress" table, AND the "PhoneNumber" field from the "Person.PersonPhone" table.

HINT - these tables all have the "BusinessEntityID" field in common.
*/

SELECT 
A.FirstName,
A.LastName,
B.EmailAddress,
c.PhoneNumber
FROM
Person.Person A
JOIN Person.EmailAddress B
ON A.BusinessEntityID = B.BusinessEntityID
JOIN Person.PersonPhone C
ON A.BusinessEntityID = C.BusinessEntityID


/* Exercise 4.4.2
Modify your query from Exercise 1 such that you now only pull in phone numbers with a Seattle area code - that is to say, phone numbers that start with "206".

HINT - PhoneNumber is a text field, so you will need a text function to accomplish this. Either LEFT or a wildcard used in conjunction with LIKE should work.
*/

SELECT 
A.FirstName,
A.LastName,
B.EmailAddress,
c.PhoneNumber
FROM
Person.Person A
JOIN Person.EmailAddress B
ON A.BusinessEntityID = B.BusinessEntityID
JOIN Person.PersonPhone C
ON A.BusinessEntityID = C.BusinessEntityID
WHERE LEFT(C.PhoneNumber, 3) = '206'


/* Exercise 4.4.3
Modify your query from Exercise 2 to pull in each person's city from the "Person.Address" table.

Note that this table has no fields in common with any of the tables already in our join. This means we will need to join in another table that we can use as a "bridge" between our Person.Address table and our Person.Person table - a table that should have fields we can use to connect it to either table.

The table we need is "Person.BusinessEntityAddress"; note that it has both "BusinessEntityID" AND "AddressID" fields. You will need to join this table to Person.Person, and then join Person.Address to this table in order to get your query to work.
*/

SELECT 
A.FirstName,
A.LastName,
B.EmailAddress,
C.PhoneNumber,
E.AddressLine1
FROM
Person.Person A
JOIN Person.EmailAddress B
ON A.BusinessEntityID = B.BusinessEntityID
JOIN Person.PersonPhone C
ON A.BusinessEntityID = C.BusinessEntityID
JOIN Person.BusinessEntityAddress D
ON A.BusinessEntityID = D.BusinessEntityID
JOIN Person.Address E 
ON D.AddressID = e.AddressID
WHERE LEFT(C.PhoneNumber, 3) = '206'


--4.5. OUTER JOINs

/* Exercise 4.5.1
Write a query that combines the "BusinessEntityID", "SalesQuota", and "SalesYTD" columns from the "Sales.SalesPerson" table, with the "Name" column from the "Sales.SalesTerritory" table. Alias the "Name" column as "TerritoryName".

Make sure to include all rows from the "Sales.SalesPerson" table regardless of whether a match is found in the "Sales.SalesTerritory" table. I'll leave it to you to determine which field to use to link the two tables together.
*/

SELECT 
	A.BusinessEntityID,
	A.SalesQuota,
	A.SalesYTD,
	[Territory Name] = B.Name 
FROM
Sales.SalesPerson A
LEFT OUTER JOIN Sales.SalesTerritory B
ON A.TerritoryID = B.TerritoryID


/* Exercise 4.5.2
Modify your query from Exercise 1 to only include rows where the YTD sales are less than $2,000,000.
*/

SELECT 
	A.BusinessEntityID,
	A.SalesQuota,
	A.SalesYTD,
	[Territory Name] = B.Name 
FROM
Sales.SalesPerson A
LEFT OUTER JOIN Sales.SalesTerritory B
ON A.TerritoryID = B.TerritoryID
WHERE A.SalesYTD < 2000000


/* Exercise 4.5.3
Change the join in your query from Exercise 2 from an outer join to an inner join, and take note of the effect on the query output. Are the rows with NULL values in the "TerritoryName" column still being included?
*/

SELECT 
	A.BusinessEntityID,
	A.SalesQuota,
	A.SalesYTD,
	[Territory Name] = B.Name 
FROM
Sales.SalesPerson A
INNER JOIN Sales.SalesTerritory B
ON A.TerritoryID = B.TerritoryID
WHERE A.SalesYTD < 2000000

--4.6. Going Deeper OUTER JOINs



/* Exercise 4.6.1

Create a query with the following columns:

SalesOrderID, OrderDate, and TotalDue from the "Sales.SalesOrderHeader" table

A derived column called "Percent of Sales YTD", calculated as follows:

The value in the "TotalDue" column from Sales.SalesOrderHeader, divided by the value in the "SalesYTD" field from the Sales.SalesPerson table, then multiplied by 100.

**You can connect the two tables by their "SalesPersonID" and "BusinessEntityID" fields, respectively.

Return all rows from Sales.SalesOrderHeader that have a total due amount greater than $2,000, regardless of whether there is a sales person associated with the sale. Sort the output by sales order ID, ascending.
*/

SELECT
A.SalesOrderID, 
A.OrderDate,  
A.TotalDue,
[Percent of Sales YTD] = (A.TotalDue / B.SalesYTD) * 100
FROM
Sales.SalesOrderHeader A
LEFT OUTER JOIN Sales.SalesPerson B
ON A.SalesPersonID = B.BusinessEntityID 
WHERE TotalDue > 2000
ORDER BY 1

/* Exercise 4.6.2

Modify your query from  Exercise 1 such that only records from Sales.SalesOrderHeader where the Sales YTD value is less than $2,000,000 are included. The overall number of records returned by your query should not change.
*/

SELECT
A.SalesOrderID, 
A.OrderDate,  
A.TotalDue,
[Percent of Sales YTD] = (A.TotalDue / B.SalesYTD) * 100
FROM
Sales.SalesOrderHeader A
LEFT OUTER JOIN Sales.SalesPerson B
ON A.SalesPersonID = B.BusinessEntityID 
WHERE TotalDue > 2000
ORDER BY 1

/* Exercise 4.6.3

Add the "SalesOrderDetailID" and "LineTotal" columns from the "Sales.SalesOrderDetail" table to your Exercise 2 query. Only include records in your output where a match is found in this query.

I'll leave it to you to figure out which field to join on (it's pretty intuitive).

NOTE - you are likely to find that the record count of your query increases substantially. This is because there is a one to many relationship between Sales.SalesOrderHeader and Sales.SalesOrderDetail, with each sales order being composed of potentially many individual items.
*/

SELECT
A.SalesOrderID, 
A.OrderDate,  
A.TotalDue,
[Percent of Sales YTD] = (A.TotalDue / B.SalesYTD) * 100,
C.SalesOrderDetailID,
C.LineTotal
FROM
Sales.SalesOrderHeader A
LEFT OUTER JOIN Sales.SalesPerson B
ON A.SalesPersonID = B.BusinessEntityID 
INNER JOIN Sales.SalesOrderDetail C
ON A.SalesOrderID = c.SalesOrderID
WHERE TotalDue > 2000
ORDER BY 1


--Coding Challenge 1

    SELECT 
        A.PurchaseOrderID,
        A.PurchaseOrderDetailID,
        A.OrderQty,
        A.UnitPrice,
        A.LineTotal,
        B.OrderDate,
    [OrderSizeCategory] =
        CASE 
            WHEN A.OrderQty > 500 THEN 'Large'
            WHEN A.OrderQty > 50 AND A.OrderQty <= 500 THEN 'Medium'
            ELSE 'Small'
        END,
        [Product Name] = C.Name,
        [Subcategory] = ISNULL(D.Name, 'None'),
        [Category] = ISNULL(E.Name, 'None')
    FROM
    Purchasing.PurchaseOrderDetail A
    JOIN Purchasing.PurchaseOrderHeader B
    ON A.PurchaseOrderID = B.PurchaseOrderID
    JOIN Production.Product C
    ON A.ProductID = C.ProductID
    LEFT OUTER JOIN Production.ProductSubcategory D
    ON C.ProductSubCategoryID = D.ProductSubCategoryID
    LEFT OUTER JOIN Production.ProductCategory E
    ON D.ProductCategoryID = E.ProductCategoryID
    WHERE MONTH(B.OrderDate) = 12

    
SELECT * FROM  Production.ProductCategory 


--Coding Challenge 5
SELECT 
[Today's Date] = GETDATE(),
[first day of the current month] = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1),
[first day of the next month] = DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)),
[last day of the current month] = DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))),
[Days Until EOM] = DATEDIFF(DAY, CAST(GETDATE() AS DATE), DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))))
