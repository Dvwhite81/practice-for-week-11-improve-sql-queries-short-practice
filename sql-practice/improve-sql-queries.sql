----------
-- Step 0 - Create a Query
----------
-- Query: Select all cats that have a toy with an id of 5

    -- Your code here
    SELECT cats.name
    FROM cats
    JOIN cat_toys ON (cats.id = cat_toys.cat_id)
    WHERE cat_toys.toy_id = 5;

-- Paste your results below (as a comment):
/*
    Rachele
    Rodger
    Jamal
*/



----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT cats.name
    FROM cats
    JOIN cat_toys ON (cats.id = cat_toys.cat_id)
    WHERE cat_toys.toy_id = 5;


-- Paste your results below (as a comment):
/*
    QUERY PLAN
    --SCAN cat_toys
    --SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
*/

-- What do your results mean?

    -- Was this a SEARCH or SCAN?
        -- Both


    -- What does that mean?
        -- cat_toys was scanned to look through every row for the toy_id
        -- cats was searched using the primary key as an index




----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
    SELECT cats.name
    FROM cats
    JOIN cat_toys ON (cats.id = cat_toys.cat_id)
    WHERE cat_toys.toy_id = 5;

-- Paste your results below (as a comment):
    -- Run Time: real 0.001 user 0.000953 sys 0.000000



----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
    CREATE INDEX cat_toys_toy_id_cat_id ON cat_toys(toy_id, cat_id);

-- Analyze Query:
    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT cats.name
    FROM cats
    JOIN cat_toys ON (cats.id = cat_toys.cat_id)
    WHERE cat_toys.toy_id = 5;

-- Paste your results below (as a comment):
    -- SEARCH cat_toys USING COVERING INDEX cat_toys_toy_id_cat_id (toy_id=?)
    -- SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)


-- Analyze Results:

    -- Is the new index being applied in this query?
        -- Yes




----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
    SELECT cats.name
    FROM cats
    JOIN cat_toys ON (cats.id = cat_toys.cat_id)
    WHERE cat_toys.toy_id = 5;

-- Paste your results below (as a comment):
    -- Run Time: real 0.000 user 0.000000 sys 0.000208


-- Analyze Results:
    -- Are you still getting the correct query results?
        -- Yes, but in a different order


    -- Did the execution time improve (decrease)?
        -- real and user times went down to 0, sys time went up from 0 to 0.000208


    -- Do you see any other opportunities for making this query more efficient?
        -- No


---------------------------------
-- Notes From Further Exploration
---------------------------------
