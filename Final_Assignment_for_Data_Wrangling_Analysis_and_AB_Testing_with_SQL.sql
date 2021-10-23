-- Final Assignment for Data Wrangling, Analysis and AB Testing with SQL
-- * Description * --
-- We are running an experiment at an item-level, which means all users who visit 
-- will see the same page, but the layout of different item pages may differ.
-- * ----------- * --

-- Compare the final_assignments_qa table to the assignment events we captured for user_level_testing. 
-- Write an answer to the following question: Does this table have everything you need to compute metrics like 30-day view-binary?
-- The answer is No. The created_at date is needed.

SELECT * 
FROM dsv1069.final_assignments_qa;
