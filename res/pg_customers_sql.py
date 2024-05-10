PG_GET_CUSTOMERS_BY_IDS = """\
SELECT c.id::text as id,
       c.name,
       c.email,
       c.created_at,
       c.created_by,
       c.updated_at,
       c.updated_by
  FROM ecommerce.customers c
 WHERE c.id = ANY(%s)
 ORDER BY c.id
"""
