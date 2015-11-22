class Organization < ActiveRecord::Base
  before_create :generate_token

  validates :name, presence: true, length: { maximum: 255 }
  validates :token, uniqueness: true

  has_many :pings
  has_many :users

  private

  def generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      unless Organization.exists?(token: token)
        self.token = token
        break
      end
    end
  end
end
