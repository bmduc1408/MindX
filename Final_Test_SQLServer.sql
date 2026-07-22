Create database [Final Test]
Select * from [Dataset - supermarket_sales]
--Câu 1: Liệt kê tổng doanh thu (Total Revenue = Unit Price * Quantity) theo từng chi nhánh và thành phố. 
-- Kết quả cần hiển thị Branch, City, Total Revenue.
Select Branch,City,
Round(Sum(Unit_price*Quantity),2) as [Total Revenue]
From [Dataset - supermarket_sales]
GROUP BY Branch,City

--Câu 2: Tìm 5 sản phẩm có tổng số lượng bán ra nhiều nhất.
-- Kết quả cần hiển thị Product line, Total Quantity Sold
Select TOP 5 WITH TIES Product_line,
Sum(Quantity) as [Total Quantity Sold]
From [Dataset - supermarket_sales]
GROUP BY Product_line
ORDER BY [Total Quantity Sold] DESC

-- Câu 3: Tính tỷ lệ phần trăm doanh thu của từng phương thức thanh toán 
-- so với tổng doanh thu của toàn bộ cửa hàng.
Select Payment,
Round(Sum(Unit_price*Quantity),2) as [Total Revenue],
Format(Sum(Unit_price*Quantity)/SUM(Sum(Unit_price*Quantity)) OVER (),'P2') as [%Payment]
from [Dataset - supermarket_sales]
GROUP BY Payment

-- Câu 4: Xác định ngày có doanh thu cao nhất và thấp nhất trong toàn bộ dữ liệu. 
-- Hiển thị kết quả theo dạng Date, Total Revenue
WITH [RANK of Day] as
(Select [Date],
Round(Sum(Unit_price*Quantity),2) as [Total Revenue],
RANK() OVER (ORDER BY Sum(Unit_price*Quantity) DESC) as [MAX],
RANK() OVER (ORDER BY Sum(Unit_price*Quantity) ASC) as [MIN]
From [Dataset - supermarket_sales]
GROUP BY [Date])
Select [Date],[Total Revenue],
CASE WHEN [MAX]=1 THEN 'MAX Revenue of Day'
ELSE 'MIN Revenue of Day'
END as [NOTE]
FROM [RANK of Day]
WHERE [MAX]=1 OR MIN=1

-- Câu 5: Tìm nhóm khách hàng có giá trị trung bình trên mỗi hóa đơn (Average Order Value = Total Revenue / Số lượng hóa đơn) cao nhất.
--  Hiển thị Customer Type, Average Order Value
Select TOP 1 WITH TIES Customer_Type,
Round(Sum(Unit_price*Quantity)/Count(DISTINCT Invoice_ID),2) as [Average Order Value]
From [Dataset - supermarket_sales]
GROUP BY Customer_Type
ORDER BY [Average Order Value] DESC