class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :product_items, :inverse_of => :user
  has_one :api_key

  before_create :get_api_key

  def get_api_key
    ApiKey.new(user: self).save!
  end
end
