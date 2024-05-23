with
    stg_customers as (
        select
            id
            , first_name
            , last_name
            , last_updated_dt
            , country_code
            , dbt_valid_to
            , dbt_valid_from
        from {{ ref('stg_customers') }}
    )
    
    , country_codes as (
        select
            code
            , name
        from {{ ref('country_codes') }}
    )
    
    , joined as (
        select
            stg_customers.id
            , stg_customers.first_name
            , stg_customers.last_name
            , country_codes.name as country_name
            , stg_customers.last_updated_dt
            , stg_customers.dbt_valid_from
            , stg_customers.dbt_valid_to
        from stg_customers
        left join country_codes
            on stg_customers.country_code = country_codes.code
    )

select *
from joined
