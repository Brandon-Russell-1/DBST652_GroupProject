SET echo on;
SET serveroutput on;
/* Drop tables, sequence, and other objects you create*/


DROP TABLE OrderDetails;
DROP TABLE ShipmentDetails;
DROP TABLE Item;
DROP TABLE CustomerOrder;
DROP TABLE Shipment;
DROP TABLE ItemType;
DROP TABLE Customer;


DROP SEQUENCE Customer_Seq;
DROP SEQUENCE CustomerOrder_Seq;
DROP SEQUENCE OrderDetails_Seq;
DROP SEQUENCE Item_Seq;
DROP SEQUENCE ItemType_Seq;
DROP SEQUENCE ShipmentDetails_Seq;
DROP SEQUENCE Shipment_Seq;


/* Create 7 tables */

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


CREATE TABLE CustomerOrder
(
  Customer_Order_ID		 NUMBER         NOT NULL,
  Order_Date           DATE,
  Customer_ID          NUMBER         NOT NULL,
  CONSTRAINT  pk_CustomerOrder PRIMARY KEY (Customer_Order_Id),
  CONSTRAINT  fk_Customer FOREIGN KEY (Customer_ID) 
    REFERENCES Customer
);


CREATE TABLE ItemType
(

  Item_Type_ID       NUMBER         NOT NULL,
  Type_Name          VARCHAR2(50),
  CONSTRAINT  pk_ItemType PRIMARY KEY (Item_Type_ID)
);


CREATE TABLE Shipment
(
  Shipment_ID      NUMBER         NOT NULL,
  Date_Received    DATE,
  CONSTRAINT  pk_Shipment PRIMARY KEY (Shipment_ID)
);


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
  CONSTRAINT  pk_Item PRIMARY KEY (Item_ID),
  CONSTRAINT fk_ItemType  FOREIGN KEY (Item_Type_ID)
    REFERENCES ItemType
);


CREATE TABLE ShipmentDetails
(
  Shipment_Details_ID   NUMBER         NOT NULL,
  Shipment_Qty          NUMBER,
  Item_ID               NUMBER         NOT NULL,
  Shipment_ID           NUMBER         NOT NULL,
  CONSTRAINT  pk_ShipmentDetails PRIMARY KEY (Shipment_Details_ID),
  CONSTRAINT fk_Shipment  FOREIGN KEY (Shipment_ID)
    REFERENCES Shipment,
  CONSTRAINT fk_ShipmentItem  FOREIGN KEY (Item_ID)
    REFERENCES Item

);


CREATE TABLE OrderDetails
(
  Order_Details_ID      NUMBER         NOT NULL,
  Order_Details_Qty     NUMBER,
  Discount              NUMBER,
  Item_ID               NUMBER         NOT NULL,
  Shipment_Details_ID   NUMBER         NOT NULL,
  Customer_Order_ID     NUMBER         NOT NULL,
  CONSTRAINT  pk_OrderDetails PRIMARY KEY (Order_Details_ID),
  CONSTRAINT fk_CustomerOrder  FOREIGN KEY (Customer_Order_ID)
    REFERENCES CustomerOrder,
  CONSTRAINT fk_Shipment_Details_ID FOREIGN KEY (Shipment_Details_ID)
    REFERENCES ShipmentDetails,
  CONSTRAINT fk_OrderItem  FOREIGN KEY (Item_ID)
    REFERENCES Item

);


/* Create indexes on foreign keys*/

CREATE INDEX fk_Customer on CustomerOrder(Customer_ID);
CREATE INDEX fk_ItemType on Item(Item_Type_ID);
CREATE INDEX fk_CustomerOrder on OrderDetails(Customer_Order_ID);
CREATE INDEX fk_OrderItem on OrderDetails(Item_ID);
CREATE INDEX fk_Shipment on ShipmentDetails(Shipment_ID);
CREATE INDEX fk_ShipmentItem on ShipmentDetails(Item_ID);
CREATE INDEX fk_Shipment_Details_ID on OrderDetails(Shipment_Details_ID);

/* Create trigger */
/*This trigger will update an items quantity after an order is inserted into the OrderDetails table*/
CREATE OR REPLACE TRIGGER UpdateItemQty_Trigger AFTER INSERT ON OrderDetails
FOR EACH ROW
   BEGIN
        UPDATE Item
        SET Total_Qty = Total_Qty - :New.Order_Details_Qty
        WHERE Item_ID = :New.Item_ID;
        
        UPDATE ShipmentDetails
        SET Shipment_Qty = Shipment_Qty - :New.Order_Details_Qty
        WHERE Shipment_Details_ID = :New.Shipment_Details_ID;
        dbms_output.put_line ('Customer Order Quantity deducted!!!');
    END;
    /

