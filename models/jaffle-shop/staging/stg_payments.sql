with
    staging as (
        select
            id
            , order_id
            , payment_method
            , amount
            , last_updated_dt
        from {{ source('raw', 'raw_payments') }}
    )

select *
from staging
