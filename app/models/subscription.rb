class Subscription < ApplicationRecord
  validates :user_id, :subscribable_id, :subscribable_type, presence: true

  belongs_to :user
  belongs_to :subscribable, polymorphic: true
end