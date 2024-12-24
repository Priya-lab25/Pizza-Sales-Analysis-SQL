CREATE DATABASE Pizzahut;
USE Pizzahut;

CREATE TABLE Orders (
Order_id INT NOT NULL,
Order_date DATE NOT NULL,
Order_time TIME NOT NULL,
primary key (Order_id)
);

CREATE TABLE Orders_details (
Order_detail_id INT NOT NULL,
Order_id INT NOT NULL,
Pizza_id TEXT NOT NULL,
Quantity INT NOT NULL,
primary key (Order_detail_id)
);

-- Retrieve the total number of orders placed.
SELECT Count(Order_id) as Total_orders FROM Orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(Orders_details.Quantity * pizzas.price),
            2) AS Total_revenue
FROM
    Orders_details
        JOIN
    pizzas ON pizzas.pizza_id = Orders_details.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(Orders_details.Order_detail_id) AS Order_Count
FROM
    pizzas
        JOIN
    Orders_details ON pizzas.pizza_id = Orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY Order_Count DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    SUM(Orders_details.Quantity) AS Total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    Orders_details ON pizzas.pizza_id = Orders_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Total_quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(Orders_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    Orders_details ON pizzas.pizza_id = Orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY Quantity DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(Quantity), 0)
FROM
    (SELECT 
        Orders.Order_date, SUM(Orders_details.Quantity) AS Quantity
    FROM
        Orders
    JOIN Orders_details ON Orders.Order_id = Orders_details.order_id
    GROUP BY Orders.order_date) AS order_quantity;

-- Analyze the cumulative revenue generated over time.
SELECT Order_date, 
SUM(revenue) OVER (Order BY Order_date) AS Cum_Revenue
FROM
(SELECT Orders.Order_date,
SUM(Orders_details.Quantity*pizzas.price) AS Revenue
FROM Orders_details JOIN Pizzas
ON Orders_details.pizza_id = pizzas.pizza_id
JOIN Orders
ON Orders.Order_id = Orders_details.order_id
GROUP BY Orders.Order_date) AS Sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT 
    pizza_types.name,
    SUM(Orders_details.Quantity * pizzas.price) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    Orders_details ON Orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;