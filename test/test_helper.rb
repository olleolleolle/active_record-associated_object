# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "active_record"
require "active_record/associated_object"
require "kredis"
require "active_job"
require "logger"

require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end

  create_table :comments, force: true do |t|
    t.integer :post_id
  end
end

# Shim what an app integration would look like.
class ApplicationRecord; end
class ApplicationRecord::AssociatedObject < ActiveRecord::AssociatedObject
  include GlobalID::Integration, Kredis::Attributes
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Post::Publisher < ApplicationRecord::AssociatedObject
end
