    /*
    Merging data from the staging table into the target table
    */
    -- creating a target table
use database bakery_db;
use schema orders;
create
    or replace table customers_orders (
        customer varchar,
        order_date date,
        delivery_date date,
        baked_good_type varchar,
        quantity number,
        source_file_name varchar,
        load_ts timestamp
    );
-- to ensure only recored per customer merging data from
    -- the orders_stg into the customers_orders target table
    merge into customers_orders tgt using orders_stg src on src.customer = tgt.customer
    and src.delivery_date = tgt.delivery_date
    and src.baked_good_type = tgt.baked_good_type
    when matched then
update
set
    tgt.quantity = src.quantity,
    tgt.source_file_name = src.source_file_name,
    tgt.load_ts = current_timestamp()
    when not matched then
insert
    (
        customer,
        order_date,
        delivery_date,
        baked_good_type,
        quantity,
        source_file_name,
        load_ts
    )
values
    (
        src.customer,
        src.order_date,
        src.delivery_date,
        src.baked_good_type,
        src.quantity,
        src.source_file_name,
        current_timestamp()
    );