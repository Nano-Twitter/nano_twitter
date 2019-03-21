require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include BCrypt

  attr_accessor :password

  field :name, type: String
  field :password_hash, type: String
  field :email, type: String
  field :bio, type: String
  field :gender, type: Integer
  field :tweet_count, type: Integer
  # field :follower_count, type: Integer
  # field :following_count, type: Integer

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_length_of :password, minimum: 12
  # validates_confirmation_of :password, message: "Password confirmation must be the same as the password."


  # tentative association
  has_and_belongs_to_many :following, class_name: 'User', inverse_of: :followers, autosave: true, counter_cache: true
  has_and_belongs_to_many :followers, class_name: 'User', inverse_of: :following, counter_cache: true
  
  has_many :tweets

  before_save :encrypt_password


  def follow!(user)
    if self.following.include?(user)
      raise 'Duplicate following relationship.'
    elsif self.id != user.id
      self.following << user
    end
  end

  def unfollow!(user)
    self.following.delete(user)
  end


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

  def as_json(options = {})
    attrs = super(options)
    attrs.delete("password_hash")
    attrs
  end

  private

  def encrypt_password
    self.password_hash = Password.create(@password)
  end
end
