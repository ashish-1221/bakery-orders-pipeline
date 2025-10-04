# Snowflake ETL Data Pipeline for Bakery Orders

A modular, professional ETL pipeline implemented in Snowflake SQL for ingesting, transforming, and presenting bakery order data. The project demonstrates best practices in data engineering: staged data loading via snowsight, automated task orchestration, and clean schema design.

## Pipeline Overview

This repository implements an ETL pipeline using Snowflake’s native features. It loads CSV order data, stages it, merges new/updated records, summarizes results, and automates everything via tasks.

## Folder Structure
---
```
bakery-orders-pipeline
├─ docs
│  └─ bakery_orders_pipeline.jpg
├─ README.md
├─ sample_data
│  └─ Orders_2023-07-07.csv
└─ sql
   ├─ 01_init_roles_warehouses.sql
   ├─ 02_stage_creation.sql
   ├─ 03_load_to_staging_table.sql
   ├─ 04_merge_staging_to_target.sql
   ├─ 05_transform_summary_orders.sql
   ├─ raw.sql
   └─ tasks
      └─ process_orders_task.sql

```

## Setup & Usage

1. Clone this repository.
2. Ensure you have Snowflake access with SYSADMIN role.
3. Upload sample CSV data via Snowsight or Snowflake UI.
4. Execute SQL scripts in the listed order within the `sql/` folder.
5. Use the task file (`process_orders_task.sql`) to automate ETL flow.
6. View results in the transformed tables.

## ETL Pipeline Steps

- **Extraction Layer:** Load CSV files, create internal stage, use COPY INTO for staging.
- **Transformation Layer:** Merge staged data into target table, handle updates/inserts with MERGE.
- **Presentation Layer:** Summarize orders in the final table for reporting and analytics.
- **Automation:** Use Snowflake tasks for scheduled pipeline execution.

## Pipeline Diagram

![Snowflake ETL Pipeline Diagram](docs\bakery_orders_pipeline.jpg)


## Sample Data

Sample orders data for testing is in `sample_data/sample_orders.csv`.
Format:
- Customer
- Order date
- Delivery Date
- Baked good type
- Quantity


## Author

Ashish Prasad Maharana | [maharanaashish72@gmail.com/https://github.com/ashish-1221]
