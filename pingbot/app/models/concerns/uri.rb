module Concerns::Uri
  extend ActiveSupport::Concern

  included do
    validates :uri, uniqueness: true

    after_create :generate_uri
  end

  def to_param
    uri
  end

  def generate_uri
    return if uri.present?
    self.uri = Hashids.new(salt, 4).encode(id)
    save!
  end

  def salt
    model_name.name
  end
end
