{{ config(
    materialized='table'
) }}

with
    staging as (
        select
            id
            , first_name
            , last_name
            , last_updated_dt
            , country_code
            , dbt_valid_to
            , dbt_valid_from
            , row_number() over(
                partition by id
                order by dbt_valid_to desc
            ) as row_num
            --, null as dummy_column_to_test_cicd
            , null as dummy_column_to_test_cicd_2
        from {{ ref('snapshot_customers') }}
    )

select *
from staging
where row_num = 1
