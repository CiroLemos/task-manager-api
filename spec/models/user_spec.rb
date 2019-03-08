require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
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

  describe '#generate_authentication_token!' do
    it 'generates a unique auth token' do 
      allow(Devise).to receive(:friendly_token).and_return('aduiewi866IN65jdfsa')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('aduiewi866IN65jdfsa')
    end

    it 'generates another auth token when the current auth token already has been taken' do 
      allow(Devise).to receive(:friendly_token).and_return('adfjka3439fdjal', 'adfjka3439fdjal', 'daajfkfda8954003')
      existing_user = create(:user)
      user.generate_authentication_token!
      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
