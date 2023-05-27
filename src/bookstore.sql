.mode table
.headers on
.width auto

PRAGMA foreign_keys = TRUE;

--DROP TABLE order_placed;
--DROP TABLE contain;
--DROP TABLE supplier_phone;
--DROP TABLE supply;
--DROP TABLE supplier;
--DROP TABLE book_genre;
--DROP TABLE review;
--DROP TABLE edition;
--DROP TABLE book;
--DROP TABLE customer_phone;
--DROP TABLE customer;

----------------------------------------------------------------------
-- DECLARATIONS
----------------------------------------------------------------------



CREATE TABLE customer (
	customer_id		CHAR(9),
	-- Customer name and address fields are required for billing
	name			VARCHAR(60) NOT NULL,
	-- Email must be non null for contact purposes  
	email			VARCHAR(255) NOT NULL UNIQUE,
	street			VARCHAR(100) NOT NULL,
	city			VARCHAR(100), -- Not always applicable
	postcode		VARCHAR(10) NOT NULL,
	country			VARCHAR(56) NOT NULL,
	PRIMARY KEY (customer_id));
	

CREATE TABLE customer_phone (
	customer_id		CHAR(9),
	phone_type		VARCHAR(20),
	phone_number	        VARCHAR(20),
	PRIMARY KEY (customer_id, phone_number),
	FOREIGN KEY (customer_id) REFERENCES customer
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE book (
	book_id			CHAR(9),
	title			VARCHAR(200) NOT NULL,
        author			VARCHAR(200) NOT NULL,
	publisher		VARCHAR(100) NOT NULL,
	PRIMARY KEY (book_id)
);
	
CREATE TABLE review (
	customer_id		CHAR(9),
	book_id			CHAR(9),
	rating			INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
	PRIMARY KEY (customer_id, book_id),
	FOREIGN KEY (customer_id) REFERENCES customer
	ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (book_id) REFERENCES book
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
	
CREATE TABLE edition (
	book_id			CHAR(9),
	edition_number		INTEGER CHECK (edition_number >= 1),
	edition_type		VARCHAR(9) CHECK (edition_type IN ('paperback', 'audiobook', 'hardcover')),
	price			NUMERIC(7,2) NOT NULL CHECK (price >= 0),
	quantity_in_stock	INTEGER NOT NULL CHECK (quantity_in_stock >= 0) DEFAULT 0,
	PRIMARY KEY (book_id, edition_number, edition_type),
	FOREIGN KEY (book_id) REFERENCES book
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE book_genre (
	book_id		CHAR(9),
	genre		VARCHAR(40),
	PRIMARY KEY (book_id, genre),
	FOREIGN KEY (book_id) REFERENCES book
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE supplier (
	supplier_id	CHAR(9),
        name		VARCHAR(100) NOT NULL,
	account_number 	VARCHAR(34) NOT NULL UNIQUE, -- max IBAN length
	PRIMARY KEY (supplier_id)
);

CREATE TABLE supply (
	supplier_id	CHAR(9),
	book_id		CHAR(9),
	edition_number	INTEGER CHECK (edition_number >= 1),
	edition_type	VARCHAR(9) CHECK (edition_type IN ('paperback', 'audiobook', 'hardcover')),
	supply_price	NUMERIC(7,2) NOT NULL CHECK (supply_price >= 0),
	PRIMARY KEY (supplier_id, book_id, edition_number, edition_type),
	FOREIGN KEY (book_id, edition_number, edition_type) REFERENCES edition
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (supplier_id) REFERENCES supplier
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE supplier_phone (
	supplier_id	CHAR(9),
	phone_number	VARCHAR(15),
	PRIMARY KEY (supplier_id, phone_number),
	FOREIGN KEY (supplier_id) REFERENCES supplier
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE order_placed (
	order_id		CHAR(9),
	customer_id		CHAR(9),
	delivery_street		VARCHAR(100) NOT NULL,
	delivery_city		VARCHAR(100), -- Not always applicable
	delivery_postcode	VARCHAR(10) NOT NULL,
	delivery_country	VARCHAR(56) NOT NULL,
	date_ordered		VARCHAR(30) NOT NULL,
	date_delivered		VARCHAR(30), -- May not have yet been delivered
	PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) REFERENCES customer
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

CREATE TABLE contain (
	order_id	    CHAR(9),
	book_id		    CHAR(9),
	edition_number	    INTEGER CHECK (edition_number >= 1),
	edition_type	    VARCHAR(9) CHECK (edition_type IN ('paperback', 'audiobook', 'hardcover')),
	amount		    INTEGER NOT NULL DEFAULT 1 CHECK (amount >= 1),
	PRIMARY KEY (order_id, book_id, edition_number, edition_type),
	FOREIGN KEY (order_id) REFERENCES order_placed
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	
	FOREIGN KEY (book_id, edition_number, edition_type) REFERENCES edition
	ON DELETE CASCADE
	ON UPDATE CASCADE
);


----------------------------------------------------------------------
-- MOCK DATA
----------------------------------------------------------------------


INSERT INTO customer
VALUES  ('100011101', 'Ben White', 'benwhite@gmail.com', '14 Stanhope Road', 'London', 'N7 6RE', 'United Kingdom'),
	('100011102', 'Bukayo Saka', 'bukayoassists@yahoo.com', '12A Buccleuch Road', 'Edinburgh', 'EH8 9TH', 'United Kingdom'),
	('100011103', 'David Silva', 'elartiste@gmail.com', '46 4F3 Meadow Drive', 'Edinburgh', 'EH2 7UY', 'United Kingdom'),
	('100011104', 'Niharika Kumari', 'nididi@hotmail.com', 'B-42 Lalru Mandi', 'Punjab', '140501', 'India'),
	('100011105', 'Harry Kane', 'spurslad22@gmail.com', '18 1F2 Haymarket Road', 'Edinburgh', 'EH1 1QA', 'United Kingdom'),
	('100011106', 'Kai Foddock', 'kfoddock818@gmail.com', '82 Edinburgh Road', 'Glasgow', 'G8 6EE', 'United Kingdom'),
	('100011107', 'Jessica Grant', 'justjess@yahoo.com', '14 Cupar Road', NULL,'KY12 4ER', 'United Kingdom'),
	('100011108', 'Kate Lahey', 'tpb@gmail.com', '154B Essex Way', 'London', 'N7 6RE', 'United Kingdom'),
	('100011109', 'Michael Dornter', 'micdor3232@gmail.com', '6 1F2 Bucharest Place', 'Edinburgh', 'EH11 7YU', 'United Kingdom'),
        ('100011110', 'Kerry Mint', 'mintkerzz@yahoo.com', '66 Wanton Street', 'Glasgow', 'G2 4AR', 'United Kingdom'),
        ('100011111', 'Jon Manson', 'manners8122@gmail.com', '23 4F2 Market Street', 'Edinburgh', 'EH2 1WE', 'United Kingdom'),
        ('100011112', 'Jason Stanthorpe', 'jasthestan@icloud.com', '6833 Kansas Avenue', 'Bethesda', '20816', 'United States of America');

INSERT INTO customer_phone
VALUES ('100011112', NULL, '+1 (820)-452-901'),
       ('100011105', 'mobile', '07924929332'),
       ('100011105', 'landline', '02074342293'),
       ('100011108', 'work', '+447967221441'),
       ('100011108', 'personal', '+447801901554'),
       ('100011111', 'mobile', '07228334717'),
       ('100011106', NULL, '07714556822'),
       ('100011110', 'work', '0208 565 778'),
       ('100011110', 'mobile', '07883443926'),
       ('100011102', 'Home', '0207 599 8993'),
       ('100011103', 'Mobile', '07322 411 964'),
       ('100011103', 'Landline', '0207 663 8831'),
       ('100011104', 'Mobile', '+916746972324');


INSERT INTO book
VALUES ('800733200','Dune', 'Frank Herbert', 'Ultimate Books'),
       ('800733201','Nineteen Eighty-Four', 'George Orwell', 'Ultimate Books'),
       ('800733202','The Ultimate Hitchhiker''s Guide to the Galaxy ', 'Douglas Adams', 'Ultimate Books'),
       ('800733203','To Kill a Mockingbird', 'Harper Lee', 'Penguin Classics'),
       ('800733204','Of Mice and Men', 'George Orwell', 'Penguin Classics'),
       ('800733205','Mansfield Park', 'Jane Austen', 'Penguin Classics'),
       ('800733206','Frankenstein', 'Mary Shelley', 'Penguin Classics'),
       ('800733207','Jane Eyre', 'Charlotte Bronte', 'Penguin Classics'),
       ('800733208','Introduction to Algorithms', 'Thomas H. Cormen,Charles E. Lieserson,Ronald L. Rivest,Clifford Stein', 'O''Reilly'),
       ('800733209','Compilers: Principles, Techniques, and Tools', 'Alfred Aho,Ravi Sethi,Jeffrey Ullman,Monica S. Lam', 'O''Reilly'),
       ('800733210','Artificial Intelligence: A Modern Approach', 'Peter Norvig, Stuart J. Russell', 'O''Reilly'),
       ('800733211','Hands-on Machine Learning with Scikit-Learn, Keras, and TensorFlow', 'Aurelien Geron', 'O''Reilly'),
       ('800733212','Mr. Greedy', 'Roger Hargreaves', 'Ultimate Books'),
       ('800733213','The Handmaid''s Tale', 'Margaret Atwood', 'Ultimate Books'),
       ('800733214','The Lizzie and Belle Mysteries: Drama and Danger', 'J.T. Williams', 'Ultimate Books');
      
INSERT INTO edition
-- book_id '800733205', '800733213' have no editions in database
VALUES  ('800733200', 1, 'paperback', 8.95, 9),
	('800733200', 2, 'paperback', 12.95, 4),
	('800733200', 2, 'hardcover', 28.95, 2),
	('800733200', 2, 'audiobook', 9.95, 10),
    	('800733201', 1, 'paperback', 9.95, 2),
    	('800733201', 1, 'hardcover', 19.95, 3),
    	('800733201', 1, 'audiobook', 8.95, 100),
    	('800733202', 1, 'paperback', 12.95, 3),
    	('800733203', 1, 'paperback', 8.95, 1),
    	('800733203', 1, 'hardcover', 18.95, 0),
    	('800733204', 1, 'paperback', 8.95, 2),
    	('800733204', 1, 'hardcover', 14.95, 2),
    	('800733204', 1, 'audiobook', 8.95, 40),
    	('800733206', 1, 'paperback', 8.95, 9),
    	('800733206', 1, 'audiobook', 6.95, 50),
    	('800733207', 1, 'paperback', 8.95, 2),
    	('800733207', 1, 'audiobook', 6.95, 30),
    	('800733207', 2, 'paperback', 10.95, 23),
    	('800733208', 3, 'paperback', 68.95, 1),
    	('800733208', 3, 'hardcover', 114.95, 3),
    	('800733208', 4, 'paperback', 99.95, 4),
    	('800733208', 4, 'hardcover', 189.95, 1),
    	('800733209', 1, 'paperback', 28.95, 2),
    	('800733209', 2, 'paperback', 48.95, 6),
    	('800733209', 2, 'hardcover', 88.95, 4),
    	('800733210', 3, 'paperback', 49.95, 13),
    	('800733210', 3, 'hardcover', 99.95, 2),
    	('800733210', 4, 'paperback', 79.95, 21),
    	('800733211', 1, 'paperback', 39.95, 34),
    	('800733212', 1, 'paperback', 4.95, 7),
    	('800733212', 1, 'audiobook', 4.95, 20),
    	('800733214', 1, 'paperback', 11.95, 50),
    	('800733214', 1, 'hardcover', 19.95, 14),
    	('800733214', 1, 'audiobook', 9.95, 100);
		
INSERT INTO book_genre
VALUES      ('800733200', 'Science Fiction'),
	    ('800733201', 'Science Fiction'),
	    ('800733202', 'Science Fiction'),
	    ('800733203', 'Thriller'),
	    ('800733204', 'Tragedy'),
	    ('800733204', 'Novella'),
	    ('800733204', 'Fiction'),
	    ('800733205', 'Fiction'),
	    ('800733205', 'Romance'),
	    ('800733206', 'Science Fiction'),
	    ('800733206', 'Horror Fiction'),
	    ('800733207', 'Romance'),
	    ('800733207', 'Drama'),
	    ('800733208', 'Education'),
	    ('800733208', 'Science and Technology'),
	    ('800733209', 'Education'),
	    ('800733209', 'Science and Technology'),
	    ('800733210', 'Education'),
	    ('800733210', 'Science and Technology'),
	    ('800733211', 'Education'),
	    ('800733211', 'Science and Technology'),
	    ('800733212', 'Fiction'),
	    ('800733212', 'Children''s Literature'),
	    ('800733213', 'Science Fiction'),
	    ('800733213', 'Tragedy'),
    	    ('800733214', 'Fiction'),
	    ('800733214', 'Children''s Literature');

		
INSERT INTO supplier
VALUES  ('334455000','Edinburgh Wholesale Books Ltd.','GB48BARC20037895212698'),
	('334455001','Dundee Novel Supplier Ltd.','GB27BARC20031818377931'),
	('334455002','Books R Us Scotland','GB68BARC20031852991255'),
	('334455003','Digital Goods Distribution England','GB58BARC20037857328974'),
	('334455004','Reading Reads','GB07BARC20037888784955'),
	('334455005','Glasgow Textbook Network','GB06BARC20031875384627'),
	('334455006','Best reads Ltd.','GB20BARC20038076164665'),
	('334455007','F3 Distributors','GB47BARC20038492564421'),
	('334455008','Classic Novels Distribution','GB55BARC20031854883571'),
	('334455009','Read your heart out Ltd.','GB26BARC20040481638942'),
	('334455010','UK book supplier','GB75BARC20032654849389');

INSERT INTO supply
VALUES  ('334455000','800733201',1,'paperback',5.00),
	('334455001','800733201',1,'paperback',5.50),
	('334455006','800733201',1,'paperback',6.00),
	('334455003','800733201',1,'audiobook',7.00),
	('334455007','800733202',1,'paperback',5.20),
	('334455010','800733202',1,'paperback',5.50),
	('334455006','800733200',1,'paperback',7.00),

	('334455002','800733200',1,'paperback',6.40),
	('334455009','800733200',2,'audiobook',6.00),
	('334455003','800733200',2,'audiobook',4.00),
	('334455005','800733208',3,'paperback',40.00),
	('334455007','800733208',3,'paperback',58.00),

	('334455005','800733210',4,'paperback',65.00),
	('334455010','800733210',4,'paperback',59.00),
	('334455005','800733211',1,'paperback',28.00),
	('334455005','800733210',3,'hardcover',80.00);

	
INSERT INTO supplier_phone
VALUES  ('334455000', '0207 442 8191'),
	('334455000', '0207 442 3845'),
	('334455001', '0207 334 5566'),
	('334455002', '0208887665'),
	('334455003', '0203 4623 828'),
	('334455004', '0207 336 749'),
	('334455005', '0207 142 1846'),
	('334455006', '0207 3278 322'),
	('334455006', '0208 328 8282'),
	('334455007', '0208 328 3388'),
	('334455008', '0207 983 3332'),
	('334455009', '0208 335 3211'),
	('334455009', '0203 889 0122'),
	('334455010', '0207 665 7744');


INSERT INTO order_placed
VALUES  ('555444000', '100011101', '14 Stanhope Road', 'London', 'N7 6RE', 'United Kingdom','2022-04-11', '2022-04-21'),
	('555444001', '100011101', '14 Stanhope Road', 'London', 'N7 6RE', 'United Kingdom','2022-01-29', '2022-02-03'),
	('555444002', '100011103', '46 4F3 Meadow Drive', 'Edinburgh', 'EH2 7UY', 'United Kingdom','2021-11-11', '2021-11-19'),
	('555444003', '100011103', '46 4F3 Meadow Drive', 'Edinburgh', 'EH2 7UY', 'United Kingdom','2022-09-01', '2022-09-11'),
	('555444004', '100011104', '4 Angus House St Mary''s Place', 'St. Andrews', 'KY16 9UY', 'United Kingdom','2021-03-30', '2021-04-01'),
	('555444005', '100011104', '4 Angus House St Mary''s Place', 'St. Andrews', 'KY16 9UY', 'United Kingdom','2020-04-01', '2020-04-16'),
	('555444006', '100011104', '4 Angus House St Mary''s Place', 'St. Andrews', 'KY16 9UY', 'United Kingdom','2021-01-10', '2021-01-27'),
	('555444007', '100011106', '82 Edinburgh Road', 'Glasgow', 'G8 6EE', 'United Kingdom','2022-10-10', '2022-10-31'),
	('555444008', '100011107', '14 Cupar Road', NULL,'KY12 4ER', 'United Kingdom','2020-09-11', '2020-09-21'),
	('555444009', '100011108', '154B Essex Way', 'London', 'N7 6RE', 'United Kingdom','2022-02-21', '2022-03-05'),
	('555444010', '100011110', '66 Wanton Street', 'Glasgow', 'G2 4AR', 'United Kingdom','2022-10-01', '2022-10-28'),
	('555444011', '100011110', '66 Wanton Street', 'Glasgow', 'G2 4AR', 'United Kingdom','2022-11-01', NULL),
	('555444012', '100011111', '23 4F2 Market Street', 'Edinburgh', 'EH2 1WE', 'United Kingdom','2022-10-27', NULL),
	('555444013', '100011112', '3 Church Crescent', 'London', 'N10 4TG', 'United Kingdom','2022-10-31', NULL),
	('555444014', '100011108', '154B Essex Way', 'London', 'N7 6RE', 'United Kingdom','2019-02-21', '2019-03-03'),
	('555444015', '100011108', '154B Essex Way', 'London', 'N7 6RE', 'United Kingdom','2019-11-08', '2019-11-30'),
        ('555444016', '100011109' ,'6 1F2 Bucharest Place', 'Edinburgh', 'EH11 7YU', 'United Kingdom', '2019-05-06', '2019-05-24');

INSERT INTO review
VALUES  ('100011101', '800733201', 4),
	('100011101', '800733202', 5),
	('100011101', '800733207', 3),
        ('100011104', '800733208', 5),
        ('100011104', '800733209', 2),
        ('100011104', '800733210', 4),
        ('100011107', '800733201', 2),
        ('100011108', '800733202', 1),
        ('100011111', '800733214', 5),
        ('100011112', '800733214', 5),
        ('100011107', '800733211', 4),
        ('100011108', '800733212', 2),
        ('100011108', '800733208', 4);

INSERT INTO contain(order_id, book_id, edition_number, edition_type)
VALUES  ('555444000','800733201', 1, 'paperback'),
	('555444001','800733202', 1, 'paperback'),
    	('555444002','800733207', 1, 'audiobook'),
    	('555444003','800733214', 1, 'audiobook'),
    	('555444004','800733208', 3, 'paperback'),
    	('555444005','800733209', 2, 'paperback'),
        ('555444006','800733210', 4, 'paperback'),
        ('555444007','800733204', 1, 'audiobook'),
	('555444008','800733201', 1, 'audiobook'),
    	('555444009','800733202', 1, 'paperback'),
    	('555444010','800733206', 1, 'audiobook'),
    	('555444012','800733200', 1, 'paperback'),
    	('555444013','800733214', 1, 'hardcover'),
    	('555444014','800733212', 1, 'paperback'),
    	('555444015','800733208', 3, 'paperback'),
        ('555444016','800733206', 1, 'audiobook'),
    	('555444010','800733207', 1, 'audiobook'),
    	('555444011','800733214', 1, 'audiobook'),
    	('555444012','800733208', 3, 'paperback'),
    	('555444013','800733209', 2, 'paperback'),
    	('555444014','800733210', 4, 'paperback'),
    	('555444015','800733204', 1, 'audiobook'),
    	('555444002','800733206', 1, 'audiobook'),
    	('555444003','800733200', 1, 'paperback'),
    	('555444004','800733214', 1, 'hardcover'),
    	('555444005','800733212', 1, 'paperback'),
    	('555444006','800733208', 3, 'paperback'),
        ('555444007','800733206', 1, 'audiobook');

INSERT INTO contain
VALUES  ('555444011','800733214', 1, 'hardcover', 2),
    	('555444012', '800733201', 1, 'hardcover', 2);
-------------------------------------------
-- Task 3: Views
-- Will be used in queries
-------------------------------------------

-- View 1
CREATE VIEW v_order_info AS
SELECT book_id, order_id, amount, price, edition_type, date_ordered
FROM edition
    NATURAL JOIN order_placed
    NATURAL JOIN contain;

-- View 2
-- Calculate the profit margin on each supplied book edition from a supplier
CREATE VIEW v_profit_margins AS
SELECT B.title, book_id, E.edition_number, E.edition_type, S.name,
ROUND((((E.price - SY.supply_price) / E.price) * 100), 1) AS profit_margin
FROM book AS B
    NATURAL JOIN edition AS E
    NATURAL JOIN supplier AS S
    NATURAL JOIN supply AS SY
ORDER BY B.title, profit_margin DESC;


-------------------------------------------
-- Task3: Queries
-------------------------------------------

-- Query 1
-- List all books published by “Ultimate Books” which are in the “Science Fiction” genre
SELECT B.*
FROM book AS B
    NATURAL JOIN book_genre as G
WHERE B.publisher = 'Ultimate Books'
    AND G.genre = 'Science Fiction'; 

-- Query 2
-- List titles and ratings of all books in the “Science and Technology” genre, ordered first by rating
-- (top rated first), and then by the title
SELECT B.title, R.rating
FROM book AS B
    NATURAL JOIN book_genre AS G
    NATURAL JOIN review AS R
WHERE G.genre = 'Science and Technology'
ORDER BY R.rating DESC, B.title;

-- Query 3
-- List all orders placed by customers with customer address in the city of Edinburgh, since 2020, in
-- chronological order, latest first
SELECT order_placed.*
FROM order_placed
    NATURAL JOIN customer
WHERE city = 'Edinburgh'
    AND date_ordered >= 2020
ORDER BY date_ordered DESC;

-- Query 4
-- List all book editions which have less than 5 items in stock, together with the name, account
-- number and supply price of the minimum priced supplier for that edition
SELECT book_id, edition_number, edition_type, name, account_number, MIN(supply_price)
FROM edition 
    NATURAL JOIN supply
    NATURAL JOIN supplier
WHERE quantity_in_stock < 5
GROUP BY book_id, edition_number, edition_type;

-- Query 5.1
-- Calculate the total value of all audiobook sales since 2020 for each publisher
/*
SELECT publisher, SUM(amount * price) AS total_value_audiobook_sales
FROM v_order_info
    NATURAL JOIN book
WHERE date_ordered > 2019
    AND edition_type = 'audiobook'
GROUP BY publisher;
*/

-- Query 5.2
-- discarding publishers with no audiobook sales
SELECT publisher, IFNULL(SUM(amount * price),0) AS total_value_audiobook_sales
FROM book AS B
    LEFT JOIN v_order_info AS V
    ON B.book_id = V.book_id
    AND edition_type = 'audiobook'
WHERE date_ordered > 2019 OR date_ordered IS NULL
GROUP BY publisher
ORDER BY total_value_audiobook_sales DESC;

-- Query 6
-- Calculate the total price for each order, sorted highest first
SELECT order_id, SUM(C.amount * E.price) AS total_value
FROM edition AS E
    NATURAL JOIN contain AS C
    NATURAL JOIN order_placed
    GROUP BY order_id
    ORDER BY total_value DESC;

-- Query 7
-- Average delivery time by city
SELECT delivery_city, ROUND(AVG(JULIANDAY(date_delivered) - JULIANDAY(date_ordered)),0) AS average_delivery_time
FROM order_placed
WHERE delivery_city IS NOT NULL
GROUP BY delivery_city;

-- Query 8
-- Get highest profit margin suppliers for each book edition
SELECT name AS supplier, profit_margin, title, edition_number AS ed_no, edition_type
FROM v_profit_margins
GROUP BY book_id, edition_number, edition_type
ORDER BY title, profit_margin DESC;

-- Query 9
-- Get average profit margins for each supplier
SELECT name, AVG(profit_margin) AS average_profit_margin
FROM v_profit_margins
GROUP BY name
ORDER BY average_profit_margin DESC;

-- Query 10
-- Best selling books by quantity sold, highest first
SELECT B.title, SUM(amount) AS quantity_sold
FROM book as B
    NATURAL JOIN contain as C
GROUP BY book_id
ORDER BY quantity_sold DESC;

-- View printing --
/*
-- View 1
SELECT *
FROM v_order_info;

-- View 2
SELECT title, book_id, edition_number AS ed_no, edition_type, name, profit_margin 
FROM v_profit_margins;
*/
