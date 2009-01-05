# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081231001231) do

  create_table "comment_messages", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "meal_id"
    t.integer  "user_id"
    t.text     "the_comment"
    t.integer  "rating",      :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tasting"
  end

  add_index "comments", ["meal_id"], :name => "index_comments_on_meal_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "emails", :force => true do |t|
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription",  :default => 0
    t.string   "from"
  end

  create_table "foods", :force => true do |t|
    t.string   "food_group_id"
    t.string   "description"
    t.string   "short_description"
    t.string   "common_name"
    t.string   "manufacturer"
    t.string   "survey"
    t.string   "ref_desc"
    t.string   "refuse"
    t.string   "sci_name"
    t.string   "n_factor"
    t.string   "pro_factor"
    t.string   "fat_factor"
    t.string   "cho_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "foods", ["description"], :name => "description"
  add_index "foods", ["food_group_id"], :name => "index_foods_on_food_group_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", :force => true do |t|
    t.integer  "recipe_id"
    t.string   "ingredient"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "code"
    t.integer  "reciever_user_id"
    t.integer  "sender_user_id"
    t.integer  "count"
    t.string   "reciever_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invite_lists", ["invitation_id"], :name => "index_invite_lists_on_invitation_id"
  add_index "invite_lists", ["user_id"], :name => "index_invite_lists_on_user_id"

  create_table "invite_users", :force => true do |t|
    t.integer "invite_id"
    t.integer "user_id"
  end

  add_index "invite_users", ["invite_id"], :name => "index_invite_users_on_invite_id"
  add_index "invite_users", ["user_id"], :name => "index_invite_users_on_user_id"

  create_table "meal_foods", :force => true do |t|
    t.integer  "meal_id"
    t.integer  "food_id"
    t.integer  "weight_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meals", :force => true do |t|
    t.integer  "user_id"
    t.string   "post"
    t.integer  "number_of_comments",                                :default => 0
    t.integer  "number_of_recipes",                                 :default => 0
    t.float    "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meal_type"
    t.float    "tasting"
    t.decimal  "fat",                :precision => 20, :scale => 5
    t.decimal  "calories",           :precision => 20, :scale => 5
    t.decimal  "carbs",              :precision => 20, :scale => 5
    t.decimal  "protein",            :precision => 20, :scale => 5
  end

  add_index "meals", ["user_id"], :name => "index_meals_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.integer  "object_id"
    t.string   "friend_name"
    t.string   "user_name"
    t.string   "o_type"
    t.string   "param_one"
    t.string   "param_two"
    t.string   "param_three"
    t.string   "param_four"
    t.string   "param_five"
    t.string   "params_six"
    t.string   "params_seven"
    t.string   "param_eight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nutrient_datas", :force => true do |t|
    t.integer "food_id"
    t.integer "nutrient_id"
    t.decimal "nutr_val",    :precision => 20, :scale => 10
  end

  add_index "nutrient_datas", ["food_id"], :name => "index_nutrient_datas_on_food_id"
  add_index "nutrient_datas", ["nutrient_id"], :name => "index_nutrient_datas_on_nutrient_id"

  create_table "nutrients", :force => true do |t|
    t.string   "units"
    t.string   "tagname"
    t.string   "description"
    t.integer  "decimal"
    t.integer  "sr_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "user_id"
    t.string   "image_location"
    t.string   "about"
    t.string   "location"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invite_count",                :default => 10
    t.string   "twitter_username"
    t.string   "twitter_password"
    t.boolean  "twitter_active"
    t.float    "health_avg",                  :default => 0.0
    t.float    "taste_avg",                   :default => 0.0
    t.integer  "comments_with_ratings_total", :default => 0
    t.boolean  "private",                     :default => false
    t.integer  "send_comments",               :default => 0
    t.integer  "send_system_email",           :default => 0
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meal_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["meal_id"], :name => "index_ratings_on_meal_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "recipe_comments", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.text     "the_comment"
    t.integer  "rating",      :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipe_comments", ["recipe_id"], :name => "index_recipe_comments_on_recipe_id"
  add_index "recipe_comments", ["user_id"], :name => "index_recipe_comments_on_user_id"

  create_table "recipe_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipe_ratings", ["recipe_id"], :name => "index_recipe_ratings_on_recipe_id"
  add_index "recipe_ratings", ["user_id"], :name => "index_recipe_ratings_on_user_id"

  create_table "recipe_steps", :force => true do |t|
    t.integer  "recipe_id"
    t.text     "step"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipe_steps", ["recipe_id"], :name => "index_recipe_steps_on_recipe_id"

  create_table "recipes", :force => true do |t|
    t.integer  "meal_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipes", ["meal_id"], :name => "index_recipes_on_meal_id"
  add_index "recipes", ["user_id"], :name => "index_recipes_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tastings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meal_id"
    t.integer  "tasting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tastings", ["meal_id"], :name => "index_tastings_on_meal_id"
  add_index "tastings", ["user_id"], :name => "index_tastings_on_user_id"

  create_table "user_weights", :force => true do |t|
    t.integer  "weight"
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_weights", ["user_id"], :name => "index_user_weights_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "password_reset_code",       :limit => 40
    t.string   "time_zone"
    t.integer  "invalid_email",                           :default => 0
  end

  create_table "weights", :force => true do |t|
    t.integer "food_id"
    t.integer "seq"
    t.integer "amount",    :limit => 10, :precision => 10, :scale => 0
    t.string  "msre_desc"
    t.decimal "gm_wgt",                  :precision => 8,  :scale => 4
  end

  add_index "weights", ["food_id"], :name => "index_weights_on_food_id"

end
