# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_15_112118) do
  create_table "inventories", force: :cascade do |t|
    t.string "supplier", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier"], name: "index_inventories_on_supplier", unique: true
  end

  create_table "inventories_products", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "inventory_id", null: false
    t.index ["inventory_id"], name: "index_inventories_products_on_inventory_id"
    t.index ["product_id"], name: "index_inventories_products_on_product_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "inventory_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_order_items_on_inventory_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_items_orders", id: false, force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "order_item_id", null: false
    t.index ["order_id"], name: "index_order_items_orders_on_order_id"
    t.index ["order_item_id"], name: "index_order_items_orders_on_order_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "order_items", "inventories"
  add_foreign_key "order_items", "products"
end
