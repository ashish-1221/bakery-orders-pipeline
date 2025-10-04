-- creating a named internal stage in BAKERY_DB
use database BAKERY_DB;
use schema ORDERS;
create stage ORDERS_STAGE;
-- uploading csv file into orders_stage using snowsight
-- viewing the contents of the stage
list @ORDERS_STAGE;