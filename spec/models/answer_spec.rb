require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many :attachments }
  it { should have_many(:comments) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
