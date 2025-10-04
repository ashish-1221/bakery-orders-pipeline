/*
Creating a task PROCESS_ORDERS which executes the following steps
1. truncate the staging table
2. load data from internal stage into the staging table using copy command.
3. merge data from the staging table into the target table
4. truncate the summary table
5. insert the summarized data into the summary table
*/
use database bakery_db;
use schema orders;
create task PROCESS_ORDERS warehouse = bakery_wh schedule = '10 M' as begin truncate table orders_stg;
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
truncate table summary_orders;
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
end;
-- giving execution task privilege too sys admin
use role accountadmin;
grant execute task on account to role sysadmin;
use role sysadmin;
execute task process_orders;
-- viewing previous and scheduled task execution
select
    *
from
    table(information_schema.task_history())
where
    name = 'PROCESS_ORDERS'
order by
    scheduled_time desc;
-- resume the task process_orders
    alter task process_orders resume;
-- CHANGING THE schedule time
    alter task PROCESS_ORDERS suspend;
alter task PROCESS_ORDERS
set
    schedule = '3 M';
alter task PROCESS_ORDERS resume;
--closing the task
    alter task process_orders suspend;