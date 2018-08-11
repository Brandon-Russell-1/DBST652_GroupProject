/*
Group 3
RLS DBST652 - Using the Explain plan tool to look at query execution plans.
			  With Oracle we can see that one needs to store the execution plan of a particular query
			  and then use database function to recall that plan. By setting the 'STATEMENT_ID' we are
			  able to set and recall specific ones.
			  
			  Depending on the option you input to display them will depend on what is displayed, but you can
			  see that some will give you the Cost of each particular action in the query (in terms of CPU power)
			  and then the time it takes to process.
			  
			  You also have the option of using the Oracle Timing command, or '.get_time' procedure found within the database
			  utility package. All of these will be shown as examples below, with their results displayed.
*/


-- Using the Explain tool to store the Explain plan data into the default table PLAN_TABLE
EXPLAIN PLAN
	SET STATEMENT_ID = 'GroupPlan_1' FOR
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

EXPLAIN PLAN
	SET STATEMENT_ID = 'GroupPlan_2' FOR
SELECT Customer_ID, Cust_FName
FROM Customer
UNION
SELECT Customer_ID, TO_CHAR(Order_date)
FROM CustomerOrder;

EXPLAIN PLAN
	SET STATEMENT_ID = 'GroupPlan_3' FOR
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

-- Display results from Explain PLAN_TABLE

-- With 'Basic' output parameter
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','GroupPlan_1','BASIC'));
-- Results
/*
Plan hash value: 2492395418
 
----------------------------------------------------------------
| Id  | Operation                           | Name             |
----------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                  |
|   1 |  SORT ORDER BY                      |                  |
|   2 |   NESTED LOOPS                      |                  |
|   3 |    NESTED LOOPS                     |                  |
|   4 |     HASH JOIN                       |                  |
|   5 |      HASH JOIN                      |                  |
|   6 |       VIEW                          | VW_SQ_1          |
|   7 |        HASH GROUP BY                |                  |
|   8 |         MERGE JOIN                  |                  |
|   9 |          TABLE ACCESS BY INDEX ROWID| CUSTOMERORDER    |
|  10 |           INDEX FULL SCAN           | PK_CUSTOMERORDER |
|  11 |          SORT JOIN                  |                  |
|  12 |           VIEW                      | index$_join$_007 |
|  13 |            HASH JOIN                |                  |
|  14 |             INDEX FAST FULL SCAN    | FK_CUSTOMERORDER |
|  15 |             INDEX FAST FULL SCAN    | FK_ORDERITEM     |
|  16 |       VIEW                          | index$_join$_001 |
|  17 |        HASH JOIN                    |                  |
|  18 |         INDEX FAST FULL SCAN        | FK_CUSTOMERORDER |
|  19 |         INDEX FAST FULL SCAN        | FK_ORDERITEM     |
|  20 |      VIEW                           | index$_join$_002 |
|  21 |       HASH JOIN                     |                  |
|  22 |        INDEX FAST FULL SCAN         | IN_ORDERDATE     |
|  23 |        INDEX FAST FULL SCAN         | PK_CUSTOMERORDER |
|  24 |     INDEX UNIQUE SCAN               | PK_ITEM          |
|  25 |    TABLE ACCESS BY INDEX ROWID      | ITEM             |
----------------------------------------------------------------
*/
	
-- With 'Typical' output parameter
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','GroupPlan_2','TYPICAL'));
--Results
/*
Plan hash value: 1777963098
 
-----------------------------------------------------------------------------------
| Id  | Operation          | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |              |    20 |   120 |     6  (50)| 00:00:01 |
|   1 |  UNION-ALL         |              |       |       |            |          |
|   2 |   TABLE ACCESS FULL| ITEM         |    10 |    60 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| ORDERDETAILS |    10 |    60 |     3   (0)| 00:00:01 |
-----------------------------------------------------------------------------------
*/

-- With 'All' output parameter
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','GroupPlan_3','ALL'));
-- Results
/*
Plan hash value: 1872350007
 
---------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |    10 |   590 |     4  (25)| 00:00:01 |
|   1 |  MERGE JOIN                  |              |    10 |   590 |     4  (25)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| ITEM         |    10 |   330 |     2   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN           | PK_ITEM      |    10 |       |     1   (0)| 00:00:01 |
|*  4 |   SORT JOIN                  |              |    10 |   260 |     2  (50)| 00:00:01 |
|   5 |    VIEW                      |              |    10 |   260 |     1   (0)| 00:00:01 |
|   6 |     HASH GROUP BY            |              |    10 |    30 |     1   (0)| 00:00:01 |
|   7 |      INDEX FULL SCAN         | FK_ORDERITEM |    10 |    30 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$1
   2 - SEL$1 / I@SEL$1
   3 - SEL$1 / I@SEL$1
   5 - SEL$2 / A@SEL$1
   6 - SEL$2
   7 - SEL$2 / D@SEL$2
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("A"."ITEMID"="I"."ITEM_ID")
       filter("A"."ITEMID"="I"."ITEM_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) "I"."DATE_ADDED"[DATE,7], "I"."ITEM_NAME"[VARCHAR2,50], 
       "A"."COUNT"[NUMBER,22]
   2 - "I"."ITEM_ID"[NUMBER,22], "I"."ITEM_NAME"[VARCHAR2,50], 
       "I"."DATE_ADDED"[DATE,7]
   3 - "I".ROWID[ROWID,10], "I"."ITEM_ID"[NUMBER,22]
   4 - (#keys=1) "A"."ITEMID"[NUMBER,22], "A"."COUNT"[NUMBER,22]
   5 - "A"."COUNT"[NUMBER,22], "A"."ITEMID"[NUMBER,22]
   6 - (#keys=1) "D"."ITEM_ID"[NUMBER,22], COUNT(*)[22]
   7 - "D"."ITEM_ID"[NUMBER,22]
*/


-- Using Oracle Timing command to get *JUST* time of query execution
SET serveroutput ON;
VARIABLE n NUMBER;
EXEC :n := dbms_utility.get_time;
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
EXEC dbms_output.put_line(( (dbms_utility.get_time-:n)/100) || ' seconds....');

-- Result
/*
anonymous block completed
   ITEM_ID LAST_DATE_ORDERED ITEM_NAME                                          DAYS_SINCE_LAST_ORDER
---------- ----------------- -------------------------------------------------- ---------------------
        10 22-OCT-15         AMD EVGA 1GB DDR3 Video Card                                         162 
         9 20-NOV-15         Dell 200x DVD Burner                                                 133 
         8 03-DEC-15         Dell 3.5 Inch Floppy                                                 120 
         6 10-JAN-16         LexMark Printer 5500                                                  82 
         5 15-JAN-16         HP 22 Inch Monitor                                                    77 
         7 01-FEB-16         4GB DDR3 144-Pin RAM                                                  60 
         1 12-FEB-16         4.2GHZ Intel I5 6th Gen                                               49 
         2 12-FEB-16         Dell XPS 13 Laptop                                                    49 
         3 15-FEB-16         A42-U53 Battery                                                       46 
         4 16-FEB-16         HP Pavilion Desktop                                                   45 

 10 rows selected 

anonymous block completed
.02 seconds....
*/
