*** Settings ***
Documentation
...                 PosgreSQL API Customers keywords:
...                 - *``PG Get Customers By Ids``*    Gets customers from the PostgreSQL DB by Ids
...

Resource            project_settings.resource
Variables           pg_customers_sql.py


*** Keywords ***
PG Get Customers By Ids
    [Documentation]
    ...    Gets customers from the PostgreSQL DB by Ids
    ...
    ...    Parameters:
    ...    - *``@customer_ids``*    positional arguments that represent a list of customer Ids
    ...
    [Arguments]    @{customer_ids}
    ${params}    Create List    ${customer_ids}
    ${result}    Pgsql Query    ${PG_GET_CUSTOMERS_BY_IDS}    ${params}
    Should Not Be Empty    ${result}    PgSQL: No customers found
    RETURN    ${result}
