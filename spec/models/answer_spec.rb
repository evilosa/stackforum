require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:question) }
end
