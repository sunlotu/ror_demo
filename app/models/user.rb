require 'jwt'
class User < ApplicationRecord

  attr_accessor :login, :reset_password_token, :remember_me, :role_id
  has_secure_password
  has_secure_token

  validates :password, presence: true, on: :create
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

  include Roleable

  # before_save :encrypts_password
  after_create_commit :set_role
  # scope :by_login, ->(login) { where('name=? or email=?', login, login).first }


  class << self

    def visit_user(credentials={})
      where('name = :login or email = :login', { login: credentials[:login] }).first
    end

    def auth_user(credentials={})
      password = credentials[:password]
      user = visit_user(credentials)
      user.authenticate(password) if user
    end

  end

  def cookies_auth_user(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token) && self
  end

  def remember_me!
    self.regenerate_token
    self.remember_token
    save(validate: false) if self.changed?
  end

  def forget_me!
    self.remember_digest = nil
    save(validate: false)
  end

  def encode_token(exp = 2.day.from_now.to_i)
    JWT.encode({data: email, exp: exp}, password_digest)
  end

  def remember_token(cost = 10)
    self.remember_digest = BCrypt::Engine.hash_secret(token, BCrypt::Engine.generate_salt(cost))
  end

  private

  def set_role
    role_ship = self.build_role_ship
    role_ship.update(role: Role.find_by_code('user'))
    puts 'rs create end'
  end

  # def encrypts_password
  #   if password.present?
  #     self.password_salt = BCrypt::Engine.generate_salt
  #     self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
  #   end
  # end

end