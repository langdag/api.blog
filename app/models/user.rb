# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password        :string
#  password_digest :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    has_secure_token :token
    has_secure_password

    has_many :posts, class_name: "Post", foreign_key: "author_id", dependent: :destroy
    has_many :comments, dependent: :destroy
end
