SET echo on;
SET serveroutput on;
/* Drop tables, sequence, and other objects you create*/

DROP TABLE OrderDetails;
DROP TABLE Item;
DROP TABLE CustomerOrder;
DROP TABLE ItemType;
DROP TABLE Customer;


DROP SEQUENCE Customer_Seq;
DROP SEQUENCE CustomerOrder_Seq;
DROP SEQUENCE OrderDetails_Seq;
DROP SEQUENCE Item_Seq;
DROP SEQUENCE ItemType_Seq;


/* Create 5 tables */

CREATE TABLE Customer
(
  Customer_ID		NUMBER         NOT NULL,
  Cust_FName	  VARCHAR2 (50),	
  Cust_LName	  VARCHAR2 (50),	
  Cust_Address	VARCHAR2 (100),	
  Cust_ZipCode	VARCHAR2(10),
  Cust_PhoneNum VARCHAR2(15),
  Cust_Email    VARCHAR2(50),
  CONSTRAINT    pk_customer PRIMARY KEY (Customer_ID)
);

DESCRIBE Customer;

CREATE TABLE CustomerOrder
(
  Customer_Order_ID		 NUMBER         NOT NULL,
  Order_Date           DATE,
  Customer_ID          NUMBER         NOT NULL,
  CONSTRAINT  pk_CustomerOrder PRIMARY KEY (Customer_Order_Id),
  CONSTRAINT  fk_Customer FOREIGN KEY (Customer_ID) 
    REFERENCES Customer
);

DESCRIBE CustomerOrder;

CREATE TABLE ItemType
(

  Item_Type_ID       NUMBER         NOT NULL,
  Type_Name          VARCHAR2(50),
  CONSTRAINT  pk_ItemType PRIMARY KEY (Item_Type_ID)
);

DESCRIBE ItemType;

CREATE TABLE Item
(
  Item_ID          NUMBER       NOT NULL,
  Item_ListPrice   NUMBER,
  Item_Cost        NUMBER,
  Item_Name        VARCHAR2 (50),
  Item_Type_ID     NUMBER,
  Spec_Documents   BLOB,
  Total_Qty        NUMBER,
  Reorder_Qty      NUMBER,
  Date_Added       DATE,
  CONSTRAINT  pk_Item PRIMARY KEY (Item_ID),
  CONSTRAINT fk_ItemType  FOREIGN KEY (Item_Type_ID)
    REFERENCES ItemType
);

DESCRIBE Item;


CREATE TABLE OrderDetails
(
  Order_Details_ID      NUMBER         NOT NULL,
  Order_Details_Qty     NUMBER,
  Discount              NUMBER,
  Item_ID               NUMBER         NOT NULL,
  Customer_Order_ID     NUMBER         NOT NULL,
  CONSTRAINT  pk_OrderDetails PRIMARY KEY (Order_Details_ID),
  CONSTRAINT fk_CustomerOrder  FOREIGN KEY (Customer_Order_ID)
    REFERENCES CustomerOrder,
  CONSTRAINT fk_OrderItem  FOREIGN KEY (Item_ID)
    REFERENCES Item

);

DESCRIBE OrderDetails;

/* Create indexes on foreign keys*/

CREATE INDEX fk_Customer on CustomerOrder(Customer_ID);
CREATE INDEX fk_ItemType on Item(Item_Type_ID);
CREATE INDEX fk_CustomerOrder on OrderDetails(Customer_Order_ID);
CREATE INDEX fk_OrderItem on OrderDetails(Item_ID);


/* Create trigger */
/*This trigger will update an items quantity after an order is inserted into the OrderDetails table*/
CREATE OR REPLACE TRIGGER UpdateItemQty_Trigger AFTER INSERT ON OrderDetails
FOR EACH ROW
   BEGIN
        UPDATE Item
        SET Total_Qty = Total_Qty - :New.Order_Details_Qty
        WHERE Item_ID = :New.Item_ID;
        
        dbms_output.put_line ('Customer Order Quantity deducted!!!');
    END;
    /


/* Create sequence*/

CREATE SEQUENCE Customer_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE CustomerOrder_Seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE OrderDetails_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE Item_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE ItemType_Seq
  START WITH 1
  INCREMENT BY 1;

  
/* Data Dictionary query */
PURGE recyclebin;
/*The next query returns a list of all objects in the user_objects table*/
SELECT /*fixed*/ object_name, object_type FROM user_objects ORDER BY object_type;

