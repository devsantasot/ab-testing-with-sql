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
