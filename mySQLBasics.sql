/**************************************** ****START OF SALES SQL*********************************************/
/*Create Sample Sales Database*/
DROP DATABASE IF EXISTS salesdb_sep2018;
CREATE DATABASE salesdb_sep2018;
USE salesdb_sep2018;

/*Create tables necessary for data import*/
DROP TABLE IF EXISTS salesperson;
CREATE TABLE salesperson (ID SMALLINT NOT NULL, Name VARCHAR(50), Age SMALLINT(6), Salary FLOAT(12), PRIMARY KEY (ID));
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (Number SMALLINT NOT NULL, order_date DATE, cust_id SMALLINT NOT NULL, salesperson_id SMALLINT NOT NULL, Amount FLOAT(12), PRIMARY KEY (Number));
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (ID SMALLINT NOT NULL, Name VARCHAR(50), City VARCHAR(50), `Industry Type` VARCHAR(50), PRIMARY KEY (ID));

/*Insert data into target tables*/
INSERT INTO 
	salesperson(ID, Name, Age, Salary)
VALUES
  (1,'Andy',61,140000),
  (2,'Bert',34,44000),
  (5,'Christopher',34,40000),
  (7,'Daniel',41,52000),
  (8,'Kenneth',57,115000),
  (11,'Joesph',38,38000);
    
INSERT INTO
	orders(Number, order_date, cust_id, salesperson_id, Amount)
VALUES
  (10,'1996-08-02',4,2.540),
  (20,'1999-01-30',4,8,1800),
  (30,'1995-07-14',9,1,460),
  (40,'1998-01-29',7,2,2400),
  (50,'1998-02-03',6,7,600),
  (60,'1998-03-02',6,7,720),
  (70,'1998-05-06',9,7,150);
    
INSERT INTO
	customer(ID, Name, City, `Industry Type`)
VALUES
  (4,'Samsung','pleasant','J'),
  (6,'Panasonic','oaktown','J'),
  (7,'Google','jackson', 'B'),
  (9,'Apple','Jackson','B');


/*Find the names of all people that have an order with Samsung*/
SELECT 
	salesperson.Name
FROM
	salesperson, orders
WHERE 
	salesperson.ID = orders.salesperson_id and cust_id = 4
    ;
    
/*Find the names of all salespeople that do not have any order with Samsung*/
SELECT DISTINCT
	salesperson.Name
FROM
	salesperson, orders
WHERE 
	salesperson.ID = orders.salesperson_id and cust_id != 4
    ;
    
/*The names of sales people that have 2 or more orders*/
SELECT
	salesperson.Name
	, count(*) as order_count
FROM
	orders, salesperson
WHERE 
	orders.salesperson_id = salesperson.ID
GROUP BY 
	salesperson.Name
HAVING order_count >= 2
;

/*Write a SQL statement that inserts rows into a table called highAchiever (Name, Age)
	where a salesperson must have a salary of 100,000 or greater to be included
    in the table*/
CREATE TABLE `salesdb_sep2018`.`highachiever` (
  `Name` VARCHAR(45) NOT NULL,
  `Age` INT NOT NULL,
  PRIMARY KEY (`Name`));

INSERT INTO highachiever (`Name`, `Age`)
	(SELECT
		Name
        , Age
	FROM 
		salesperson
	WHERE
		salary >= 100000)
        ;  
    
    
/*In the tables above, each order in the Orders table is associated with a given Customer through the 
	cust_id foreign key column that references the ID column in the Customer table.

Find the largest order amount for each salesperson and the associated order 
number, along with the customer to whom that order belongs to. */

SELECT 
	salesperson_id
    ,salesperson.Name
    ,Number AS OrderNumber
    ,Amount
FROM 
	orders
JOIN 
	salesperson 
	ON salesperson.ID = orders.salesperson_id
JOIN (
	SELECT 
		salesperson_id, 
		MAX( Amount ) AS MaxOrder
	FROM 
		orders
	GROUP BY 
		salesperson_id
	) AS TopOrderAmts
USING 
	( salesperson_id ) 
WHERE 
	Amount = MaxOrder
GROUP BY 
	salesperson_id
	,Amount;

/**********************************************END OF SALES SQL**********************************************/

/********************************************START OF LOGGING SQL********************************************/

DROP DATABASE IF EXISTS itLogging_db;
CREATE DATABASE itLogging_db;
USE itLogging_db;

DROP TABLE IF EXISTS User;
CREATE TABLE User (user_id SMALLINT NOT NULL, name VARCHAR(50), phone_number varchar(6), PRIMARY KEY (user_id));	       

/*--table User-- 
user_id 
name 
phone_num*/												      
INSERT INTO User ('user_id', 'name', 'phone_num')
VALUES
(1 , 'Abe'    , '111' ),
(2 , 'Bob'    , '222' ),
(5 , 'Chris'  , '333' ),
(7 , 'Dan'    , '444' ),
(8 , 'Ken'    , '555' ),
(11, 'Joe'    , '666' );

/*--table UserHistory-- 
user_id 
date 
action*/
DROP TABLE IF EXISTS UserHistory;
CREATE TABLE User (user_id SMALLINT NOT NULL, date VARCHAR(10), action varchar(25), PRIMARY KEY (user_id));													      

INSERT INTO UserHistory ('user_id', 'date', 'action')
VALUES
(1, '2019-05-05', 'logged_on'),
(2, '2018-12-01', 'logged_on'),
(5, '2018-12-01', 'logged_on'),
(5, '2019-05-05', 'logged_on'),
(7, '2019-05-05', 'logged_off'),
(8, '2019-05-01', 'logged_on'),
(8, '2019-04-05', 'logged_on');
	       
/*1. Write a SQL query that returns the name, phone number and most recent date for any user that has
logged in over the last 30 days (you can tell a user has logged in if the action field in 
UserHistory is set to "logged_on").

Every time a user logs in a new row is inserted into the UserHistory table with user_id, current 
date and action (where action = "logged_on"). */

SELECT 
	user.name
    , user.phone_num
    , max(userhistory.date) as recent_date
FROM
	user, userhistory
WHERE
	user.user_id = userhistory.user_id
    AND userhistory.action = 'logged_on'
    AND userhistory.date >= date_sub(curdate(), interval 30 day)
GROUP BY
	user.user_id;

/*2. Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory
table (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL 
MINUS statement. Note: the UserHistory table can have multiple entries for each user_id.*/

SELECT DISTINCT
	user.user_id
FROM 
	user as u
LEFT JOIN userhistory as uh
	ON u.user_id = uh.user_id
WHERE 
	uh.user_id IS NULL;
 
/*********************************************END OF LOGGING SQL*********************************************/
