class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'Users'
end
