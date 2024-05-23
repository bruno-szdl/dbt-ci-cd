with
    staging as (
        select
            id
            , user_id
            , order_date
            , status
            , last_updated_dt
        from {{ source('raw', 'raw_orders') }}
    )

select *
from staging
