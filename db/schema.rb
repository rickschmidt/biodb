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

ActiveRecord::Schema.define(:version => 20110126195802) do

  create_table "dnasamples", :force => true do |t|
    t.string   "dna_accession"
    t.string   "dnasample_number"
    t.date     "date"
    t.string   "method"
    t.float    "elution_volume"
    t.string   "second_elute"
    t.float    "second_elute_volumne"
    t.string   "reextracted"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.date     "date"
    t.float    "anneal"
    t.float    "dna_amount"
    t.integer  "total_samples"
    t.string   "notes"
    t.string   "experiment_number"
    t.string   "bsa"
    t.string   "buffer"
    t.string   "mgcl2"
    t.string   "taq"
    t.string   "h2o"
    t.string   "dntps"
    t.string   "dna"
    t.float    "primerl_amount"
    t.float    "primerh_amount"
    t.integer  "total"
    t.string   "primerl"
    t.string   "primerh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genes", :force => true do |t|
    t.string   "genbank"
    t.string   "locus"
    t.string   "primerl"
    t.string   "primerh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pcrs", :force => true do |t|
    t.string   "pcr_tube_number"
    t.string   "gel_image"
    t.date     "date"
    t.float    "anneal_temp"
    t.float    "dna_amount"
    t.string   "conditions"
    t.integer  "total_samples"
    t.string   "notes"
    t.string   "reamp"
    t.integer  "total_worked"
    t.float    "denature"
    t.float    "extension"
    t.float    "cycle"
    t.string   "primerl"
    t.string   "primerh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxonomies", :force => true do |t|
    t.string   "genus"
    t.string   "species"
    t.string   "subspecies"
    t.string   "new_diagnosis"
    t.string   "family"
    t.string   "reference"
    t.string   "description_pdf"
    t.string   "synonyms"
    t.string   "type_museum"
    t.string   "distribution"
    t.string   "ingroup"
    t.string   "other_literature"
    t.string   "character_diagnosis"
    t.string   "description"
    t.string   "countries"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
