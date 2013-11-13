class User < ActiveRecord::Base
  has_and_belongs_to_many :reports

  validates_uniqueness_of :uid, scope: :provider

  def self.from_auth(auth)
    User.where(provider: auth["provider"], uid: auth["uid"]).first_or_initialize(
      refresh_token: auth["credentials"]["refresh_token"],
      access_token: auth["credentials"]["token"],
      expires: auth["credentials"]["expires_at"],
      first_name: auth["first_name"],
      last_name: auth["last_name"],
      image: auth["image"],
      email: auth["info"]["email"]
    )
  end
end
