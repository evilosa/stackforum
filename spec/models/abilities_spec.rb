require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'When is an guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Vote }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  context 'When is an user' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }

    let(:vote) { create(:vote, user: user) }
    let(:vote_second_user) { create(:vote, user: second_user) }

    # Question
    let(:question) { create(:question, user: user) }
    let(:question_second_user) { create(:question, user: second_user) }

    it { should be_able_to :create, Question }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, question_second_user, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, question_second_user, user: user }

    # Answer
    let(:answer) { create(:answer, user: user) }
    let(:answer_second_user) { create(:answer, user: second_user) }

    it { should be_able_to :create, Answer }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, answer_second_user, user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, answer_second_user, user: user }

    # Comment
    let(:comment) { create(:comment, user: user) }
    let(:comment_second_user) { create(:comment, user: second_user) }

    it { should be_able_to :create, Comment }

    # Attachment
    let(:attachment) { create(:attachment, user: user) }
    let(:attachment_second_user) { create(:attachment, user: second_user) }

    #it { should be_able_to :create, Attachment }

    # Manage all
    it { should_not be_able_to :manage, :all }
  end

  context 'When is an administrator' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end
end