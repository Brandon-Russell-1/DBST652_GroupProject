/* BASIC ORDER DETAILS */
SELECT 
	c.CUSTOMER_ID, 
	c.CUST_FNAME, 
	c.CUST_LNAME, 
	o.ORDER_DATE, 
	d.ORDER_DETAILS_QTY, 
	d.DISCOUNT, 
	i.ITEM_LISTPRICE, 
	i.ITEM_COST, 
	i.ITEM_NAME, 
	t.TYPE_NAME, 
	ROUND((i.ITEM_LISTPRICE - (d.DISCOUNT * i.ITEM_LISTPRICE)),2) AS Sale_price
FROM 
	CUSTOMER c, 
	CUSTOMERORDER o, 
	ORDERDETAILS d, 
	ITEM i, 
	ITEMTYPE t
WHERE 
	c.CUSTOMER_ID = o.CUSTOMER_ID and 
	o.CUSTOMER_ORDER_ID = d.CUSTOMER_ORDER_ID and 
	d.ITEM_ID = i.ITEM_ID and 
	i.ITEM_TYPE_ID = t.ITEM_TYPE_ID;
	
/* Below is an example of how certain reports could be generated to 
determine if a customer should be targeted for sale of a new product.
In this example customers for whom 1 year has passed since thier last
CPU purchase are selected. */

SELECT 
	c.CUSTOMER_ID, 
	c.CUST_FNAME, 
	c.CUST_LNAME, 
	o.ORDER_DATE, 
	d.ORDER_DETAILS_QTY,  
	i.ITEM_NAME, 
	t.TYPE_NAME
FROM 
	CUSTOMER c, 
	CUSTOMERORDER o, 
	ORDERDETAILS d, 
	ITEM i, 
	ITEMTYPE t
WHERE 
	c.CUSTOMER_ID = o.CUSTOMER_ID and 
	o.CUSTOMER_ORDER_ID = d.CUSTOMER_ORDER_ID and 
	d.ITEM_ID = i.ITEM_ID and 
	i.ITEM_TYPE_ID = t.ITEM_TYPE_ID and
	t.ITEM_TYPE_ID = 1 and
	o.ORDER_DATE < ADD_MONTHS(SYSDATE, 12);
	
/* The below query reports the number of items of each product type that have sold
since the product was added to the database compared with the current date, the date
the product was added, and finally the number of days difference between the two. */
	
SELECT 
	i.item_name, 
	a.count AS sold_since_added, 
	i.DATE_ADDED, 
	SYSDATE, (
	ROUND((SYSDATE - i.date_added),0)) AS Difference_in_days
FROM 
	ITEM i,
	(SELECT COUNT(d.item_id) AS count, d.item_id AS itemid
	 FROM orderdetails d
	 GROUP BY d.ITEM_ID) a
WHERE a.itemid = i.item_id;
	
/* The below query reports the most recent sale of each product compared with
the difference in days of that date and the current system date */

SELECT
	d.Item_ID, 
	o.Order_Date AS LAST_DATE_ORDERED, 
	i.Item_Name, 
	(ROUND((SYSDATE - o.Order_Date),0)) AS DAYS_SINCE_LAST_ORDER
FROM 
	OrderDetails d
INNER JOIN 
	CustomerOrder o ON o.customer_order_id=d.customer_order_id
INNER JOIN 
	Item i ON i.Item_ID=d.Item_ID
WHERE 
	o.Order_Date IN (SELECT MAX(x.Order_Date)
                     FROM CustomerOrder x 
					 INNER JOIN OrderDetails y ON y.customer_order_id=x.customer_order_id
                     WHERE y.Item_ID = d.Item_ID )
ORDER BY DAYS_SINCE_LAST_ORDER DESC;
	
