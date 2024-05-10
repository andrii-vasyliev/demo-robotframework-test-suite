"""
JSON schema definitions for the API Orders

https://json-schema.org/understanding-json-schema/reference
"""

JSD_CREATE_ORDER_SUCCESS = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://example.com/product.schema.json",
    "title": "Order",
    "description": "Order object",
    "type": "object",
    "required": ["id", "status", "created", "order_items"],
    "additionalProperties": False,
    "properties": {
        "id": {"description": "Order ID", "type": "string", "format": "uuid"},
        "status": {"description": "Order Status", "type": "string", "enum": ["new"]},
        "created": {
            "description": "Order Created Date",
            "type": "string",
            "format": "date-time",
        },
        "order_items": {
            "description": "List of Order Items",
            "type": "array",
            "minItems": 0,
            "uniqueItems": False,
            "items": {"$ref": "#/definitions/orderItem"},
        },
    },
    "definitions": {
        "orderItem": {
            "description": "Order Item",
            "type": "object",
            "additionalProperties": False,
            "properties": {
                "id": {
                    "description": "Unique Order Item ID",
                    "type": "string",
                    "format": "uuid",
                },
                "item_id": {
                    "description": "Unique Item ID",
                    "type": "string",
                    "format": "uuid",
                },
                "name": {"description": "Item Name", "type": "string"},
                "price": {"description": "Item Price", "type": "number"},
                "quantity": {
                    "description": "Item Quantity",
                    "type": "integer",
                    "minimum": 1,
                },
            },
        }
    },
}
