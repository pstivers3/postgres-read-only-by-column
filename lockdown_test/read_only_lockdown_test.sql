-- Choose a table that would be easy to reconstruct if a modification test gives unexpected results. Example, schema_info
--
-- verify connection info
\conninfo
--
-- can select all from table
select * from schema_info;
--
-- can select a column
select column1 from table1 limit 1;
--
--  can NOT select a colum containing PII
select distinct(column) from table1 limit 1;
--
--  can NOT insert a row
insert into schema_info (version) values (1000);
--
--  can NOT delete a row
delete from schema_info where version=118;
--
--  can NOT add a column
alter table schema_info add column boo integer;
--
-- can NOT rename a column
ALTER TABLE schema_info RENAME version TO version_new;
--
--  can NOT drop a column
ALTER TABLE schema_info DROP COLUMN version;
--
--  can add a table
create table schema_info_new (version integer);
drop table schema_info_new;
--
--  can NOT rename a table
ALTER TABLE schema_info RENAME TO schema_info_new;
--
--  can NOT drop a table
drop table schema_info;
--
-- can NOT drop a database
drop database drop_test_db;
--
-- can NOT alter the password of another user
ALTER ROLE other_user WITH PASSWORD 'boo';

