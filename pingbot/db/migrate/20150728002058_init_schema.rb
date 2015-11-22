class InitSchema < ActiveRecord::Migration
  def up
    
    create_table "organizations", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "token"
    end
    
    add_index "organizations", ["token"], name: "index_organizations_on_token", unique: true
    
    create_table "pings", force: :cascade do |t|
      t.string   "uri"
      t.string   "name"
      t.string   "description"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.datetime "unhealthy_at"
      t.integer  "organization_id"
      t.integer  "status",          default: 0
    end
    
    add_index "pings", ["uri"], name: "index_pings_on_uri", unique: true
    
    create_table "users", force: :cascade do |t|
      t.integer  "organization_id"
      t.string   "name"
      t.string   "email"
      t.string   "title"
      t.string   "phone"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end
    
  end

  def down
    raise "Can not revert initial migration"
  end
end
