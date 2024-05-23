-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail
select
    id
    , sum(amount)
from {{ ref('fact_orders' )}}
group by 1
having not(sum(amount) >= 0)