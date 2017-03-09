-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, LastName, CustomerId FROM Customer WHERE Country IS NOT "USA";

-- 2. Provide a query only showing the Customers from Brazil.
SELECT * FROM Customer WHERE Country IS  "Brazil";

-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT c.FirstName || '' || c.LastName AS FullName, i.InvoiceId, i.InvoiceDate, i.BillingCountry FROM Invoice i
JOIN Customer c ON c.CustomerId = i.CustomerId
WHERE c.Country = "Brazil";

-- 4. Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee WHERE Title IS "Sales Support Agent";

-- 5. Provide a query showing a unique list of billing countries from the Invoice table.
SELECT BillingCountry FROM Invoice GROUP BY BillingCountry;

-- 6. Provide a query showing the invoices of customers who are from Brazil.
--SubQueries
SELECT * FROM Invoice i
WHERE i.CustomerId IN
			(SELECT c.CustomerId
			 FROM Customer c
			 WHERE c.Country = "Brazil");

-- 7. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT i.*, e.FirstName || " " || e.LastName AS Employee_Name FROM Invoice i
JOIN Customer c ON c.CustomerId = i.CustomerId
Join Employee e ON e.EmployeeId = c.SupportRepId

-- 8. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT I.Total AS Invoice_Total, c.FirstName || "" || c.LastName AS Customer_Name,
c.Country AS Customer_Country, e.FirstName || "" || e.LastName AS Employee_Name FROM Invoice i
JOIN Customer c ON c.CustomerId = i.CustomerId
Join Employee e ON e.EmployeeID = c.SupportRepId

-- 9. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
SELECT substr(invoiceDate, 1, 4) AS Year, COUNT(invoiceId) AS Total_Invoices, SUM(Total)
FROM Invoice
WHERE (InvoiceDate LIKE '2009%'
OR InvoiceDate LIKE  '2011%' )
GROUP BY Year;

-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceLineId) AS Amount
FROM InvoiceLine il
WHERE il.InvoiceId = 37

-- 11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT COUNT(InvoiceLineId) AS Amount
FROM InvoiceLine il
WHERE il.InvoiceId IN
			(SELECT i.InvoiceId
			FROM Invoice i
			WHERE il.InvoiceId = i.InvoiceId)
GROUP BY il.InvoiceId

-- 12. Provide a query that includes the track name with each invoice line item.
SELECT t.Name, il.* FROM Track t
LEFT JOIN InvoiceLine il
ON il.TrackId = t.TrackId;

-- 13. Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT t.Name AS Song, ar.name AS Artist, il.* FROM Track t
JOIN Album al
ON al.AlbumId = t.AlbumId
JOIN Artist ar
ON ar.ArtistId = al.ArtistId
JOIN InvoiceLine il
ON il.TrackId = t.TrackId;


-- 14. Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT BillingCountry, COUNT(BillingCountry)
AS Invoice_Total
FROM Invoice
GROUP By BillingCountry;

-- 15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
SELECT p.Name AS Playlist_Name, COUNT(pt.TrackId) AS Num_Of_Tracks
FROM PlaylistTrack pt
Left Join Playlist p
WHERE p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId;

-- 16. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT t.Name, t.Composer, t.Milliseconds, t.Bytes, t.UnitPrice, a.title AS Album, g.Name AS Genre, m.Name AS Media_Type
FROM Track t, Album a, Genre g, MediaType m
ON t.AlbumId = a.AlbumId
AND t.GenreId = g.GenreId
AND t.MediaTypeId = m.MediaTypeId;

-- 17. Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.*, COUNT(il.InvoiceId)
FROM Invoice i, InvoiceLine il
ON i.invoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

-- 18. Provide a query that shows total sales made by each sales agent.
SELECT e.FirstName || ' ' || e.LastName AS Employee_Name, COUNT(i.InvoiceId) AS Num_Of_Sales
FROM Invoice i, Customer c, Employee e
ON i.CustomerId = c.CustomerId
AND c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId

-- 19. Which sales agent made the most in sales in 2009?
-- Steve Johnson made the most sales in 2009 with 164.34
SELECT e.FirstName || ' ' || e.LastName AS Employee_Name, SUM(i.Total) AS Sales
FROM Invoice i, Customer c, Employee e
ON i.CustomerId = c.CustomerId
AND c.SupportRepId = e.EmployeeId
WHERE i.InvoiceDate LIKE '2009%'
GROUP BY e.EmployeeId
ORDER BY Sales DESC


-- 20. Which sales agent made the most in sales in 2010?
-- Jane Peacock made the most sales in 2009 with 221.92
SELECT e.FirstName || ' ' || e.LastName AS Employee_Name, SUM(i.Total) AS Sales
FROM Invoice i, Customer c, Employee e
ON i.CustomerId = c.CustomerId
AND c.SupportRepId = e.EmployeeId
WHERE i.InvoiceDate LIKE '2010%'
GROUP BY e.EmployeeId
ORDER BY Sales DESC

-- 21. Which sales agent made the most in sales over all?
-- Jane Peacock made the most sales in 2009 with 833.04
SELECT e.FirstName || ' ' || e.LastName AS Employee_Name, SUM(i.Total) AS Sales
FROM Invoice i, Customer c, Employee e
ON i.CustomerId = c.CustomerId
AND c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId
ORDER BY Sales DESC

-- 22. Provide a query that shows the # of customers assigned to each sales agent.
SELECT e.EmployeeId AS Employee_Id, e.FirstName || ' ' || e.LastName AS Employee_Name, COUNT(c.SupportRepId)
FROM Employee e, Customer c
ON e.EmployeeId = c.SupportRepId
Group By e.EmployeeId;

-- 23. Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT i.BillingCountry AS Country, COUNT(i.BillingCountry) AS Sales, SUM(i.Total) AS Total_Spent
FROM Invoice i
GROUP BY i.BillingCountry
ORDER BY Total_Spent DESC

-- 24. Provide a query that shows the most purchased track of 2013.
SELECT substr(i.InvoiceDate, 1, 4) AS Year, il.InvoiceId, COUNT(t.Name) AS Num_Of_Purchases, t.*
FROM Invoice i, InvoiceLine il, Track t
ON i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
WHERE i.InvoiceDate LIKE '2013%'
GROUP BY t.Name
ORDER BY Num_Of_Purchases DESC;

-- 25. Provide a query that shows the top 5 most purchased tracks over all.
SELECT COUNT(t.Name) AS Num_Of_Purchases, t.Name AS Song_Name
FROM Invoice i, InvoiceLine il, Track t
ON i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY Num_Of_Purchases DESC
LIMIT 5;

-- 26. Provide a query that shows the top 3 best selling artists.
SELECT SUM(i.Total) AS Total, ar.Name
FROM Invoice i, InvoiceLine il, Track t, Album al, Artist ar
ON i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
AND t.AlbumId = al.AlbumId
AND al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId
ORDER BY Total DESC
LIMIT 3;


-- 27. Provide a query that shows the most purchased Media Type.
SELECT COUNT(t.MediaTypeId) AS Total, m.Name
FROM Invoice i, InvoiceLine il, Track t, MediaType m
ON i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
AND t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY Total DESC
LIMIT 1;
--test
