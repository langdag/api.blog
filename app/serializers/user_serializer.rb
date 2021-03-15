class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :token, :password, :password_digest
end
