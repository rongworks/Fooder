class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_access_token
  validates_uniqueness_of :access_token
  validates_presence_of  :user_id

  def self.get_user(token)
    key = ApiKey.find_by_access_token(token);
    return key.user
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
    self.expires_at= 1.year.from_now
  end
end
