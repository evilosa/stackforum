describe 'Votable' do
  with_model :WithVotable do
    table do |t|
      t.integer :votable_id
      t.integer :status, default: 0
      t.string :votable_type
    end

    model do
      include Votable

      def user
      end
    end

  end

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }
  let!(:user5) { create(:user) }
  let(:votable) { WithVotable.create }

  it 'user can upvote' do
    votable.upvote! user1
    expect(votable.score).to eq 1
  end

  it 'user can downvote' do
    votable.downvote! user1
    expect(votable.score).to eq -1
  end

  it 'user can not upvote two times' do
    votable.upvote! user1
    votable.upvote! user1
    expect(votable.score).to eq 1
  end

  it 'user can not downvote two times' do
    votable.downvote! user1
    votable.downvote! user1
    expect(votable.score).to eq -1
  end

  it 'user can change vote' do
    votable.upvote! user1
    expect(votable.score).to eq 1
    votable.downvote! user1
    expect(votable.score).to eq -1
  end

  it 'should have score' do
    expect(votable.score).to eq 0
    votable.upvote! user1
    expect(votable.score).to eq 1
    votable.upvote! user2
    expect(votable.score).to eq 2
    votable.downvote! user3
    expect(votable.score).to eq 1
  end
end