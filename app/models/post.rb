class Post < ApplicationRecord
  belongs_to :user
  belongs_to :type
  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
end
