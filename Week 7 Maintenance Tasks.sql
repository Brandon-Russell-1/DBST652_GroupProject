/* 3/19/2016 - RLS
 Database maintenance tasks to boost performance in searches and add some functionality */

-- Adding indexes on commonly searched fields
CREATE INDEX in_orderdate on CustomerOrder(Order_Date);
CREATE INDEX in_cost on Item(Item_Cost);

/* Stored procedure to deduct inventory after customer purchases
 This will be invoked by the front-end application, and is
 an alternative to a trigger. Performance would improve over a 
 trigger due to it not being run after every update on table ITEM */
CREATE OR REPLACE PROCEDURE remove_inventory 
(item_qty IN NUMBER
, item_id IN NUMBER
) 
AS
BEGIN
	UPDATE ITEM
	SET Total_Qty = Total_Qty - remove_inventory.item_qty
	WHERE Item_ID = remove_inventory.item_id;
END;
/

/*Production cost reduced for the following items*/
UPDATE item 
  SET Item_ListPrice=101.23, 
      Item_Cost=28.12
    WHERE Item_ID=1;

/*Update item quantity based on recent inventory audits*/
UPDATE item
  SET Total_Qty=500
    WHERE Item_ID=2;
    
/*Remove items from inventory and associated orders*/
DELETE FROM OrderDetails WHERE Order_Details_ID=3;
DELETE FROM Item WHERE Item_ID=3;

/*Insert new orders from backlog*/

INSERT INTO OrderDetails    (Order_Details_ID,  Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (2001,              1,                 10,      8,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,  Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (2002,              1,                 10,      7,                 0);
    
/*Rename an index to improve code readability*/

ALTER INDEX fk_Customer RENAME TO fk_Customer_Order_Index;

/*Verify changes*/
SELECT /*fixed*/ * FROM Item;
SELECT /*fixed*/ * FROM User_Indexes WHERE Index_Name LIKE 'FK%' OR Index_Name LIKE 'IN%';