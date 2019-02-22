require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('ciro@gmail.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do 
    it 'returns email and created_at and Token' do 
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('aduiewi866IN65jdfsa')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: aduiewi866IN65jdfsa")
    end
  end
end
