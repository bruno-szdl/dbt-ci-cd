-- Adding incremental materialization to test out CI
{{ config(
    materialized='incremental'
    , unique_key='id'
) }}

with
    stg_orders as (
        select
            id
            , user_id
            , order_date
            , status
            , last_updated_dt
        from {{ ref('stg_orders') }}
    )
    
    , stg_payments as (
        select
            id
            , order_id
            , payment_method
            , amount
        from {{ ref('stg_payments') }}
        {% if is_incremental %}
        {% endif %}
    )
    
    , payment_methods_agg as (
        select
            order_id
            , string_agg(payment_method) as payment_methods
            , sum(amount) as amount
        from stg_payments
        group by order_id
    )
    
    , joined as (
        select
            stg_orders.id
            , stg_orders.user_id
            , stg_orders.order_date
            , stg_orders.status
            , payment_methods_agg.payment_methods
            , payment_methods_agg.amount
        from stg_orders
        left join payment_methods_agg
            on stg_orders.id = payment_methods_agg.order_id
    )

select *
from joined
