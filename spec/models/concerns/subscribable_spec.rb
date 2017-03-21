describe 'Subscribable' do
  with_model :WithSubscribable do
    table do |t|
      t.references :user
      t.integer :subscribable_id
      t.string :subscribable_type
    end

    model do
      include Subscribable
    end

    def user

    end
  end

  let(:owner) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:subscribable) { WithSubscribable.create }

  it 'user can subscribe' do
    expect { subscribable.subscribe!(user1) }.to change(Subscription, :count).by(1)
  end

  it 'user can not subscribe if he subscribed' do
    subscribable.subscribe!(user1)
    expect { subscribable.subscribe!(user1) }.to_not change(Subscription, :count)
  end

  it 'user can unsubscribe' do
    subscribable.subscribe!(user1)
    expect { subscribable.unsubscribe!(user1) }.to change(Subscription, :count).by(-1)
  end

  it 'user can not unsubscribe if he not subscribed' do
    expect { subscribable.unsubscribe!(user1) }.to_not change(Subscription, :count)
  end
end