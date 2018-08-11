SELECT d.Item_ID, o.Order_Date, i.Item_Name
  FROM OrderDetails d
    INNER JOIN CustomerOrder o ON o.customer_order_id=d.customer_order_id 
      INNER JOIN Item i ON i.Item_ID=d.Item_ID
        WHERE o.Order_Date IN (SELECT MAX(x.Order_Date)
                        FROM CustomerOrder x INNER JOIN OrderDetails y ON y.customer_order_id=x.customer_order_id
                          WHERE y.Item_ID = d.Item_ID );
                          

SELECT d.Item_ID, o.Order_Date AS LAST_DATE_ORDERED, i.Item_Name, (ROUND((SYSDATE - o.Order_Date),0)) AS DAYS_SINCE_LAST_ORDER
  FROM OrderDetails d
    INNER JOIN CustomerOrder o ON o.customer_order_id=d.customer_order_id
      INNER JOIN Item i ON i.Item_ID=d.Item_ID
        WHERE o.Order_Date IN (SELECT MAX(x.Order_Date)
                                FROM CustomerOrder x 
                                  INNER JOIN OrderDetails y ON y.customer_order_id=x.customer_order_id
                                    WHERE y.Item_ID = d.Item_ID ) ORDER BY DAYS_SINCE_LAST_ORDER DESC;
