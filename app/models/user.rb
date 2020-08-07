class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  has_many :complains, foreign_key: "assigned_to_id"
  validates_presence_of      :name
  validates_presence_of     :email, if: :email_required?
  validates_uniqueness_of   :email, allow_blank: true, message: "is already used to register a user", if: :email_changed?
  validates_format_of       :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_blank: true, if: :email_changed?
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 8..128, allow_blank: true
  validates :mobile, format: { with: /\A\d{10}\z/, :allow_blank => true, message: "Invalid mobile Number. Please enter 10 digits (for example 9999999999)" }

end
