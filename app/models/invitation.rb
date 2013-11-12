class Invitation
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :sender, :recipient

  validates_presence_of :recipient
  validates_presence_of :sender
  validate :recipient_already_registered?, if: "recipient.present?"

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def recipient_named_email
    "#{recipient_name} <#{recipient}>"
  end

  def recipient_name
    recipient.split(/\.|@/)[0..1].map(&:capitalize).join(" ")
  end

  def persisted?
    false
  end

  private

  def recipient_already_registered?
    if Employee.exists?(email: recipient.downcase)
      errors.add(:recipient, "Recipient is registered")
    end
  end

end
