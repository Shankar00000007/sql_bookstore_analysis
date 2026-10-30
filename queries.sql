-- create_tables.sql (MySQL)
-- Only CREATE TABLE for: books, customers, orders
DROP DATABASE IF EXISTS bookstore;

CREATE DATABASE bookstore;

DROP TABLE IF EXISTS books;
CREATE TABLE books (
    book_id         INT            NOT NULL,
    title           VARCHAR(150)   NOT NULL,
    author          VARCHAR(100)   NOT NULL,
    genre           VARCHAR(50),
    published_year  INT,
    price           DECIMAL(8,2)   NOT NULL,
    stock           INT            NOT NULL DEFAULT 0,
    PRIMARY KEY (book_id)
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id  INT           NOT NULL,
    name         VARCHAR(100)  NOT NULL,
    email        VARCHAR(100),
    phone        VARCHAR(20),
    city         VARCHAR(50),
    country      VARCHAR(50),
    PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id      INT            NOT NULL,
    customer_id   INT            NOT NULL,
    book_id       INT            NOT NULL,
    order_date    DATE           NOT NULL,
    quantity      INT            NOT NULL,
    total_amount  DECIMAL(10,2)  NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),  --here we used references so if you want to drope the table start from refrencess table 
    FOREIGN KEY (book_id)     REFERENCES books (book_id)
);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;
------------------------------------------------------------------------
-- Import data into books table
COPY books(book_id,title,author,genre,published_year,price,stock)
FROM 
CSV HEADER;

-- Import data into customers table   (in this projucts there is no use of this 3 inport code becouse i inpoted directly)
COPY
FROM 
CSV HEADER;

-- Import data into orders table
COPY
FROM
CSV HEADER;
--------------------------------------------------------------------------

--1) fetch "fiction" genre in books:
SELECT * FROM books
WHERE genre ='Fiction';

-- Find books published after the year 1950:
SELECT * FROM books
WHERE published_year >= 1950; 

--list all the customers from canada
SELECT * FROM customers
WHERE country = 'Canada';

--show orders plased in October 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2026-10-01' AND '2026-10-31';

--find the total stock of book avilable
SELECT SUM(stock) as total_stock
from books;

-- find the details of the most expencive book
 select *from books 
 order by price desc limit 1;

 -- show all customers who ordered more then one quantity of a book;
 SELECT *FROM orders
 where quantity > 1;

 --find all orders where the totla amount exceeds 400;
  SELECT *FROM orders
 where total_amount>400;

 -- list all geners available in the books table;
 SELECT DISTINCT genre FROM books;

 --find books with low stock;
 SELECT * FROM books
 order by stock limit 1;

 -- Calculate the total revenue generated from all orders;
 SELECT SUM (total_amount) as revenue
 FROM orders;

 --------------------------------------------------------------
 --advance quaries
 -- Find the total number of books sold for each genre;
select b.genre, sum(o.quantity) as total_book_sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

-- Find average price of books in the fantasy genre
select (price) as average_price
from books
where genre = 'Fantasy';

-- List customers who have placed at least two orders;
select o.customer_id, c.name, count (o.order_id) as order_count
from orders o
join  customers c on o.customer_id = c.customer_id
group by o.customer_id , c.name
having count (order_id) >=2;

-- Find most frequently ordered book with name;
SELECT O.BOOK_ID,B.TITLE, COUNT (O.ORDER_ID) AS ORDER_COUNT
FROM orders o
join books b on o.book_id = b.book_id
group by o.book_id, b.title
order by ORDER_COUNT DESC;

-- Show the top three most expensive books ofPrograming GENRE;
SELECT *FROM books
where genre = 'Programming'
ORDER BY price desc limit 3;

-- Find the total quantity of books sold by each author;
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

-- List the cities where customers who spent over 400 are located;
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- Find a customer who spent most on orders;
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent Desc;

-- Calculate the stock remaining after fulfilling all orders;
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
       b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
