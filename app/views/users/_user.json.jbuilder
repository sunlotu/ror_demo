json.extract! user, :id, :name, :email, :password_salt, :encrypted_password, :remember_digest, :created_at, :updated_at
json.url user_url(user, format: :json)
