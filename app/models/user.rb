class User < ApplicationRecord
    has_secure_token :token
    has_secure_password
end
