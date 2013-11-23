class UserReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  has_many :days, dependent: :destroy
  validates_associated :days
  accepts_nested_attributes_for :days
  attr_accessible :days_attributes
end
