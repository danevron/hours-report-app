class User < ActiveRecord::Base
  has_roles

  has_many :timesheets
  has_many :reports, :through => :timesheets

  scope :active_users, -> { where(status: "active") }

  after_create :join_current_report, :if => "current_report"

  validates_uniqueness_of :uid, scope: :provider
  validates_presence_of :employee_number
  validate :invited_user, :on => :create

  def self.from_auth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first
  end

  def self.create_from_auth(auth)
    new({
      uid:           auth["uid"],
      provider:      auth["provider"],
      refresh_token: auth["credentials"]["refresh_token"],
      access_token:  auth["credentials"]["token"],
      expires:       auth["credentials"]["expires_at"],
      first_name:    auth["info"]["first_name"],
      last_name:     auth["info"]["last_name"],
      image:         auth["info"]["image"],
      email:         auth["info"]["email"]
    })
  end

  def name
    "#{first_name} #{last_name}"
  end

  def current_timesheet
    current_report.timesheets.find_by(:user_id => id) if current_report
  end


  def access_token_for_api
    refresh_access_token! unless token_is_valid?
    self.access_token
  end

  def invited?
    Invitation.find_by(:recipient => self.email)
  end

  def not_invited?
    !invited?
  end

  private

  def invited_user
    errors[:base] << "User is not invited"  unless invited?
  end

  def token_is_valid?
    token_validation[:audience] == ENV['GOOGLE_KEY']
  end

  def refresh_access_token!
    body = {
      'refresh_token' => self.refresh_token,
      'client_id'     => ENV['GOOGLE_KEY'],
      'client_secret' => ENV['GOOGLE_SECRET'],
      'grant_type'    => 'refresh_token'
    }
    response = Typhoeus.post("https://accounts.google.com/o/oauth2/token", body: body)
    user_tokens = JSON.parse(response.body)

    self.access_token = user_tokens['access_token']
    self.expires = user_tokens['expires_in']
    save
  end

  def token_validation
    @token_validation ||= begin
      options  = {
        :params => { :access_token => self.access_token }
      }
      response = Typhoeus.get("https://www.googleapis.com/oauth2/v1/tokeninfo", options)
      HashWithIndifferentAccess.new(JSON.parse(response.body))
    end
  end

  def join_current_report
    current_report.add_new_user(self)
  end

  def current_report
    Report.current_report
  end
end
