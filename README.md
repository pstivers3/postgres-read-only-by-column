Purpose

    To create read-only user accounts that can read only specific tables and columns.

    CAUTION: This process is not ideal as it is vulnerable to human error by the coder while creating or updating
       the read_only_by_column.sql script. However it is illustrative of how this could be done in PostgreSQL.

Allow privileges for:

    Selects on specific, non-private tables and columns

Do not allow privileges for:

    Select on specific, private tables or columns 
    Any modifications; drop, insert, create, ...

Notes

    The read-only user can create tables, though should not do this. In order to revoke the create table
    privilege, the privilege would need to be revoked from the public schema which would affect all users.

###########################################################
## Process to create and test read-only users and roles. ##
###########################################################

Log into DB as admin user

    notes:

        - Can log into any DB as admin user, to create users and roles.
        - If wish to manually modify priveleges for DB-specific role, then need to log into the appropriate DB
        - It's not generally necessary to manually modify priveleges. This is done through scripts. (see below)

    psql -h rds.example.net -d database1 -U admin

Create read-only role

    create role read_only_by_column with nosuperuser nocreatedb nocreaterole noinherit;

Create read-only user and grant read-only role to the user

    Run the following for each user. Set the user name in the first line.
    The rest of the code is variablized and therefore the same for each user.

    \set name <user name> 
    create user :name with nosuperuser nocreatedb nocreaterole password 'TempPwd';
    \c database1
    revoke all privileges on all tables in schema public from :name;
    revoke all privileges on all sequences in schema public from :name;
    revoke all privileges on all functions in schema public from :name;
    grant read_only_by_column to :name;

Request that the user update their password on first login using...

    ALTER ROLE <user name> WITH PASSWORD 'password';

To list users and their roles

    \du

To login to database1 DB as read-only user

   psql -h rds.example.net -d database1 -U <username>

To revoke a role from a user 

    revoke read_only_by_column from <user name>;

To drop a user

    drop user <user name>;

Update privileges for role read_only_by_column

    Update the script as necessary

        $ vim /<path>/postgress-read-only-by-column/read_only_by_column.sql

        Every change to the schema gets a change in the file.
        if add a private column, then add the column name to comments for that table.
        if delete a private column, then delete the column name from comments for that table.
        if add a non-private colum, then add the column to the privileges for that table.
        if delete a non-private column, then deleted the column from privileges for that table.
        if adding or deleting an entire table, then add or delete from privileges as appropriately.

    To run the scripts in Prod env

        cd /<path>/postgress-read-only-by-column
        # return errors only. Remove the pipe to return all output
        $ psql -h rds.example.net -d database1 -U read_only_user --echo-all --file=read_only_by_column.sql | grep -i error
        password: <password> 

Test lockdown of privileges for read-only user

      $ cd /<path>/postgress-read-only-by-column/lockdown_test
      $ ./read_only_lockdown_test.sh

Process to ensure privileges keep up with DB migrations,
so that users have access to all non-private columns, and private data is not exposed.

    For each software deploy
    - Note the schema number before and after the deploy.
    - Update the privileges file to accomodate changes in the schema.

