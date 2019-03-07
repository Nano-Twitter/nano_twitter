require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  attr_accessor         :password

  field :name, type: String
  field :password_hash, type: String
  field :email, type: String
  field :bio, type: String
  field :gender, type: Integer
  # field :follower, type: BSON::Binary
  # field :followee, type: BSON::Binary

  validates_presence_of :name, message: "Username is required."
  validates_uniqueness_of :name, message: "Username already in use. Try another one!"
  validates_presence_of :email, message: "Email address is required."
  validates_uniqueness_of :email, message: "Email address already in use. Forget password?"
  validates_length_of :password, minimum: 12, message: "Password must be at least 12-character long."
  # validates_confirmation_of :password, message: "Password confirmation must be the same as the password."

  before_save :encrypt_password

  def self.find_by_email(email)
    find_by(email: email).as_json
  end

  def self.authenticate(user_email, password)
    user = find_by_email user_email
    if user.nil?
      false
    else
      user_pass = Password.new(user.password_hash)
      user_pass == password
    end
  end

  private

  def encrypt_password
    self.password_hash = Password.create(@password)
  end

  def as_json(options={})
    attrs = super(options)
    attrs.delete("password_hash")
  end
end
