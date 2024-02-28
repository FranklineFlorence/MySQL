--Find the second highest salary from the Employee table. If there is no second highest salary, return null

/* Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.

 

Write a solution to find the second highest salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
 */

--Solution1
SELECT
    (SELECT DISTINCT salary
     FROM Employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS SecondHighestSalary;


--Solution2
SELECT
    CASE
        WHEN (
            SELECT COUNT(DISTINCT salary)
            FROM Employee
        ) < 2 THEN NULL
        ELSE (
            SELECT DISTINCT salary
            FROM Employee
            ORDER BY salary DESC
            LIMIT 1 OFFSET 1
        )
    END AS SecondHighestSalary;

--Solution3
SELECT 
    AVG(salary) AS SecondHighestSalary 
FROM 
    (SELECT
        id,
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking
    FROM 
        Employee) x
WHERE 
    x.ranking = 2;
