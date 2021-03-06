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

ActiveRecord::Schema.define(version: 20180131145156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliate_links", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "affiliate_id"
    t.integer  "signups",          default: 0
    t.string   "url"
    t.string   "slug"
    t.string   "name"
    t.text     "sign_up_message"
    t.text     "upgrade_message"
    t.string   "code"
    t.boolean  "active",           default: true
    t.string   "data_amount",      default: "75000"
    t.string   "data_currency",    default: "ntd"
    t.string   "data_description", default: "英文學校課程費用"
    t.string   "stripe_plan_id",   default: "1"
  end

  create_table "affiliate_payments", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "paid_date"
    t.text     "details"
    t.string   "receipt_number"
    t.string   "amount"
    t.string   "slug"
    t.integer  "affiliate_link_id"
    t.integer  "user_id"
    t.boolean  "paid",              default: false
  end

  create_table "affiliates", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "contact_email"
    t.string   "contact_name"
    t.string   "domain"
    t.text     "notes"
    t.string   "slug"
  end

  create_table "article_article_topics", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "article_topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_categories", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "main_image_url"
    t.integer  "user_id"
    t.integer  "category_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "published",      default: false
    t.integer  "view_count",     default: 0
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "choices", force: :cascade do |t|
    t.integer  "question_id"
    t.boolean  "correct"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_notifications", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.boolean  "read",       default: false
    t.string   "message"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.string   "slug"
  end

  create_table "course_course_levels", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "course_level_id"
  end

  create_table "course_levels", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "color"
    t.string   "slug"
  end

  create_table "course_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.boolean  "completed"
    t.boolean  "enrolled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "main_image_url"
    t.boolean  "premium_course", default: true
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",      default: false
    t.text     "preview_text"
  end

  create_table "download_links", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.datetime "first_access"
    t.datetime "most_recent_access"
    t.datetime "downloaded_time"
    t.boolean  "downloaded",         default: false
    t.integer  "download_id"
    t.string   "slug"
  end

  create_table "downloads", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "main_image_url"
    t.string   "title"
    t.string   "description"
    t.boolean  "active",            default: true
    t.string   "file_download_url"
    t.string   "slug"
    t.string   "name"
  end

  create_table "ebooks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "cover_img"
    t.string   "src"
    t.text     "description"
    t.string   "slug"
  end

  create_table "email_signups", force: :cascade do |t|
    t.string   "page",       default: "not_set"
    t.string   "email"
    t.string   "name",       default: "not_given"
    t.string   "campaign",   default: "not_set"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.integer "points"
    t.boolean "completed", default: true
  end

  create_table "lesson_users", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.boolean  "completed",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lesson_vocabulary_words", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id"
    t.integer  "vocabulary_word_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.text     "script_english"
    t.text     "script_chinese"
    t.string   "video_url"
    t.string   "notes_url"
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "lesson_number"
    t.text     "instructions"
    t.boolean  "published",      default: false
    t.integer  "unit_id"
    t.string   "audio_source"
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "points"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read",        default: false
    t.string   "subject",     default: "Message from Admin"
    t.string   "slug"
    t.text     "body"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "stripe_id"
    t.string   "currency"
    t.integer  "user_id"
    t.decimal  "amount"
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "quiz_id"
    t.integer  "value"
    t.text     "body"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer  "lesson_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id"
    t.integer  "user_id"
    t.text     "body"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "subject"
    t.string   "name"
    t.text     "body"
    t.string   "slug"
  end

  create_table "units", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "slug"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "user_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "action_type"
    t.text     "body"
  end

  create_table "user_payments", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "payment_id"
  end

  create_table "user_questions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "choice_id"
  end

  create_table "user_quizzes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_vocabulary_words", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vocabulary_word_id"
    t.datetime "review_time",                  default: '2017-09-12 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "english_to_chinese_attempted", default: 0
    t.integer  "english_to_chinese_correct",   default: 0
    t.integer  "chinese_to_english_attempted", default: 0
    t.integer  "chinese_to_english_correct",   default: 0
    t.integer  "definition_attempted",         default: 0
    t.integer  "definition_correct",           default: 0
    t.integer  "spoken_attempted",             default: 0
    t.integer  "spoken_correct",               default: 0
    t.integer  "spelling_attempted",           default: 0
    t.integer  "spelling_correct",             default: 0
    t.string   "slug"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "role",                 default: "reader"
    t.string   "membership_level",     default: "free"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.integer  "points",               default: 0
    t.integer  "level",                default: 1
    t.string   "picture_url"
    t.string   "slug"
    t.string   "password_reset_token"
    t.integer  "affiliate_link_id"
    t.text     "bio",                  default: "This user has not filled out a bio yet."
    t.string   "stripeid"
    t.string   "subscriptionid"
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "title"
    t.string   "slug"
  end

  create_table "vocabulary_words", force: :cascade do |t|
    t.string   "main"
    t.string   "chinese"
    t.string   "part_of_speech"
    t.string   "ipa"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "sentence"
    t.text     "definition"
    t.string   "vocabulary_wordable_type"
    t.integer  "vocabulary_wordable_id"
  end

end
