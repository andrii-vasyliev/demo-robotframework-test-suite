"""
JSON schema definitions for the API Customers

https://json-schema.org/understanding-json-schema/reference
"""

JSD_API_ERROR = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://example.com/product.schema.json",
    "title": "Error",
    "description": "Error",
    "type": "object",
    "required": ["detail"],
    "additionalProperties": False,
    "properties": {
        "detail": {
            "description": "List of errors",
            "type": "array",
            "minItems": 1,
            "uniqueItems": True,
            "items": {"$ref": "#/definitions/error"},
        },
    },
    "definitions": {
        "error": {
            "description": "Error",
            "type": "object",
            "required": ["loc", "msg", "type"],
            "additionalProperties": False,
            "properties": {
                "loc": {
                    "description": "Location of error",
                    "type": "array",
                    "minItems": 1,
                    "uniqueItems": True,
                    "items": {"type": ["string", "integer"]},
                },
                "input": {
                    "description": "Input value",
                    "oneOf": [{"type": "object"}, {"type": "string"}, {"type": "null"}],
                },
                "msg": {"description": "Error message", "type": "string"},
                "type": {"description": "Error type", "type": "string"},
                "url": {
                    "description": "Documentation URL for the validation error",
                    "type": "string",
                },
                "ctx": {
                    "description": "Context of error",
                    "type": "object",
                },
            },
        }
    },
}
