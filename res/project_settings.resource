*** Settings ***
Documentation       Project settings

Library             Collections
Library             JSONLibrary
Library             RequestsLibrary
Library             FakerLibrary    locale=pl_PL
Library             ApplicationLibrary
Library             PostgreSQLLibrary
Library             suite_context
Library             test_context
Resource            common.resource
Resource            rest.robot
Resource            api_common.resource
Resource            api_customers.resource
Resource            api_orders.resource
Resource            pg_customers.resource
Resource            validation.resource
Variables           ../etc/env/${ENV_NAME}.py
