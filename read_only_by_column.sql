-- Revoke all privileges from the role
REVOKE ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public FROM read_only_by_column;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM read_only_by_column;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM read_only_by_column;;

-- Grant select access to all non-private tables and columns.
-- Keep the tables in alphabetical order, same order as from \dt, so easier to update.
-- Comment "-- Do not grant columns: <list of columns>" is immediately above any grant that does not grant all columns.

-- Schema version xxx 

GRANT SELECT ON table1 TO read_only_by_column;

-- Do not grant columns: column2, column4
GRANT SELECT (column1,
              column3,
              column5,
              column6)
ON table2 TO read_only_by_column;

-- Do not grant tables: table3
 
-- and so on 

-- grants for views
GRANT SELECT ON view1 TO read_only_by_column;

-- and so on