/*This trigger will update an items quantity after a shipment is received and inserted into the ShipmentDetails table*/
CREATE OR REPLACE TRIGGER UpdateShipmentItemQty_Trigger AFTER INSERT ON ShipmentDetails
FOR EACH ROW
   BEGIN
        UPDATE Item
        SET Total_Qty = Total_Qty + :New.Shipment_Qty
        WHERE Item_ID = :New.Item_ID;
      dbms_output.put_line ('Shipment Quantity added!!!');
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

CREATE SEQUENCE ShipmentDetails_Seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE Shipment_Seq
  START WITH 1
  INCREMENT BY 1;
  
/* Insert data into each table */


INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,    Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Bob',      'Roberts',  '123 ABC Street','31088',      '123-456-0000', 'BobRoberts@gmail.com');
INSERT INTO Customer        (Customer_ID,          Cust_FName, Cust_LName, Cust_Address,      Cust_ZipCode, Cust_PhoneNum,  Cust_Email)
    VALUES                  (Customer_Seq.NEXTVAL, 'Mary',     'Jane',     '45 Alberta Lane ','31771',      '476-897-1111', 'MaryJane@gmail.com');

INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 1,         '12-FEB-16');             
INSERT INTO CustomerOrder  (Customer_Order_ID,         Customer_ID, Order_Date)
    VALUES                  (CustomerOrder_Seq.NEXTVAL, 2,         '15-FEB-16');             

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

INSERT INTO Shipment        (Shipment_ID,         Date_Received)
    VALUES                  (Shipment_Seq.NEXTVAL,'12-JAN-16');
INSERT INTO Shipment        (Shipment_ID,         Date_Received)
    VALUES                  (Shipment_Seq.NEXTVAL,'23-DEC-15');
INSERT INTO Shipment        (Shipment_ID,         Date_Received)
    VALUES                  (Shipment_Seq.NEXTVAL,'15-FEB-15');
INSERT INTO Shipment        (Shipment_ID,         Date_Received)
    VALUES                  (Shipment_Seq.NEXTVAL,'1-MAR-15');
    
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty)
    VALUES                  (Item_Seq.NEXTVAL, 123.23,         50.12,     '4.2GHZ Intel I5 6th Gen',1,            EMPTY_BLOB(),   0,         1);
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty)
    VALUES                  (Item_Seq.NEXTVAL, 1000.01,       500.08,    'Dell XPS 13 Laptop',     4,            EMPTY_BLOB(),    0,         1);
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty)
    VALUES                  (Item_Seq.NEXTVAL, 56.34,          12.12,     'A42-U53 Battery',        2,            EMPTY_BLOB(),   0,       10);
INSERT INTO Item            (Item_ID,          Item_ListPrice, Item_Cost, Item_Name,                Item_Type_ID, Spec_Documents, Total_Qty, Reorder_Qty)
    VALUES                  (Item_Seq.NEXTVAL, 45.25,          8.00,     'HP Pavilion Desktop',     3,            EMPTY_BLOB(),   0,         2);

INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 2,            1,       1);
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 1,            1,       2);
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 2,            2,       1);
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 19,           3,       2);
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 1,            4,       3);   
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 1,            1,       3);
INSERT INTO ShipmentDetails (Shipment_Details_ID,         Shipment_Qty, Item_ID, Shipment_ID)
    VALUES                  (ShipmentDetails_Seq.NEXTVAL, 10,           3,       4);

INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Shipment_Details_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 1,                 1,       2,                   1,                 .05);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Shipment_Details_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 2,                 2,       3,                   1,                 .05);
INSERT INTO OrderDetails    (Order_Details_ID,         Order_Details_Qty, Item_ID, Shipment_Details_ID, Customer_Order_ID, Discount)
    VALUES                  (OrderDetails_Seq.NEXTVAL, 1,                 3,       4,                   2,                 0);



commit;

/* Verify each tables content */

SELECT /*fixed*/ * FROM Customer;
SELECT /*fixed*/ * FROM CustomerOrder;
SELECT /*fixed*/ * FROM OrderDetails;
SELECT /*fixed*/ * FROM Item;
SELECT /*fixed*/ * FROM ItemType;
SELECT /*fixed*/ * FROM ShipmentDetails;
SELECT /*fixed*/ * FROM Shipment;

