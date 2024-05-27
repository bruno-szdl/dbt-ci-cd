{% macro drop_pr_schema(pr_number) %}

    {% set query %}
        drop schema pr_{{ pr_number }}
    {% endset %}

    {{ run_query (query) }}

{% endmacro %}