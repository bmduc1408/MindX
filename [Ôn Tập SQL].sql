CREATE DATABASE [Ôn Tập SQL]
USE [Ôn Tập SQL]
-- 1. Lấy ra những khách hàng nam có tuổi từ 50 trở lên và hiển thị thêm cột tuổi
SELECT *, YEAR(GETDATE()) - YEAR(Birthday) AS N'Tuổi'
FROM customers
-- 2. Lấy ra những khách hàng có tên bắt đầu bằng L và ở Italy
SELECT *
FROM customers C
WHERE C.Name LIKE 'L%' AND C.Country = 'Italy'
-- 3. Lấy ra những khách hàng ở những khu vực có state code là TX hoặc SA là nữ hoặc khách hàng ở khu vực đó có độ tuổi từ 20 đến 40
SELECT *,YEAR(GETDATE()) - YEAR(C.Birthday) AS N'Tuổi'
FROM customers C
WHERE (C.State_Code = 'TX' OR C.State_Code = 'SA') AND C.Gender = 'Female' OR YEAR(GETDATE()) - YEAR(C.Birthday) BETWEEN 20 AND 40
-- 4. Hãy cho biết những khách hàng đến từ những quốc gia nào, sắp xếp theo thứ tự tăng dần?
SELECT c.Country,
Count(c.NAME) AS N'Số lượng khách hàng'
FROM customers c
GROUP BY c.Country
ORDER BY Count(c.NAME) ASC
-- 5. Hãy cho biết doanh nghiệp đang bán những loại sản phẩm nào (category) thuộc brand nào,sắp xếp theo thứ tự giảm dần brand và tăng dần category?
SELECT DISTINCT Brand,Category,Count(ProductKey) AS N'Số lượng sản phẩm'
FROM products
Group BY Brand,Category
ORDER BY Brand DESC, Category ASC
-- 6. Hãy cho biết brand nào cung cấp Audio (category) đang có số lượng sản phẩm (productkey) nhiều hơn 30 sản phẩm ?
SELECT Category, Brand,
Count(ProductKey) AS N'Số lượng sản phẩm'
FROM products
WHERE Category = 'Audio'
Group BY Category, Brand
HAVING Count(ProductKey) > 30
-- 7. Hãy tính doanh thu theo từng ngày
SELECT S.Order_Date, 
SUM(S.Quantity * P.Unit_Price_USD) AS N'Doanh thu (USD)'
FROM sales S
JOIN PRODUCTS P ON S.ProductKey = P.ProductKey
GROUP BY S.Order_Date
ORDER BY S.Order_Date
-- 8. Hãy cho biết tên sản phẩm có doanh thu (USD) thấp hơn doanh thu trung bình của từng cửa hàng (store)
WITH ProductSales AS
    (SELECT P.Product_Name, S.StoreKey,
Sum(P.Unit_Cost_USD * S.Quantity) AS Sum_P
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.Product_Name, S.StoreKey),
AVG_S AS
    (SELECT Product_Name,StoreKey, Sum_P,
    AVG(Sum_P) OVER (PARTITION BY Storekey) AS AVG_Shop
    FROM ProductSales)
SELECT Product_Name, StoreKey, Sum_P, AVG_shop
From AVG_S
WHERE Sum_P < AVG_shop
-- 9. Hãy cho biết, khách hàng nữ nào có số lượng đơn hàng ít nhất ở khu vực có state_code là WA
SELECT Top 1 with TIES C.Name, COUNT(S.Quantity) AS N'Số lượng đơn hàng'
FROM customers C
JOIN sales S ON C.CustomerKey = S.CustomerKey
WHERE C.Gender = 'Female' AND C.State_Code = 'WA'
GROUP BY C.Name
ORDER BY COUNT(S.Quantity) ASC