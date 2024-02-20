-- find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

/* Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).

 

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

The result format is in the following example.

 

Example 1:

Input: 
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
Output: 
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.
 */

-- Solution 1

# SUBQUERY
SELECT ROUND(SUM(is_immediate) * 100.0 / COUNT(is_immediate), 2) AS immediate_percentage
FROM (
    SELECT 
        customer_id,
        IF(MIN(order_date) = MIN(customer_pref_delivery_date), 1, 0) AS is_immediate
    FROM Delivery
    GROUP BY customer_id
) AS first_orders;


-- Solution 2
# CTE
with cte1 as
(
     select customer_id , min(order_date) as min_order 
    from delivery 
    group by customer_id
)
select round((sum(case when cte1.min_order =deli.customer_pref_delivery_date then 1 else 0 end ))/count(cte1.customer_id)*100,2) as immediate_percentage 
 from cte1 join delivery as deli 
 on cte1.customer_id = deli.customer_id 
 and cte1.min_order = deli.order_date  