# ECommerce-API

### Restart database
```bash
rails db:drop db:create db:migrate
```

### Populate database
```sql
INSERT INTO
  "products" ("name", "price", "created_at", "updated_at")
VALUES
  ('Nike shoes air II', 150, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991'),
  ('Calvin Klein T-Shirt', 200, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991');

INSERT INTO
  "inventories" (
    "supplier",
    "quantity",
    "created_at",
    "updated_at"
  )
VALUES
  ('Nike', 10, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991'),
  ('Calvin Klein', 15, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991');


INSERT INTO
  "inventories_products" ("product_id", "inventory_id")
VALUES
  (1, 1), (2, 2);
  
INSERT INTO
  "orders" ("created_at", "updated_at", "status")
VALUES
  ('2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991', 'pending');

INSERT INTO
  "order_items" (
    "order_id",
    "product_id",
    "inventory_id",
    "quantity",
    "created_at",
    "updated_at"
  )
VALUES
  (1, 1, 1, 2, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991'),
  (1, 2, 2, 20, '2024-05-13 11:42:01.695991', '2024-05-13 11:42:01.695991');
```

### Transaction
```sql
SELECT
  orders.id as order_id,
  order_items.id as order_item_id,
  order_items.quantity as order_item_quantity,
  orders.status as order_status,
  products.name as product_name,
  inventories.supplier as supplier,
  inventories.quantity as quantity
FROM
  order_items
  INNER JOIN orders ON orders.id = order_items.order_id
  INNER JOIN products ON products.id = order_items.product_id
  INNER JOIN inventories_products ON inventories_products.product_id = products.id
  INNER JOIN inventories ON inventories.id = inventories_products.inventory_id
WHERE
  orders.id = 1;

UPDATE
  order_items
SET
  quantity = 10
WHERE
  id = 2;

BEGIN TRANSACTION;

UPDATE
  orders
SET
  status = 'confirmed'
WHERE
  id = 1;

UPDATE
  inventories
SET
  quantity = quantity - (
    SELECT
      SUM(order_items.quantity)
    FROM
      order_items
      JOIN orders ON orders.id = order_items.order_id
    WHERE
      order_items.inventory_id = inventories.id
      AND orders.id = 1
  )
WHERE
  id IN (
    SELECT
      order_items.inventory_id
    FROM
      order_items
      JOIN orders ON orders.id = order_items.order_id
    WHERE
      orders.id = 1
  );

COMMIT;
```
