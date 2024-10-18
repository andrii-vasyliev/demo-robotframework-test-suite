*** Settings ***
Documentation       Project settings

Library             Collections
Library             JSONLibrary
Library             RequestsLibrary
Library             ApplicationLibrary
Library             PostgreSQLLibrary
Library             FakeItLibrary
Resource            rest.resource
Resource            common.resource
Resource            api_common.resource
Resource            api_customers.resource
Resource            api_orders.resource
Resource            pg_customers.resource
Resource            validation.resource
Variables           ../etc/env/${ENV_NAME}.py
