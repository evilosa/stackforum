require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { should have_many(:answers) }
end
