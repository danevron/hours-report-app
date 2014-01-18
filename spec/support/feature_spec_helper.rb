module FeatureSpecHelper

  def login_as_admin
    FactoryGirl.create(:role)
    allow(User).to receive(:from_auth).and_return(user = FactoryGirl.build(:user))
    allow(Invitation).to receive(:find_by).and_return(FactoryGirl.create(:invitation))
    login_with_oauth

    user
  end

  def login_with_oauth(service = :google_oauth2)
    visit "/auth/#{service}"
  end
end
