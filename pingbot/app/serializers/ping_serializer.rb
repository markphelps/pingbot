class PingSerializer < ActiveModel::Serializer
  attributes :uri, :name, :description, :status, :created_at, :updated_at, :unhealthy_at
end
