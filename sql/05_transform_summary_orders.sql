
    /*
    Transforming data with SQL
    */
    -- creating summary_orders table
use database bakery_db;
use schema orders;
create table summary_orders(
        delivery_date date,
        baked_good_type varchar,
        total_quantity number
    ) truncate table summary_orders;
insert into
    summary_orders(delivery_date, baked_good_type, total_quantity)
select
    delivery_date,
    baked_good_type,
    sum(quantity) as total_quantity
from
    customers_orders
group by
    all;