----------
-- Step 0 - Create a Query
----------
-- Query: Find a count of `toys` records that have a price greater than
    -- 55 and belong to a cat that has the color "Olive".

    -- Your code here
    SELECT COUNT(*) FROM toys
    JOIN cat_toys ON toys.id = cat_toys.toy_id
    JOIN cats ON cat_toys.cat_id = cats.id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
    -- 215




----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT COUNT(*) FROM toys
    JOIN cat_toys ON toys.id = cat_toys.toy_id
    JOIN cats ON cat_toys.cat_id = cats.id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
    --SCAN cat_toys
    --SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
    --SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)


-- What do your results mean?

    -- Was this a SEARCH or SCAN?
        -- Both


    -- What does that mean?
        -- An index that changes SCAN to SEARCH would make it more efficient




----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
    SELECT COUNT(*) FROM toys
    JOIN cat_toys ON toys.id = cat_toys.toy_id
    JOIN cats ON cat_toys.cat_id = cats.id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
    -- Run Time: real 0.011 user 0.011096 sys 0.000




----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
        CREATE INDEX idx_cat_toys_toy_id_cat_id ON cat_toys(toy_id, cat_id);

-- Analyze Query:
    -- Your code here
    EXPLAIN QUERY PLAN
    SELECT COUNT(*) FROM toys
    JOIN cat_toys ON toys.id = cat_toys.toy_id
    JOIN cats ON cat_toys.cat_id = cats.id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
    --SCAN cat_toys
    --SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
    --SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)


-- Analyze Results:

    -- Is the new index being applied in this query?
        -- No




----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
    SELECT COUNT(*) FROM toys
    JOIN cat_toys ON toys.id = cat_toys.toy_id
    JOIN cats ON cat_toys.cat_id = cats.id
    WHERE toys.price > 55 AND cats.color = 'Olive';

-- Paste your results below (as a comment):
    -- Run Time: real 0.011 user 0.010414 sys 0.000104


-- Analyze Results:
    -- Are you still getting the correct query results?
        -- Yes


    -- Did the execution time improve (decrease)?
        -- No


    -- Do you see any other opportunities for making this query more efficient?
        -- I don't know why the index didn't apply to cat_toys. I will work on it below.



---------------------------------
-- Notes From Further Exploration
---------------------------------
-- With this index
-- CREATE INDEX idx_cat_toys_toy_id_cat_id ON cat_toys(toy_id, cat_id);
-- and changing the query to this
/*
EXPLAIN QUERY PLAN
SELECT COUNT(*) AS price_count FROM cat_toys
WHERE toy_id IN (SELECT toys.id FROM toys WHERE toys.price > 55)
AND cat_id IN (SELECT cats.id FROM cats WHERE cats.color = 'Olive');
*/
-- The results are:
    -- SEARCH cat_toys USING COVERING INDEX idx_cat_toys_toy_id_cat_id (toy_id=? AND cat_id=?)
    -- LIST SUBQUERY 1
        -- SCAN toys
    -- LIST SUBQUERY 2
        -- SCAN cats

-- So, the SCAN/SEARCH switched. I'll try to add indexes to cover the subqueries
-- CREATE INDEX idx_toys_price ON toys(price);
    -- Now first subquery is SEARCH
-- CREATE INDEX idx_cats_color ON cats(color);
    -- Now both are SEARCH USING COVERED INDEX
    -- Run Time: real 0.000 user 0.000129 sys 0.000041

    -- Results improved
