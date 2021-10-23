-- Final Assignment for Data Wrangling, Analysis and AB Testing with SQL
-- * Description * --
-- We are running an experiment at an item-level, which means all users who visit 
-- will see the same page, but the layout of different item pages may differ.
-- * ----------- * --

-- 1. Compare the final_assignments_qa table to the assignment events we captured for user_level_testing. 
-- Write an answer to the following question: Does this table have everything you need to compute metrics like 30-day view-binary?
-- The answer is No. More information is needed, like the created_at column.

SELECT * 
FROM dsv1069.final_assignments_qa;

-- 2. Write a query and table creation statement to make final_assignments_qa look like the final_assignments table. 
-- If you discovered something missing in part 1, you may fill in the value with a place holder of the appropriate data type.

-- See first: SELECT * FROM dsv1069.final_assignments;

SELECT item_id,
       test_a AS test_assignment,
       (CASE
            WHEN test_a IS NOT NULL then 'test_a'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_a IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT item_id,
       test_b AS test_assignment,
       (CASE
            WHEN test_b IS NOT NULL then 'test_b'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_b IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT item_id,
       test_c AS test_assignment,
       (CASE
            WHEN test_c IS NOT NULL then 'test_c'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_c IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT item_id,
       test_d AS test_assignment,
       (CASE
            WHEN test_d IS NOT NULL then 'test_d'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_d IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT item_id,
       test_e AS test_assignment,
       (CASE
            WHEN test_e IS NOT NULL then 'test_e'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_e IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT item_id,
       test_f AS test_assignment,
       (CASE
            WHEN test_f IS NOT NULL then 'test_f'
            ELSE NULL
        END) AS test_number,
       (CASE
            WHEN test_f IS NOT NULL then NOW()
            ELSE NULL
        END) AS test_start_date
FROM dsv1069.final_assignments_qa

-- 3. Use the final_assignments table to calculate the order binary for the 30 day window 
-- after the test assignment for item_test_2 (You may include the day the test started)

SELECT test_assignment,
       COUNT(DISTINCT item_id) AS number_of_items,
       SUM(order_binary) AS items_ordered_30_day_window
FROM
  (
    SELECT item_test.item_id,
            item_test.test_assignment,
            item_test.test_number,
            item_test.test_start_date,
            item_test.created_at,
            MAX(
                 CASE WHEN (created_at > test_start_date AND 
                       DATE_PART('day', created_at - test_start_date) <= 30) THEN 1
                 ELSE 0 END
                ) AS order_binary
     FROM
       (
         SELECT final_assignments.*,
                 DATE(orders.created_at) AS created_at
          FROM dsv1069.final_assignments AS final_assignments
          LEFT JOIN dsv1069.orders AS orders
            ON final_assignments.item_id = orders.item_id
            WHERE test_number = 'item_test_2'
       ) AS item_test
     GROUP BY item_test.item_id,
              item_test.test_assignment,
              item_test.test_number,
              item_test.test_start_date,
              item_test.created_at
  ) AS order_binary
GROUP BY test_assignment;

-- 4. Use the final_assignments table to calculate the view binary, and average views for 
-- the 30 day window after the test assignment for item_test_2. (You may include the day the test started)

 SELECT  item_test.item_id,
         item_test.test_assignment,
         item_test.test_number,
         Max(
         CASE
                  WHEN (
                                    view_date > test_start_date
                           AND      Date_part('day', view_date - test_start_date) <= 30) THEN 1
                  ELSE 0
         END) AS view_binary
FROM     (
                   SELECT    final_assignments.*,
                             Date(events.event_time)   AS view_date
                   FROM      dsv1069.final_assignments AS final_assignments
                   LEFT JOIN
                             (
                                    SELECT event_time,
                                           CASE
                                                  WHEN parameter_name = 'item_id' THEN Cast(parameter_value AS NUMERIC)
                                                  ELSE NULL
                                           END AS item_id
                                    FROM   dsv1069.events
                                    WHERE  event_name = 'view_item') AS events
                   ON        final_assignments.item_id = events.item_id
                   WHERE     test_number = 'item_test_2') AS item_test
GROUP BY item_test.item_id,
         item_test.test_assignment,
         item_test.test_number limit 100; 
         
         
-- 5. Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts in metrics and the p-values 
-- for the binary metrics ( 30 day order binary and 30 day view binary) using a interval 95% confidence. 

SELECT assignment,
       number,
       Count(DISTINCT item_id)  AS count_of_items,
       Sum(view_binary_30_days) AS view_binary_30_days
FROM   (SELECT final_assignments.item_id AS item_id,
               test_assignment           AS assignment,
               test_number               AS number,
               test_start_date           AS start_date,
               Max(( CASE
                       WHEN Date(event_time) - Date(test_start_date) BETWEEN 0
                            AND 30
                     THEN 1
                       ELSE 0
                     END ))              AS view_binary_30_days
        FROM   dsv1069.final_assignments
               LEFT JOIN dsv1069.view_item_events
                      ON final_assignments.item_id = view_item_events.item_id
        WHERE  test_number = 'item_test_2'
        GROUP  BY final_assignments.item_id,
                  test_assignment,
                  test_number,
                  test_start_date) AS view_binary
GROUP  BY assignment,
          number,
          start_date;  

-- 6. Use Mode’s Report builder feature to write up the test. 
-- Your write-up should include a title, a graph for each of the two binary metrics you’ve calculated. 
-- The lift and p-value (from the AB test calculator) for each of the two metrics, and a complete sentence to interpret the significance of each of the results.
-- The result can be found in here (Tab Reports in Q5): https://app.mode.com/upc3/reports/92defe860710
