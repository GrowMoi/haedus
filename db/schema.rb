# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180704124652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "achievements", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "label",       null: false
    t.text     "description"
    t.string   "image"
    t.string   "category",    null: false
    t.json     "settings"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "admin_achievements", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "description"
    t.string   "image"
    t.string   "category"
    t.integer  "number"
    t.boolean  "active",      default: true
    t.json     "settings"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "certificates", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "media_url",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "certificates", ["user_id"], name: "index_certificates_on_user_id", using: :btree

  create_table "client_notifications", force: :cascade do |t|
    t.integer  "client_id",                  null: false
    t.integer  "data_type",                  null: false
    t.json     "data"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false
    t.boolean  "opened",     default: false
  end

  add_index "client_notifications", ["client_id"], name: "index_client_notifications_on_client_id", using: :btree

  create_table "client_tutor_recommendations", force: :cascade do |t|
    t.integer  "client_id",               null: false
    t.integer  "tutor_recommendation_id", null: false
    t.string   "status",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "client_tutor_recommendations", ["client_id"], name: "index_client_tutor_recommendations_on_client_id", using: :btree
  add_index "client_tutor_recommendations", ["status"], name: "index_client_tutor_recommendations_on_status", using: :btree
  add_index "client_tutor_recommendations", ["tutor_recommendation_id"], name: "index_client_tutor_recommendations_on_tutor_recommendation_id", using: :btree

  create_table "content_favorites", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_favorites", ["content_id"], name: "index_content_favorites_on_content_id", using: :btree
  add_index "content_favorites", ["user_id"], name: "index_content_favorites_on_user_id", using: :btree

  create_table "content_importings", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.string   "status",                             null: false
    t.string   "file"
    t.text     "imported_contents_ids", default: [],              array: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "content_importings", ["user_id"], name: "index_content_importings_on_user_id", using: :btree

  create_table "content_learning_final_tests", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.json     "questions",                  null: false
    t.json     "answers"
    t.boolean  "approved",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "content_learning_final_tests", ["user_id"], name: "index_content_learning_final_tests_on_user_id", using: :btree

  create_table "content_learning_quizzes", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.json     "questions",  null: false
    t.json     "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_learning_quizzes", ["player_id"], name: "index_content_learning_quizzes_on_player_id", using: :btree

  create_table "content_learning_tests", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.json     "questions",                  null: false
    t.json     "answers"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "completed",  default: false
  end

  add_index "content_learning_tests", ["completed"], name: "index_content_learning_tests_on_completed", using: :btree
  add_index "content_learning_tests", ["user_id"], name: "index_content_learning_tests_on_user_id", using: :btree

  create_table "content_learnings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "neuron_id",  null: false
  end

  add_index "content_learnings", ["content_id"], name: "index_content_learnings_on_content_id", using: :btree
  add_index "content_learnings", ["neuron_id"], name: "index_content_learnings_on_neuron_id", using: :btree
  add_index "content_learnings", ["user_id"], name: "index_content_learnings_on_user_id", using: :btree

  create_table "content_links", force: :cascade do |t|
    t.integer  "content_id", null: false
    t.string   "link",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_links", ["content_id"], name: "index_content_links_on_content_id", using: :btree

  create_table "content_media", force: :cascade do |t|
    t.string   "media"
    t.integer  "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_media", ["content_id"], name: "index_content_media_on_content_id", using: :btree

  create_table "content_notes", force: :cascade do |t|
    t.integer  "content_id", null: false
    t.integer  "user_id",    null: false
    t.text     "note",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_notes", ["content_id"], name: "index_content_notes_on_content_id", using: :btree
  add_index "content_notes", ["user_id"], name: "index_content_notes_on_user_id", using: :btree

  create_table "content_reading_times", force: :cascade do |t|
    t.integer  "content_id", null: false
    t.integer  "user_id",    null: false
    t.float    "time",       null: false
    t.datetime "created_at", null: false
  end

  add_index "content_reading_times", ["content_id"], name: "index_content_reading_times_on_content_id", using: :btree
  add_index "content_reading_times", ["user_id"], name: "index_content_reading_times_on_user_id", using: :btree

  create_table "content_readings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "neuron_id",  null: false
  end

  add_index "content_readings", ["content_id"], name: "index_content_readings_on_content_id", using: :btree
  add_index "content_readings", ["neuron_id"], name: "index_content_readings_on_neuron_id", using: :btree
  add_index "content_readings", ["user_id"], name: "index_content_readings_on_user_id", using: :btree

  create_table "content_tasks", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "content_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false
  end

  add_index "content_tasks", ["content_id"], name: "index_content_tasks_on_content_id", using: :btree
  add_index "content_tasks", ["user_id"], name: "index_content_tasks_on_user_id", using: :btree

  create_table "content_tutor_recommendations", force: :cascade do |t|
    t.integer  "content_id",              null: false
    t.integer  "tutor_recommendation_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "content_tutor_recommendations", ["content_id"], name: "index_content_tutor_recommendations_on_content_id", using: :btree
  add_index "content_tutor_recommendations", ["tutor_recommendation_id"], name: "index_content_tutor_recommendations_on_tutor_recommendation_id", using: :btree

  create_table "content_videos", force: :cascade do |t|
    t.integer  "content_id", null: false
    t.string   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_videos", ["content_id"], name: "index_content_videos_on_content_id", using: :btree

  create_table "contents", force: :cascade do |t|
    t.integer  "level",                       null: false
    t.string   "kind",                        null: false
    t.text     "description",                 null: false
    t.integer  "neuron_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "source"
    t.boolean  "approved",    default: false
    t.string   "title"
    t.integer  "media_count", default: 0
  end

  add_index "contents", ["media_count"], name: "index_contents_on_media_count", using: :btree
  add_index "contents", ["neuron_id"], name: "index_contents_on_neuron_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "leaderboards", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.integer  "time_elapsed",    limit: 8, default: 0
    t.integer  "contents_learnt",           default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "leaderboards", ["user_id"], name: "index_leaderboards_on_user_id", using: :btree

  create_table "level_quizzes", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "description"
    t.text     "content_ids", default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "created_by"
  end

  create_table "neurons", force: :cascade do |t|
    t.string   "title",                                  null: false
    t.integer  "parent_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "active",                 default: false
    t.boolean  "deleted",                default: false
    t.boolean  "is_public",              default: false
    t.integer  "position",               default: 0
    t.integer  "pending_contents_count", default: 0
  end

  add_index "neurons", ["deleted"], name: "index_neurons_on_deleted", using: :btree
  add_index "neurons", ["parent_id"], name: "index_neurons_on_parent_id", using: :btree
  add_index "neurons", ["pending_contents_count"], name: "index_neurons_on_pending_contents_count", using: :btree
  add_index "neurons", ["position"], name: "index_neurons_on_position", using: :btree
  add_index "neurons", ["title"], name: "index_neurons_on_title", using: :btree

  create_table "notification_links", force: :cascade do |t|
    t.integer  "notification_id", null: false
    t.string   "link"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notification_links", ["notification_id"], name: "index_notification_links_on_notification_id", using: :btree

  create_table "notification_media", force: :cascade do |t|
    t.string   "media"
    t.integer  "notification_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notification_media", ["notification_id"], name: "index_notification_media_on_notification_id", using: :btree

  create_table "notification_videos", force: :cascade do |t|
    t.integer  "notification_id", null: false
    t.string   "url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notification_videos", ["notification_id"], name: "index_notification_videos_on_notification_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "media_count", default: 0
    t.integer  "user_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "client_id"
    t.string   "data_type"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "payment_id"
    t.string   "source"
    t.float    "total"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code_item"
    t.integer  "quantity",   default: 1
    t.integer  "product_id"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",       null: false
    t.float    "score"
    t.integer  "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "client_id"
  end

  add_index "players", ["quiz_id"], name: "index_players_on_quiz_id", using: :btree

  create_table "possible_answers", force: :cascade do |t|
    t.integer  "content_id",                 null: false
    t.string   "text",                       null: false
    t.boolean  "correct",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "possible_answers", ["content_id"], name: "index_possible_answers_on_content_id", using: :btree
  add_index "possible_answers", ["correct"], name: "index_possible_answers_on_correct", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "category"
    t.string   "description"
    t.string   "key"
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.text     "biography"
    t.integer  "user_id",                 null: false
    t.text     "neuron_ids", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "level_quiz_id", null: false
    t.integer  "created_by"
  end

  add_index "quizzes", ["level_quiz_id"], name: "index_quizzes_on_level_quiz_id", using: :btree

  create_table "read_notifications", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "notifications_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "read_notifications", ["notifications_id"], name: "index_read_notifications_on_notifications_id", using: :btree
  add_index "read_notifications", ["user_id"], name: "index_read_notifications_on_user_id", using: :btree

  create_table "search_engines", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "slug",                      null: false
    t.boolean  "active",     default: true
    t.string   "gcse_id",                   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "search_engines", ["gcse_id"], name: "index_search_engines_on_gcse_id", unique: true, using: :btree
  add_index "search_engines", ["slug"], name: "index_search_engines_on_slug", unique: true, using: :btree

  create_table "social_sharings", force: :cascade do |t|
    t.string   "titulo",       null: false
    t.string   "descripcion"
    t.string   "uri",          null: false
    t.string   "imagen_url"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "social_sharings", ["slug"], name: "index_social_sharings_on_slug", using: :btree
  add_index "social_sharings", ["user_id"], name: "index_social_sharings_on_user_id", using: :btree

  create_table "spellcheck_analyses", force: :cascade do |t|
    t.string   "attr_name",                       null: false
    t.json     "words",           default: []
    t.integer  "analysable_id",                   null: false
    t.string   "analysable_type",                 null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "success",         default: false
  end

  add_index "spellcheck_analyses", ["analysable_id", "analysable_type"], name: "index_spellcheck_analyses_on_analysable_id_and_analysable_type", using: :btree

  create_table "storages", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.json     "frontendValues"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "storages", ["user_id"], name: "index_storages_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tutor_achievements", force: :cascade do |t|
    t.integer  "tutor_id",    null: false
    t.string   "name",        null: false
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tutor_achievements", ["tutor_id"], name: "index_tutor_achievements_on_tutor_id", using: :btree

  create_table "tutor_recommendations", force: :cascade do |t|
    t.integer  "tutor_id",             null: false
    t.integer  "tutor_achievement_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "tutor_recommendations", ["tutor_achievement_id"], name: "index_tutor_recommendations_on_tutor_achievement_id", using: :btree
  add_index "tutor_recommendations", ["tutor_id"], name: "index_tutor_recommendations_on_tutor_id", using: :btree

  create_table "user_achievements", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "achievement_id", null: false
    t.json     "meta"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_achievements", ["achievement_id"], name: "index_user_achievements_on_achievement_id", using: :btree
  add_index "user_achievements", ["user_id"], name: "index_user_achievements_on_user_id", using: :btree

  create_table "user_admin_achievements", force: :cascade do |t|
    t.integer  "user_id",                              null: false
    t.integer  "admin_achievement_id",                 null: false
    t.boolean  "active",               default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "user_admin_achievements", ["admin_achievement_id"], name: "index_user_admin_achievements_on_admin_achievement_id", using: :btree
  add_index "user_admin_achievements", ["user_id"], name: "index_user_admin_achievements_on_user_id", using: :btree

  create_table "user_content_preferences", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "kind",                   null: false
    t.integer  "level",      default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "order"
  end

  add_index "user_content_preferences", ["user_id"], name: "index_user_content_preferences_on_user_id", using: :btree

  create_table "user_seen_images", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "media_url",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_seen_images", ["user_id"], name: "index_user_seen_images_on_user_id", using: :btree

  create_table "user_tutors", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "tutor_id",   null: false
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_tutors", ["status"], name: "index_user_tutors_on_status", using: :btree
  add_index "user_tutors", ["tutor_id"], name: "index_user_tutors_on_tutor_id", using: :btree
  add_index "user_tutors", ["user_id"], name: "index_user_tutors_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                      null: false
    t.string   "encrypted_password",     default: "",                      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "role",                   default: "cliente",               null: false
    t.string   "uid",                    default: "md5((random())::text)", null: false
    t.string   "provider",               default: "email",                 null: false
    t.json     "tokens"
    t.date     "birthday"
    t.string   "city"
    t.string   "country"
    t.string   "tree_image"
    t.string   "school"
    t.string   "username"
    t.string   "authorization_key"
    t.integer  "age"
  end

  add_index "users", ["authorization_key"], name: "index_users_on_authorization_key", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "owner_id"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["owner_id"], name: "index_versions_on_owner_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "client_notifications", "users", column: "client_id"
  add_foreign_key "client_tutor_recommendations", "users", column: "client_id"
  add_foreign_key "content_importings", "users"
  add_foreign_key "content_learning_final_tests", "users"
  add_foreign_key "content_learning_quizzes", "players"
  add_foreign_key "content_learning_tests", "users"
  add_foreign_key "content_learnings", "contents"
  add_foreign_key "content_learnings", "neurons"
  add_foreign_key "content_learnings", "users"
  add_foreign_key "content_links", "contents"
  add_foreign_key "content_media", "contents"
  add_foreign_key "content_notes", "contents"
  add_foreign_key "content_notes", "users"
  add_foreign_key "content_reading_times", "contents"
  add_foreign_key "content_reading_times", "users"
  add_foreign_key "content_readings", "contents"
  add_foreign_key "content_readings", "neurons"
  add_foreign_key "content_readings", "users"
  add_foreign_key "content_videos", "contents"
  add_foreign_key "level_quizzes", "users", column: "created_by"
  add_foreign_key "notification_links", "notifications"
  add_foreign_key "notification_media", "notifications"
  add_foreign_key "notification_videos", "notifications"
  add_foreign_key "notifications", "users", column: "client_id"
  add_foreign_key "players", "quizzes"
  add_foreign_key "players", "users", column: "client_id"
  add_foreign_key "possible_answers", "contents"
  add_foreign_key "profiles", "users"
  add_foreign_key "quizzes", "level_quizzes"
  add_foreign_key "quizzes", "users", column: "created_by"
  add_foreign_key "social_sharings", "users"
  add_foreign_key "tutor_achievements", "users", column: "tutor_id"
  add_foreign_key "tutor_recommendations", "users", column: "tutor_id"
  add_foreign_key "user_content_preferences", "users"
  add_foreign_key "user_tutors", "users"
  add_foreign_key "user_tutors", "users", column: "tutor_id"
  add_foreign_key "versions", "users", column: "owner_id"
end
