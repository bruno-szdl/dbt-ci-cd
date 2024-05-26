{% macro drop_schema() %}

    {% set query %}
        drop schema {{ target.schema }}
    {% endset %}

    {% if target.name == 'pr' %}
        {{ run_query (query) }}
    {% endif %}

{% endmacro %}