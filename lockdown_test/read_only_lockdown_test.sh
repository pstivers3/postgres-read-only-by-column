#!/bin/bash

# usage: ./<script name> <read-only user name>

user=$1

if [ "$user" = user1 ] || [ "$user" = user2 ]; then
    echo "User is \"${user}\" which is NOT a read-only user. Exiting."
    exit 1
fi

while true; do
    read -p "User is \"${user}\". Is this a read-only user? y/n " answer
    case $answer in
        [Yy]* ) break ;;
        [Nn]* ) echo "exiting"; exit 1 ;;
         * ) echo "Please answer y or n" ;;
    esac
done

echo "run read_only_lockdown_test.sql" 
psql -h rds.example.net -d database1 -U $user --echo-all --file=read_only_lockdown_test.sql

echo -e "\n ** begin dump tests **"

echo -e "\ncan dump table with no PII (schema_info table)"
echo "dumping schema_info table"
pg_dump -h rds.example.net -d database1 -U $user -t schema_info -f schema_info_dump
echo "removing schema_info_dump file"
rm schema_info_dump

echo -e "\ncan NOT dump table that has columns that are not granted (table2)"
pg_dump -h rds.example.net -d database1 -U $user -t table3 -f table3_dump

echo -e "\ncan NOT dump table that is not granted (table3)"
pg_dump -h rds.example.net -d database1 -U $user -t table3 -f table3_dump

echo -e "\ncan NOT dump database1 database that has tables or columns that are not granted"
pg_dump -h rds.example.net -d database1 -U $user -f database1_dump