/* Insert data into each table */


INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,    Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Bob',      'Roberts',  '123 ABC Street','31088',      '123-456-0000', 'BobRoberts@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Mary',     'Jane',     '45 Alberta Lane ','31771',      '476-897-1111', 'MaryJane@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Brandon',     'Russell',     '123 Finegand Place ','31771',      '234-123-222', 'HighFive34@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName,    Cust_LName,    Cust_Address,         Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'James',     'Doe',     '46 Alberta Lane ','31771',      '476-897-1112', 'JamesDoe@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName,  Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Jim',       'Bob',      '47 Alberta Lane ','31771',      '476-897-1113', 'JimBob@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Patricia',     'Russell',     '48 Alberta Lane ','31771',      '476-897-1114', 'PRussell@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName,      Cust_LName,    Cust_Address,     Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Jane',     'Johnson',     '49 Alberta Lane ','31771',      '476-897-1115', 'JJ123@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName,    Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Hyon',     'Yi',       '50 Alberta Lane ','31771',      '476-897-1116', 'HyonYi@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Keith',     'Jordan',   '51 Alberta Lane ','31771',      '476-897-1117', 'KJ88@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName,  Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Pete',     'Smith',     '52 Alberta Lane ','31771',      '476-897-1118', 'PeteS33@gmail.com');

INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 1,         '12-FEB-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 2,         '15-FEB-16');
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 3,         '16-FEB-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 4,         '15-JAN-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 5,         '10-JAN-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 6,         '01-FEB-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 7,         '03-DEC-15');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 8,         '20-NOV-15');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 9,         '22-OCT-15');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 10,         '23-FEB-16');             

INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'CPU');          
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Battery');   
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Desktop');   
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Laptop');   
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Monitor');   
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Printer'); 
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'RAM'); 
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Floppy Drive'); 
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'DVD Drive'); 
INSERT INTO ItemType        (Item_Type_ID,         Type_Name)
    VALUES                  (ItemType_Seq.NEXTVAL, 'Video Card'); 
  
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 123.23,         50.12,     '4.2GHZ Intel I5 6th Gen',1,            EMPTY_BLOB(),   100,         1,           '01-FEB-16');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 1000.01,       500.08,    'Dell XPS 13 Laptop',     4,            EMPTY_BLOB(),    100,         1,           '01-JAN-16');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 56.34,          12.12,     'A42-U53 Battery',        2,            EMPTY_BLOB(),   100,       10,           '01-FEB-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 450.25,          80.00,    'HP Pavilion Desktop',    3,            EMPTY_BLOB(),   50,         2,           '01-APR-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 100.25,         68.00,     'HP 22 Inch Monitor',     5,            EMPTY_BLOB(),   50,         6,           '01-JUN-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 75.25,         25.00,     'LexMark Printer 5500',    6,            EMPTY_BLOB(),   25,         2,           '01-JAN-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 40.00,         10.00,     '4GB DDR3 144-Pin RAM',    7,            EMPTY_BLOB(),   25,         5,           '01-JUL-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 15.25,          3.00,     'Dell 3.5 Inch Floppy',    8,            EMPTY_BLOB(),   10,         3,           '01-SEP-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 55.25,          28.00,     'Dell 200x DVD Burner',   9,            EMPTY_BLOB(),   10,         2,           '01-MAR-15');
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                         Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty, Date_Added)
    VALUES                  (Item_Seq.NEXTVAL, 300.00,         58.00,     'AMD EVGA 1GB DDR3 Video Card',     10,           EMPTY_BLOB(),   10,         1,           '01-JUN-15');


INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 1,                 1,       1,                 .05);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 2,                 2,       1,                 .05);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 3,                 3,       2,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 4,                 4,       3,                 .10);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 5,                 5,       4,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 6,                 6,       5,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 7,                 7,       6,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 8,                 8,       7,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 1,                 9,       8,                 0);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 1,                 10,      9,                 0);



commit;

/* Verify each tables content */

SELECT /*fixed*/ * FROM Customer;
SELECT /*fixed*/ * FROM CustomerOrder;
SELECT /*fixed*/ * FROM OrderDetails;
SELECT /*fixed*/ * FROM Item;
SELECT /*fixed*/ * FROM ItemType;
  
