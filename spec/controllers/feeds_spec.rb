require 'rails_helper'

RSpec.describe '#Feeds' do
  it 'adds a feed to followers when an event is created' do
    userA = FactoryGirl.create(:user)
    userB = FactoryGirl.create(:user)
    
    userA.change_status(userB, 'following')
    event = FactoryGirl.create(:event, creator: userB)

    expect(userA.feeds.last.event).to eq(event)
  end

  it 'adds a feed to followers when assisting to an event' do
    userA = FactoryGirl.create(:user)
    userB = FactoryGirl.create(:user)
    
    userA.change_status(userB, 'following')

    event = FactoryGirl.create(:event)
    userB.assist(event)

    expect(userA.feeds.last.event).to eq(event)
  end

  it 'removes the feeds from followers when a user quits assistance to event' do
    userA = FactoryGirl.create(:user)
    userB = FactoryGirl.create(:user)
    
    userA.change_status(userB, 'following')

    event = FactoryGirl.create(:event)
    userB.assist(event)
    userB.quit(event)

    expect(userA.feeds.count).to eq(0)
  end

  it 'removes the feeds from followers when a user deletes an event'
end
