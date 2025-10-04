-- loading data from the staged file into the target file
-- viewing the contents of the named stage
select
    $1,
    $2,
    $3,
    $4,
    $5,
    metadata$filename
from
    @orders_stage;
-- loading data from the staged file into a staging table
    -- creating a staging table
    use database bakery_db;
use schema orders;
create
    or replace table orders_stg(
        customer varchar,
        order_date date,
        delivery_date date,
        baked_good_type varchar,
        quantity number,
        source_file_name varchar,
        load_ts timestamp
    ) -- copy command to load file data from the staged file into staging table
    copy into orders_stg
from
    (
        select
            $1,
            $2,
            $3,
            $4,
            $5,
            METADATA$filename,
            CURRENT_TIMESTAMP()
        from
            @orders_stage
    ) file_format = (type = csv, skip_header = 1) on_error = abort_statement purge = true;