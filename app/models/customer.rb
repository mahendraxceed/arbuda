class Customer < ApplicationRecord

  has_many :complains, :inverse_of => :customer

  validates_presence_of      :name, :mobile
  validates :mobile, format: { with: /\A\d{10}\z/, :allow_blank => true, message: "Invalid mobile Number. Please enter 10 digits (for example 9999999999)" }
  validates :alt_mobile, format: { with: /\A\d{10}\z/, :allow_blank => true, message: "Invalid mobile Number. Please enter 10 digits (for example 9999999999)" }
  validates_uniqueness_of   :name, allow_blank: true, message: "is already used to register a customer", if: :name_changed?
  validates_uniqueness_of   :mobile, message: "Mobile already taken. Use diffrent Mobile"

  def name_and_mobile
    "#{name} (#{mobile})"
  end

end
