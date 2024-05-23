{% snapshot snapshot_customers %}

{{
    config(
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='last_updated_dt',
    )
}}

select * from {{ source('raw', 'raw_customers') }}

{% endsnapshot %}