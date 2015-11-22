class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :title, :phone, :created_at, :updated_at
end
