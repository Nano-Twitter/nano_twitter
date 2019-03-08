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

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_length_of :password, minimum: 12
  # validates_confirmation_of :password, message: "Password confirmation must be the same as the password."

  before_save :encrypt_password

  def self.find_by_email(email)
    find_by(email: email)
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

  def as_json(options={})
    attrs = super(options)
    attrs.delete("password_hash")
    attrs
  end

  private

  def encrypt_password
    self.password_hash = Password.create(@password)
  end
end
