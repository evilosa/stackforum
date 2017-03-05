module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :delete_all
    accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true
  end
end