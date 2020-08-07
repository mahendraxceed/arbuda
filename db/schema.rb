# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_29_053712) do

  create_table "complain_status_transitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "complain_id"
    t.string "namespace", limit: 50
    t.string "event", limit: 50
    t.string "from", limit: 50
    t.string "to", limit: 50, null: false
    t.string "change_description", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.index ["complain_id"], name: "index_complain_status_transitions_on_complain_id"
  end

  create_table "complains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "customer_id"
    t.integer "ticketid", null: false
    t.string "person_called", limit: 100
    t.bigint "assigned_to_id"
    t.string "subject", limit: 100, null: false
    t.text "description", null: false
    t.string "priority", limit: 50, null: false
    t.datetime "due_by", null: false
    t.string "category", limit: 50, null: false
    t.string "status", limit: 50, null: false
    t.text "comment"
    t.string "updated_from_ip", limit: 50, null: false
    t.bigint "created_by_id", null: false, unsigned: true
    t.bigint "updated_by_id", null: false, unsigned: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assigned_to_id"], name: "index_complains_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_complains_on_created_by_id"
    t.index ["customer_id"], name: "index_complains_on_customer_id"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "mobile"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name"
    t.string "mobile"
    t.boolean "admin"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "complain_status_transitions", "complains"
  add_foreign_key "complains", "customers"
  add_foreign_key "complains", "users", column: "assigned_to_id"
end
