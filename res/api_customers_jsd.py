"""
JSON schema definitions for the API Customers

https://json-schema.org/understanding-json-schema/reference
"""

JSD_CREATE_CUSTOMER_SUCCESS = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://example.com/product.schema.json",
    "title": "Customer",
    "description": "Customer object",
    "type": "object",
    "required": ["id", "name", "email"],
    "additionalProperties": False,
    "properties": {
        "id": {
            "description": "Unique Customer ID",
            "type": "string",
            "format": "uuid",
        },
        "name": {
            "description": "Customer Name",
            "type": "string",
        },
        "email": {
            "description": "Customer Email",
            "oneOf": [
                {
                    "type": "string",
                    "format": "email",
                },
                {
                    "type": "null",
                },
            ],
        },
    },
}

JSD_GET_CUSTOMERS_SUCCESS = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://example.com/product.schema.json",
    "title": "Customers",
    "description": "List of Customer objects",
    "required": ["customers"],
    "additionalProperties": False,
    "properties": {
        "customers": {
            "description": "List of Customers",
            "type": "array",
            "minItems": 0,
            "uniqueItems": True,
            "items": {"$ref": "#/definitions/customer"},
        }
    },
    "definitions": {
        "customer": {
            "description": "Customer",
            "type": "object",
            "required": ["id", "name", "email"],
            "additionalProperties": False,
            "properties": {
                "id": {
                    "description": "Unique Customer ID",
                    "type": "string",
                    "format": "uuid",
                },
                "name": {
                    "description": "Customer Name",
                    "type": "string",
                },
                "email": {
                    "description": "Customer Email",
                    "oneOf": [
                        {
                            "type": "string",
                            "format": "email",
                        },
                        {
                            "type": "null",
                        },
                    ],
                },
            },
        }
    },
}
